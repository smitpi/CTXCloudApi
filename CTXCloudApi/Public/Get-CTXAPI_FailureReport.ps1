
<#PSScriptInfo

.VERSION 1.1.8

.GUID 9354575e-ab08-426b-a80d-875532220d18

.AUTHOR Pierre Smit

.COMPANYNAME Private

.COPYRIGHT

.TAGS

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES


.PRIVATEDATA

#>

<# 

.DESCRIPTION 
 Reports on connection or machine failures in the last X hours. 

#> 



<#
.SYNOPSIS
Reports on connection or machine failures in the last X hours.

.DESCRIPTION
Reports on machine or connection failures in the last X hours using Monitor OData.

.PARAMETER APIHeader
Header object created by Connect-CTXAPI; contains authentication and request headers.

.PARAMETER MonitorData
Pre-fetched CVAD Monitor OData created by Get-CTXAPI_MonitorData. If provided, the cmdlet will not fetch data.

.PARAMETER LastHours
Duration window in hours used when fetching Monitor OData. Default: 24.

.PARAMETER FailureType
Type of failure to report on. Supported values: Connection, Machine.

.PARAMETER Export
Destination/output for the report. Supported values: Host, Excel, HTML. Default: Host.

.PARAMETER ReportPath
Destination folder for exported files when using Excel or HTML. Defaults to $env:Temp.

.EXAMPLE
Get-CTXAPI_FailureReport -MonitorData $MonitorData -FailureType Connection
Returns connection failures to the host.

.EXAMPLE
Get-CTXAPI_FailureReport -APIHeader $APIHeader -FailureType Machine -LastHours 48 -Export Excel -ReportPath C:\Temp
Exports machine failures for the last 48 hours to an Excel workbook.

.EXAMPLE
Get-CTXAPI_FailureReport -APIHeader $APIHeader -FailureType Connection | Select-Object User, DnsName, FailureDate, PowerState
Shows common fields for connection failures.

.INPUTS
None. Parameters are not accepted from the pipeline.

.OUTPUTS
System.Object[]
When Export is Host: array of failure report objects; when Export is Excel/HTML: no output objects and files are written to ReportPath.

.LINK
https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_FailureReport

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
        [int]$LastHours = 24,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('Connection', 'Machine')]
        [string]$FailureType,
        [Parameter(Mandatory = $false)]
        [ValidateSet('Host', 'Excel', 'HTML')]
        [string]$Export = 'Host',
        [Parameter(Mandatory = $false)]
        [ValidateScript( { (Test-Path $_) })]
        [string]$ReportPath = $env:temp

    )

    if ($Null -eq $MonitorData) { $mondata = Get-CTXAPI_MonitorData -APIHeader $APIHeader -LastHours $LastHours }
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
            $session = $mondata.Sessions | Where-Object { $_.SessionKey -eq $log.SessionKey }
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
