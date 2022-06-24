
<#PSScriptInfo

.VERSION 1.2.4

.GUID 73cfd5d4-233b-4c97-bfad-0f280a0188dc

.AUTHOR Pierre Smit

.COMPANYNAME HTPCZA Tech

.COPYRIGHT

.TAGS api ctx ps

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Created [06/10/2021_18:14] Initial Script Creating
Updated [06/10/2021_19:01] "Help Files Added"
Updated [07/10/2021_13:28] Script info updated for module
Updated [03/11/2021_19:17] Info Update
Updated [06/11/2021_16:48] Using the new api

.PRIVATEDATA

#>







<#

.DESCRIPTION
"Reports on connection failures"

#>





<#
.SYNOPSIS
Reports on failures in the last x hours.

.DESCRIPTION
Reports on machine or connection failures in the last x hours.

.PARAMETER APIHeader
Use Connect-CTXAPI to create headers.

.PARAMETER MonitorData
Use Get-CTXAPI_MonitorData to create OData.

.PARAMETER region
Your Cloud instance hosted region.

.PARAMETER hours
Amount of time to report on.

.PARAMETER FailureType
Type of failure to report on

.PARAMETER Export
In what format to export the reports.

.PARAMETER ReportPath
Destination folder for the exported report.

.EXAMPLE
Get-CTXAPI_FailureReport -MonitorData $MonitorData -FailureType Connection

#>

Function Get-CTXAPI_FailureReport {
    [Cmdletbinding(DefaultParameterSetName = 'Fetch odata', HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_FailureReport')]
    [Alias('Get-CTXAPI_FailureReports')]
    [OutputType([System.Object[]])]
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
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('Connection', 'Machine')]
        [string]$FailureType,
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

    if ($FailureType -eq 'Machine') {
        $machines = Get-CTXAPI_Machines -APIHeader $APIHeader
        foreach ($log in $mondata.MachineFailureLogs) {
            $MonDataMachine = $mondata.Machines | Where-Object { $_.id -eq $log.MachineId }
            $APIMachine = $machines | Where-Object { $_.dnsname -like $MonDataMachine.DnsName }
            $data += [PSCustomObject]@{
                Name                     = $MonDataMachine.DnsName
                IP                       = $MonDataMachine.IPAddress
                OSType                   = $MonDataMachine.OSType
                FailureStartDate         = $log.FailureStartDate
                FailureEndDate           = $log.FailureEndDate
                FaultState               = $log.FaultState
                LastDeregistrationReason = $APIMachine.LastDeregistrationReason
                LastConnectionFailure    = $APIMachine.LastConnectionFailure
                LastErrorReason          = $APIMachine.LastErrorReason
                CurrentFaultState        = $APIMachine.FaultState

            }

        }
    }
    if ($FailureType -eq 'Connection') {
        foreach ($log in $mondata.ConnectionFailureLogs) {
            $session = $mondata.Session | Where-Object { $_.SessionKey -eq $log.SessionKey }
            $user = $mondata.users | Where-Object { $_.id -like $Session.UserId }
            $mashine = $mondata.machines | Where-Object { $_.id -like $Session.MachineId }
            $data += [PSCustomObject]@{
                UserName                   = $user.UserName
                FullName                   = $user.FullName
                DnsName                    = $mashine.DnsName
                IPAddress                  = $mashine.IPAddress
                CurrentRegistrationState   = $RegistrationState.($mashine.CurrentRegistrationState)
                FailureDate                = $log.FailureDate
                ConnectionFailureEnumValue	= $SessionFailureCode.($log.ConnectionFailureEnumValue)
            }
        }
    }



    if ($Export -eq 'Excel') { 
        $ExcelOptions = @{
            Path             = $ReportPath + '\Failure_Audit-' + (Get-Date -Format yyyy.MM.dd-HH.mm) + '.xlsx'
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
    if ($Export -eq 'HTML') { $data | Out-HtmlView -DisablePaging -Title 'Citrix Failures' -HideFooter -SearchHighlight -FixedHeader }
    if ($Export -eq 'Host') { $data }

} #end Function
