
<#PSScriptInfo

.VERSION 1.1.7

.GUID ccc3348a-02f0-4e82-91bf-d65549ca3533

.AUTHOR Pierre Smit

.COMPANYNAME HTPCZA Tech

.COPYRIGHT

.TAGS api citrix ctx cvad ps

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Created [20/04/2021_10:46] Initial Script Creating
Updated [22/04/2021_11:42] Script File Info was updated
Updated [05/05/2021_00:03] added monitor data
Updated [05/05/2021_14:33] 'Update Manifest'
Updated [05/10/2021_21:22] Module Info Updated
Updated [07/10/2021_13:28] Script info updated for module
Updated [03/11/2021_19:17] Info Update
Updated [06/11/2021_16:48] Using the new api

.PRIVATEDATA

#>









<#
.DESCRIPTION
Reports on user session connections for the last X hours.
Fetches CVAD Monitor OData (or uses provided `MonitorData`) and builds a connection dataset including client details, timing, registration state, and avg ICA RTT.

#>

<#
.SYNOPSIS
Creates a connection report from CVAD Monitor data.

.DESCRIPTION
Reports on user session connections for the last X hours.

.PARAMETER APIHeader
Header object created by Connect-CTXAPI; contains authentication and request headers (used to fetch Monitor OData).

.PARAMETER MonitorData
Pre-fetched CVAD Monitor OData created by Get-CTXAPI_MonitorData. If provided, the cmdlet will not fetch data.

.PARAMETER region
Deprecated. Not required.

.PARAMETER hours
Duration window (in hours) to fetch when retrieving Monitor OData. Default: 24.

.PARAMETER Export
Destination/output for the report. Supported values: Host, Excel, HTML. Default: Host.

.PARAMETER ReportPath
Destination folder for exported files when using Excel or HTML. Defaults to $env:Temp.

.EXAMPLE
Get-CTXAPI_ConnectionReport -MonitorData $MonitorData -Export HTML -ReportPath c:\temp
Generates an HTML report titled "Citrix Sessions" with the full dataset.

.EXAMPLE
Get-CTXAPI_ConnectionReport -APIHeader $APIHeader -hours 48 -Export Excel -ReportPath c:\temp
Fetches 48 hours of Monitor data and exports an Excel workbook (Session_Audit-<yyyy.MM.dd-HH.mm>.xlsx).

.EXAMPLE
Get-CTXAPI_ConnectionReport -APIHeader $APIHeader | Select-Object Upn, DnsName, EstablishmentDate, AVG_ICA_RTT
Returns objects to the host and selects common fields for quick inspection.

.INPUTS
None. Parameters are not accepted from the pipeline.

.OUTPUTS
System.Object[]
When Export is Host: array of connection report objects; when Export is Excel/HTML: no output objects and files are written to ReportPath.

.LINK
https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_ConnectionReport

#>

function Get-CTXAPI_ConnectionReport {
    [Cmdletbinding(DefaultParameterSetName = 'Fetch odata', HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_ConnectionReport')]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'Fetch odata')]
        [ValidateNotNullOrEmpty()]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader,
        [Parameter(Mandatory = $false, ParameterSetName = 'Got odata')]
        [PSTypeName('CTXMonitorData')]$MonitorData,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $false, ParameterSetName = 'Fetch odata')]
        [int]$hours = 24,
        [Parameter(Mandatory = $false)]
        [ValidateSet('Excel', 'HTML')]
        [string]$Export = 'Host',
        [Parameter(Mandatory = $false)]
        [ValidateScript( { (Test-Path $_) })]
        [string]$ReportPath = $env:temp
    )




    if ($Null -eq $MonitorData) { $mondata = Get-CTXAPI_MonitorData -APIHeader $APIHeader -LastHours $hours }
    else { $mondata = $MonitorData }

    [System.Collections.generic.List[PSObject]]$data = @()
        

    foreach ($connection in $mondata.Connections) {
        Write-Verbose "[$(Get-Date -Format HH:mm:ss) PROCESS] $($mondata.Connections.IndexOf($connection) + 1) of $($mondata.Connections.Count)"
        try {
            $OneSession = $mondata.session | Where-Object { $_.SessionKey -eq $connection.SessionKey }
            $user = $mondata.users | Where-Object { $_.id -like $OneSession.UserId }
            $mashine = $mondata.machines | Where-Object { $_.id -like $OneSession.MachineId }
            try {
                $avgrtt = 0
                $avgrtt = $mondata.SessionMetrics | Where-Object { $_.Sessionid -like $OneSession.SessionKey } | Measure-Object -Property IcaRttMS -Average
            } catch { Write-Warning "Not enough RTT data - $_.Exception.Message" }
        } catch { Write-Warning "Error processing - $_.Exception.Message" }
        $data.Add([PSCustomObject]@{
                Id                       = $connection.id
                # FullName                 = if ($user.FullName -eq $null) { $user.FullName } else { $user.upn }
                Upn                      = $user.upn
                ConnectionState          = $ConnectionState.($OneSession.ConnectionState)
                DnsName                  = $mashine.DnsName
                IPAddress                = $mashine.IPAddress
                IsInMaintenanceMode      = $mashine.IsInMaintenanceMode
                CurrentRegistrationState = $RegistrationState.($mashine.CurrentRegistrationState)
                OSType                   = $mashine.OSType
                ClientName               = $connection.ClientName
                ClientVersion            = $connection.ClientVersion
                ClientAddress            = $connection.ClientAddress
                ClientPlatform           = $connection.ClientPlatform
                IsReconnect              = $connection.IsReconnect
                IsSecureIca              = $connection.IsSecureIca
                Protocol                 = $connection.Protocol
                EstablishmentDate        = $connection.EstablishmentDate
                LogOnStartDate           = $connection.LogOnStartDate
                LogOnEndDate             = $connection.LogOnEndDate
                AuthenticationDuration   = $connection.AuthenticationDuration
                LogOnDuration            = $OneSession.LogOnDuration
                DisconnectDate           = $connection.DisconnectDate
                EndDate                  = $OneSession.EndDate
                ExitCode                 = $SessionFailureCode.($OneSession.ExitCode)
                FailureDate              = $OneSession.FailureDate
                AVG_ICA_RTT              = if ($null -eq $avgrtt) { 0 } else { [math]::Round($avgrtt.Average) }
            }) #PSList
    }
    
    if ($Export -eq 'Excel') { 
        $ExcelOptions = @{
            Path             = $ReportPath + '\Session_Audit-' + (Get-Date -Format yyyy.MM.dd-HH.mm) + '.xlsx'
            AutoSize         = $True
            AutoFilter       = $True
            TitleBold        = $True
            TitleSize        = '28'
            TitleFillPattern = 'LightTrellis'
            TableStyle       = 'Light20'
            FreezeTopRow     = $True
            FreezePane       = '3'
        }
        $data | Export-Excel -Title Sessions -WorksheetName Sessions @ExcelOptions
    }
    if ($Export -eq 'HTML') { $data | Out-HtmlView -DisablePaging -Title 'Citrix Sessions' -HideFooter -SearchHighlight -FixedHeader }
    if ($Export -eq 'Host') { $data }

} #end Function
