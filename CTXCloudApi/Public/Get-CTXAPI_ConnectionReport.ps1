
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
Report on connections in the last x hours

#>

<#
.SYNOPSIS
Creates Connection report

.DESCRIPTION
Report on connections in the last x hours

.PARAMETER APIHeader
Use Connect-CTXAPI to create headers

.PARAMETER MonitorData
Use Get-CTXAPI_MonitorData to create OData

.PARAMETER region
You Cloud region

.PARAMETER hours
Duration of the report

.PARAMETER Export
In what format to export the reports.

.PARAMETER ReportPath
Destination folder for the exported report.

.EXAMPLE
Get-CTXAPI_ConnectionReport -MonitorData $MonitorData -Export HTML -ReportPath c:\temp

#>

Function Get-CTXAPI_ConnectionReport {
    [Cmdletbinding(DefaultParameterSetName = 'Fetch odata', HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_ConnectionReport')]
    PARAM(
        [Parameter(Mandatory = $true, ParameterSetName = 'Fetch odata')]
        [ValidateNotNullOrEmpty()]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader,
        [Parameter(Mandatory = $false, ParameterSetName = 'Got odata')]
        [PSTypeName('CTXMonitorData')]$MonitorData,
        [Parameter(Mandatory = $false, ParameterSetName = 'Fetch odata')]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('us', 'eu', 'ap-s')]
        [string]$region,
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




    if ($Null -eq $MonitorData) { $mondata = Get-CTXAPI_MonitorData -APIHeader $APIHeader -region $region -hours $hours }
    else { $mondata = $MonitorData }

    $data = @()
    foreach ($connection in $mondata.Connections) {
        try {
            $OneSession = $mondata.session | Where-Object { $_.SessionKey -eq $connection.SessionKey }
            $user = $mondata.users | Where-Object { $_.id -like $OneSession.UserId }
            $mashine = $mondata.machines | Where-Object { $_.id -like $OneSession.MachineId }
            try {
                $avgrtt = 0
                $avgrtt = $mondata.SessionMetrics | Where-Object { $_.Sessionid -like $OneSession.SessionKey } | Measure-Object -Property IcaRttMS -Average
            }
            catch { Write-Warning "Not enough RTT data - $_.Exception.Message" }
        }
        catch { Write-Warning "Error processing - $_.Exception.Message" }
        $data += [PSCustomObject]@{
            Id                       = $connection.id
            FullName                 = $user.FullName
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
            AVG_ICA_RTT              = [math]::Round($avgrtt.Average)
        }
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
