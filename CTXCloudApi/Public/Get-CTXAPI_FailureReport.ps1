
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

function Get-CTXAPI_FailureReport {
    [Cmdletbinding(DefaultParameterSetName = 'Fetch odata', HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_FailureReport')]
    [Alias('Get-CTXAPI_FailureReports')]
    [OutputType([System.Object[]])]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader,
        [Parameter(Mandatory = $false, ParameterSetName = 'Got odata')]
        [PSTypeName('CTXMonitorData')]$MonitorData,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $false)]
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

    if ($Null -eq $MonitorData) { $mondata = Get-CTXAPI_MonitorData -APIHeader $APIHeader -hours $hours }
    else { $mondata = $MonitorData }

    [System.Collections.generic.List[PSObject]]$Data = @()
        
    if ($FailureType -eq 'Machine') {
        Write-Verbose "[$(Get-Date -Format HH:mm:ss) PROCESS] ""Fetching machine data from API"
        $machines = Get-CTXAPI_Machine -APIHeader $APIHeader
        foreach ($log in $mondata.MachineFailureLogs) {
            $MonDataMachine = $mondata.machines | Where-Object { $_.id -like $log.MachineId }
            $MachinesFiltered = $machines | Where-Object {$_.Name -like $MonDataMachine.Name }
            $Data.Add([PSCustomObject]@{
                    Name                     = $MonDataMachine.DnsName
                    AssociatedUserUPNs       = $MonDataMachine.AssociatedUserUPNs
                    OSType                   = $MonDataMachine.OSType
                    FailureStartDate         = $log.FailureStartDate
                    FailureEndDate           = $log.FailureEndDate
                    FaultState               = $MachineFaultStateCode.($log.FaultState)
                    LastDeregistrationReason = $MachinesFiltered.LastDeregistrationReason 
                    LastDeregistrationTime   = $MachinesFiltered.LastDeregistrationTime
                    LastConnectionFailure    = $MachinesFiltered.LastConnectionFailure
                    LastErrorReason          = $MachinesFiltered.LastErrorReason
                    CurrentFaultState        = $MachinesFiltered.FaultState
                    InMaintenanceMode        = $MachinesFiltered.InMaintenanceMode
                    MaintenanceModeReason    = $MachinesFiltered.MaintenanceModeReason
                    RegistrationState        = $MachinesFiltered.RegistrationState
                })

        }
    }
    if ($FailureType -eq 'Connection') {
        foreach ($log in $mondata.ConnectionFailureLogs) {
            $session = $mondata.Session | Where-Object { $_.SessionKey -eq $log.SessionKey }
            $user = $mondata.users | Where-Object { $_.id -like $Session.UserId }
            $mashine = $mondata.machines | Where-Object { $_.id -like $Session.MachineId }
            $Data.Add([PSCustomObject]@{
                    User                       = $user.Upn
                    DnsName                    = $mashine.DnsName
                    CurrentRegistrationState   = $RegistrationState.($mashine.CurrentRegistrationState)
                    FailureDate                = $log.FailureDate
                    ConnectionFailureEnumValue	= $SessionFailureCode.($log.ConnectionFailureEnumValue)
                    IsInMaintenanceMode        = $log.IsInMaintenanceMode
                    PowerState                 = $PowerStateCode.($log.PowerState)
                    RegistrationState          = $RegistrationState.($log.RegistrationState)

                })
        }
    }



    if ($Export -eq 'Excel') { 
        $ExcelOptions = @{
            Path             = $ReportPath + "\$($FailureType)_Failure_Report_" + (Get-Date -Format yyyy.MM.dd-HH.mm) + '.xlsx'
            AutoSize         = $True
            AutoFilter       = $True
            TitleBold        = $True
            TitleSize        = '28'
            TitleFillPattern = 'LightTrellis'
            TableStyle       = 'Light20'
            FreezeTopRow     = $True
            FreezePane       = '3'
        }
        $data | Export-Excel -Title "$($FailureType) Failure" -WorksheetName "$($FailureType) Failure" @ExcelOptions
    }
    if ($Export -eq 'HTML') { $data | Out-HtmlView -DisablePaging -Title 'Citrix Failures' -HideFooter -SearchHighlight -FixedHeader }
    if ($Export -eq 'Host') { $data }

} #end Function
