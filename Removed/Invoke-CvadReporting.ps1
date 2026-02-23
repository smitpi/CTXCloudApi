<#
.SYNOPSIS
  Build a single multi-worksheet Excel report from CVAD Monitor data already in memory.

.DESCRIPTION
  Writes all management & admin reports into one .xlsx using the Excel*Import* module
  (auto-detects either 'ImportExcel' or 'ExcelImport' module naming).

.PARAMETER Data
  PSCustomObject with arrays:
    Connections, LogOnSummaries, DesktopOSDesktopSummaries,
    ConnectionFailureLogs, FailureLogSummaries,
    DesktopGroups, Catalogs, MachineCosts

.PARAMETER Path
  Target .xlsx path to produce (will overwrite unless -Append is used).

.PARAMETER DurationsAreMilliseconds
  Use when LogOnSummaries durations are in milliseconds (default in CVAD Monitor).
  Converts stage averages to seconds.

.PARAMETER Append
  Keep existing workbook and add/replace sheets instead of starting fresh.

.EXAMPLE
  . .\New-CvadExcelReport.ps1
  New-CvadExcelReport -Data $Data -Path .\Cvad-Report.xlsx -DurationsAreMilliseconds
#>
function New-CvadExcelReport {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][object]$Data,
        [Parameter(Mandatory)][string]$Path,
        [switch]$DurationsAreMilliseconds,
        [switch]$Append
    )

    # -------------------- Module bootstrap --------------------
    $moduleLoaded = $false
    foreach ($name in @('ImportExcel', 'ExcelImport')) {
        if (Get-Module -ListAvailable -Name $name) {
            Import-Module $name -ErrorAction Stop
            $moduleLoaded = $true
            break
        }
    }
    if (-not $moduleLoaded) {
        throw 'Excel*Import* module not found. Install with: Install-Module ImportExcel -Scope CurrentUser'
    }

    # Helper shortcut for cmdlets (the cmdlet name is identical in ImportExcel)
    $ExportExcel = Get-Command Export-Excel -ErrorAction SilentlyContinue
    if (-not $ExportExcel) { throw 'Export-Excel cmdlet not available.' }

    # -------------------- Helpers --------------------
    $local:_ToSec = {
        param([double]$v)
        if ($null -eq $v) { return $null }
        if ($DurationsAreMilliseconds) { return [math]::Round($v / 1000, 2) }
        else { return [math]::Round($v, 2) }
    }
    $local:_SafeDouble = {
        param($v)
        if ($null -eq $v) { return $null }
        $d = 0.0
        if ([double]::TryParse($v.ToString(), [ref]$d)) { return $d } else { return $null }
    }
    $local:_NZ = {
        param($v, $def = 'Unknown')
        if ($null -eq $v -or ($v -is [string] -and [string]::IsNullOrWhiteSpace($v))) { return $def }
        return $v
    }
    $local:_AsArray = { param($x) @($x) } # normalize nulls to empty arrays

    function _ToSec([double]$v) {
        if ($null -eq $v) { return $null }
        if ($DurationsAreMilliseconds) { return [math]::Round($v / 1000, 2) }
        else { return [math]::Round($v, 2) }
    }
    function _SafeDouble($v) {
        if ($null -eq $v) { return $null }
        $d = 0.0
        if ([double]::TryParse($v.ToString(), [ref]$d)) { return $d } else { return $null }
    }
    function _NZ($v, $def = 'Unknown') {
        if ($null -eq $v -or ($v -is [string] -and [string]::IsNullOrWhiteSpace($v))) { return $def }
        return $v
    }
    function _AsArray($x) { @($x) }

    # -------------------- Pull arrays --------------------
    $Connections = _AsArray $Data.Connections
    $LogOnSummaries = _AsArray $Data.LogOnSummaries
    $DesktopOSDesktopSummaries = _AsArray $Data.DesktopOSDesktopSummaries
    $ConnectionFailureLogs = _AsArray $Data.ConnectionFailureLogs
    $FailureLogSummaries = _AsArray $Data.FailureLogSummaries
    $DesktopGroups = _AsArray $Data.DesktopGroups
    $Catalogs = _AsArray $Data.Catalogs
    $MachineCosts = _AsArray $Data.MachineCosts

    # -------------------- Lookups --------------------
    $dgNameById = @{}
    foreach ($dg in $DesktopGroups) {
        if ($null -ne $dg) {
            $dgNameById[$dg.Id] = $dg.Name
        }
    }

    # -------------------- Usage / Adoption --------------------
    $totalConnections = $Connections.Count
    $uniqueClients = ($Connections | Where-Object { $_.ClientName } | Select-Object -ExpandProperty ClientName -Unique).Count

    # Platform distribution
    $usagePlatforms = $Connections |
        Group-Object { _NZ $_.ClientPlatform } |
            Sort-Object Count -Descending |
                ForEach-Object {
                    [pscustomobject]@{
                        ClientPlatform = $_.Name
                        Count          = $_.Count
                        SharePct       = [math]::Round(100 * ($_.Count / [math]::Max(1, $totalConnections)), 2)
                    }
                }

    # Client version Top 10 (major.minor)
    $usageClientVersions = $Connections |
        ForEach-Object {
            $v = $_.ClientVersion
            if ($null -eq $v) { $mm = 'Unknown' }
            else {
                $parts = ($v -split '[^\d]') | Where-Object { $_ }
                if ($parts.Count -ge 2) { $mm = '{0}.{1}' -f $parts[0], $parts[1] }
                elseif ($parts.Count -eq 1) { $mm = $parts[0] }
                else { $mm = 'Unknown' }
            }
            [pscustomobject]@{ Version = $mm }
        } | Group-Object Version | Sort-Object Count -Descending | Select-Object -First 10 |
            ForEach-Object {
                [pscustomobject]@{
                    Version  = $_.Name
                    Count    = $_.Count
                    SharePct = [math]::Round(100 * ($_.Count / [math]::Max(1, $totalConnections)), 2)
                }
            }

    # Country top 10
    $usageCountries = $Connections |
        Group-Object { _NZ $_.ClientLocationCountry } |
            Sort-Object Count -Descending | Select-Object -First 10 |
                ForEach-Object { [pscustomobject]@{ Country = $_.Name; Count = $_.Count } }

    # -------------------- Experience / SLA --------------------
    $ls = $LogOnSummaries | Where-Object { $_.Granularity -eq 60 }

    $stagePairs = @(
        @{ Dur = 'BrokeringDuration'; Cnt = 'BrokeringCount' }
        @{ Dur = 'VMStartDuration'; Cnt = 'VMStartCount' }
        @{ Dur = 'VMPowerOnDuration'; Cnt = 'VMStartCount' }
        @{ Dur = 'VMRegistrationDuration'; Cnt = 'VMStartCount' }
        @{ Dur = 'HdxDuration'; Cnt = 'HdxCount' }
        @{ Dur = 'AuthenticationDuration'; Cnt = 'AuthenticationCount' }
        @{ Dur = 'GpoDuration'; Cnt = 'GpoCount' }
        @{ Dur = 'LogOnScriptsDuration'; Cnt = 'LogOnScriptsCount' }
        @{ Dur = 'InteractiveDuration'; Cnt = 'InteractiveCount' }
        @{ Dur = 'ProfileLoadDuration'; Cnt = 'ProfileLoadCount' }
        @{ Dur = 'ClientLogOnDuration'; Cnt = 'ClientLogOnCount' }
    )

    # Weighted stage averages (sec)
    $experienceStageAverages = foreach ($p in $stagePairs) {
        $durSum = 0.0; $cntSum = 0.0
        foreach ($row in $ls) {
            $d = _SafeDouble $row.($p.Dur)
            $c = _SafeDouble $row.($p.Cnt)
            if ($d -and $c -gt 0) { $durSum += $d; $cntSum += $c }
        }
        $avgSec = if ($cntSum -gt 0) { _ToSec ($durSum / $cntSum) } else { $null }
        [pscustomobject]@{ Stage = $p.Dur; AvgSeconds = $avgSec }
    }

    # Worst hours by estimated total logon (sum of per-stage hourly averages)
    $byHour = $ls | Group-Object { [datetime]$_.SummaryDate }
    $experienceWorstHours = $byHour | ForEach-Object {
        $hour = $_.Name
        $total = 0.0
        foreach ($p in $stagePairs) {
            $dur = ($_.Group | Measure-Object -Property $($p.Dur) -Sum).Sum
            $cnt = ($_.Group | Measure-Object -Property $($p.Cnt) -Sum).Sum
            if ($cnt -gt 0 -and $null -ne $dur) { $total += ($dur / $cnt) }
        }
        [pscustomobject]@{ Hour = $hour; AvgLogonSeconds = (_ToSec $total) }
    } | Sort-Object AvgLogonSeconds -Descending

    # Peak concurrency (sum over DGs per hour)
    $desk = $DesktopOSDesktopSummaries | Where-Object { $_.Granularity -eq 60 }
    $experiencePeaks = $desk | Group-Object SummaryDate | ForEach-Object {
        [pscustomobject]@{
            Hour           = [datetime]$_.Name
            PeakConcurrent = ($_.Group | Measure-Object -Property PeakConcurrentInstanceCount -Sum).Sum
        }
    } | Sort-Object Hour
    $overallPeakRow = $experiencePeaks | Sort-Object PeakConcurrent -Descending | Select-Object -First 1

    # Per-connection brokering p50/p95 (sec)
    $brokValues = $Connections | ForEach-Object { _SafeDouble $_.BrokeringDuration } | Where-Object { $_ -ne $null } | Sort-Object
    function _Percentile([double[]]$values, [double]$p) {
        if (-not $values -or $values.Count -eq 0) { return $null }
        $k = [math]::Round(($values.Count - 1) * $p, 0)
        return $values[[int][math]::Max(0, [math]::Min($k, $values.Count - 1))]
    }
    $brokMedian = _Percentile $brokValues 0.5
    $brokP95 = _Percentile $brokValues 0.95
    $brokeringStats = @(
        [pscustomobject]@{ Metric = 'Brokering Median (sec)'; Value = [math]::Round($brokMedian, 2) }
        [pscustomobject]@{ Metric = 'Brokering P95 (sec)'; Value = [math]::Round($brokP95, 2) }
    )

    # -------------------- Reliability --------------------
    $reliabilityByCode = $ConnectionFailureLogs |
        Group-Object ConnectionFailureEnumValue |
            Sort-Object Count -Descending |
                ForEach-Object { [pscustomobject]@{ FailureCode = $_.Name; Count = $_.Count } }

    $reliabilityByDesktopGroup = $FailureLogSummaries |
        Group-Object DesktopGroupId |
            ForEach-Object {
                $dg = $_.Name
                [pscustomobject]@{
                    DesktopGroupName = _NZ $dgNameById[$dg]
                    TotalFailures    = ($_.Group | Measure-Object -Property FailureCount -Sum).Sum
                }
            } | Sort-Object TotalFailures -Descending

    # -------------------- Security --------------------
    $securitySecureIca = $Connections |
        Group-Object ClientPlatform |
            ForEach-Object {
                $plat = _NZ $_.Name
                $vals = $_.Group | ForEach-Object { [bool]$_.IsSecureIca }
                $rate = if ($vals.Count -gt 0) { [math]::Round(100 * (($vals | Where-Object { $_ }).Count / $vals.Count), 2) } else { $null }
                [pscustomobject]@{ ClientPlatform = $plat; SecureIcaPercent = $rate; Samples = $vals.Count }
            } | Sort-Object SecureIcaPercent -Descending

    $securityHtml5ByIsp = $Connections |
        ForEach-Object {
            $isHtml5 = ($_.ClientPlatform -match 'HTML5') -or ($_.WorkspaceType -eq 'HTML5' -or $_.WorkspaceType -eq 4)
            [pscustomobject]@{ ClientISP = _NZ $_.ClientISP; IsHtml5 = [bool]$isHtml5 }
        } | Group-Object ClientISP | ForEach-Object {
            $total = $_.Group.Count
            $share = if ($total -gt 0) { [math]::Round(100 * (($_.Group | Where-Object { $_.IsHtml5 }).Count / $total), 2) } else { 0 }
            [pscustomobject]@{ ClientISP = $_.Name; Html5SharePercent = $share; Sample = $total }
        } | Sort-Object Html5SharePercent -Descending

    # -------------------- Cost readiness --------------------
    $costSpecCurrency = $MachineCosts |
        Group-Object SpecId, Currency |
            ForEach-Object {
                $grp = $_.Group
                [pscustomobject]@{
                    SpecId                     = $grp[0].SpecId
                    Currency                   = $grp[0].Currency
                    CostPerHour                = [math]::Round((($grp | Measure-Object -Property CostPerHour -Average).Average), 6)
                    PowerOnComputeCostPerHour  = [math]::Round((($grp | Measure-Object -Property PowerOnComputeCostPerHour -Average).Average), 6)
                    PowerOnStorageCostPerHour  = [math]::Round((($grp | Measure-Object -Property PowerOnStorageCostPerHour -Average).Average), 6)
                    PowerOffStorageCostPerHour = [math]::Round((($grp | Measure-Object -Property PowerOffStorageCostPerHour -Average).Average), 6)
                }
            } | Sort-Object SpecId, Currency

    # -------------------- Summary sheet payload --------------------
    $summary = @()
    $summary += [pscustomobject]@{ KPI = 'Total Connections'; Value = $totalConnections }
    $summary += [pscustomobject]@{ KPI = 'Unique Clients'; Value = $uniqueClients }
    if ($overallPeakRow) {
        $summary += [pscustomobject]@{ KPI = 'Peak Concurrent Sessions'; Value = $overallPeakRow.PeakConcurrent }
        $summary += [pscustomobject]@{ KPI = 'Peak Time (UTC)'; Value = ($overallPeakRow.Hour.ToString('yyyy-MM-dd HH:mm')) }
    }
    $bm = $brokeringStats | Where-Object { $_.Metric -like '*Median*' } | Select-Object -First 1
    $bp = $brokeringStats | Where-Object { $_.Metric -like '*P95*' } | Select-Object -First 1
    if ($bm) { $summary += [pscustomobject]@{ KPI = $bm.Metric; Value = $bm.Value } }
    if ($bp) { $summary += [pscustomobject]@{ KPI = $bp.Metric; Value = $bp.Value } }

    # -------------------- Write Excel (single workbook) --------------------
    if (-not $Append -and (Test-Path -LiteralPath $Path)) { Remove-Item -LiteralPath $Path -Force }

    # A small helper to write any table to a worksheet
    function _WriteSheet([string]$Sheet, [object[]]$Rows, [string]$TableName) {
        if (-not $Rows) { $Rows = @([pscustomobject]@{ Info = '(no data)' }) }
        $Rows | Export-Excel -Path $Path -WorksheetName $Sheet -TableName $TableName -AutoSize `
            -BoldTopRow -FreezeTopRow -AutoFilter -ClearSheet
    }

    _WriteSheet -Sheet 'Summary' -Rows $summary -TableName 'tSummary'

    # Usage
    _WriteSheet -Sheet 'Usage_Platforms' -Rows $usagePlatforms -TableName 'tUsagePlatforms'
    _WriteSheet -Sheet 'Usage_ClientVersions' -Rows $usageClientVersions -TableName 'tUsageClientVersions'
    _WriteSheet -Sheet 'Usage_Countries' -Rows $usageCountries -TableName 'tUsageCountries'

    # Experience / SLA
    _WriteSheet -Sheet 'Experience_StageAverages' -Rows $experienceStageAverages -TableName 'tStageAverages'
    _WriteSheet -Sheet 'Experience_WorstHours' -Rows ($experienceWorstHours | Select-Object -First 100) -TableName 'tWorstHours'
    _WriteSheet -Sheet 'Experience_PeakConcurrency' -Rows $experiencePeaks -TableName 'tPeakConcurrency'
    _WriteSheet -Sheet 'Experience_BrokeringStats' -Rows $brokeringStats -TableName 'tBrokering'

    # Reliability
    _WriteSheet -Sheet 'Reliability_ByCode' -Rows $reliabilityByCode -TableName 'tFailByCode'
    _WriteSheet -Sheet 'Reliability_ByDesktopGroup' -Rows $reliabilityByDesktopGroup -TableName 'tFailByDG'

    # Security
    _WriteSheet -Sheet 'Security_SecureICA' -Rows $securitySecureIca -TableName 'tSecureICA'
    _WriteSheet -Sheet 'Security_HTML5_ByISP' -Rows $securityHtml5ByIsp -TableName 'tHtml5ByISP'

    # Cost
    _WriteSheet -Sheet 'Cost_SpecCurrency' -Rows $costSpecCurrency -TableName 'tCostSpecCurrency'

    # Optional: add a README with glossary
    $readme = @"
This workbook was generated by New-CvadExcelReport on $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss').
Key notes:
- Durations are reported in seconds. $(if ($DurationsAreMilliseconds) { 'Raw values were converted from milliseconds.' } else { 'Raw values were assumed to be seconds.' })
- 'Worst Hours' are computed as the sum of per-stage hourly averages (approximation).
- HTML5 share counts a session as HTML5 if ClientPlatform=HTML5 OR WorkspaceType='HTML5' (or 4).
- Failure codes mirror Citrix Monitor 'ConnectionFailureEnumValue' and FailureLogSummaries.FailureCode.
"@ | ForEach-Object { [pscustomobject]@{ Notes = $_ } }

    _WriteSheet -Sheet 'README' -Rows $readme -TableName 'tReadme'

    Write-Host "Excel report written to: $Path" -ForegroundColor Green
}