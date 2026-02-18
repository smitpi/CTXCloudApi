
<#PSScriptInfo

.VERSION 1.1.8

.GUID f2cc4273-d5ac-49b1-b12c-a8e2d1b8cf06

.AUTHOR Pierre Smit

.COMPANYNAME HTPCZA Tech

.COPYRIGHT

.TAGS api citrix ctx cvad PowerShell ps

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Created [21/04/2021_11:32] Initial Script Creating
Updated [22/04/2021_11:42] Script File Info was updated
Updated [24/04/2021_07:22] Changes the report options
Updated [05/05/2021_00:04] added monitor data
Updated [05/05/2021_14:33] 'Update Manifest'
Updated [05/10/2021_21:22] Module Info Updated
Updated [07/10/2021_13:28] Script info updated for module
Updated [03/11/2021_19:17] Info Update
Updated [06/11/2021_16:49] Using the new api

.PRIVATEDATA

#>









<#

.DESCRIPTION
Reports on resource utilization for VDA machines over the past X hours.
Fetches CVAD Monitor OData (or uses provided `MonitorData`) and builds a per-machine dataset with averages (CPU, memory, sessions) and key details.

#>

<#
.SYNOPSIS
Resource utilization in the last X hours.

.DESCRIPTION
Reports on resource utilization for VDA machines over the past X hours.

.PARAMETER APIHeader
Header object created by Connect-CTXAPI; contains authentication and request headers (used to fetch Monitor OData).

.PARAMETER MonitorData
Pre-fetched CVAD Monitor OData created by Get-CTXAPI_MonitorData. If provided, the cmdlet will not fetch data.

.PARAMETER hours
Duration window (in hours) to fetch when retrieving Monitor OData. Default: 24.

.PARAMETER Export
Destination/output for the report. Supported values: Host, Excel, HTML. Default: Host.

.PARAMETER ReportPath
Destination folder for exported files when using Excel or HTML. Defaults to $env:Temp.

.EXAMPLE
Get-CTXAPI_ResourceUtilization -MonitorData $MonitorData -Export Excel -ReportPath C:\temp\
Exports an Excel workbook (Resources_Audit-<yyyy.MM.dd-HH.mm>.xlsx) with aggregated resource metrics.

.EXAMPLE
Get-CTXAPI_ResourceUtilization -APIHeader $APIHeader -hours 48 -Export HTML -ReportPath C:\temp
Generates an HTML report titled "Citrix Resources" for the last 48 hours.

.EXAMPLE
Get-CTXAPI_ResourceUtilization -APIHeader $APIHeader | Select-Object DnsName, AVGPercentCpu, AVGUsedMemory, AVGSessionCount
Returns objects to the host and selects common fields for quick inspection.

.INPUTS
None. Parameters are not accepted from the pipeline.

.OUTPUTS
System.Object[]
When Export is Host: array of resource utilization objects; when Export is Excel/HTML: no output objects and files are written to ReportPath.

.LINK
https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_ResourceUtilization

#>

function Get-CTXAPI_ResourceUtilization {
    [Cmdletbinding(DefaultParameterSetName = 'Fetch odata', HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_ResourceUtilization')]
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

    if ($Null -eq $MonitorData) { $monitor = Get-CTXAPI_MonitorData -APIHeader $APIHeader -LastHours $hours }
    else { $monitor = $MonitorData }
    
   

    [System.Collections.generic.List[PSObject]]$data = @()
    $InGroups = $monitor.ResourceUtilization | Group-Object -Property MachineId
    foreach ($machine in $InGroups) {
        $MachineDetails = $monitor.Machines | Where-Object {$_.id -like $machine.Name}
        $catalog = $monitor.Catalogs | Where-Object { $_.id -eq $MachineDetails.CatalogId } | ForEach-Object { $_.name }
        $desktopgroup = $monitor.DesktopGroups | Where-Object { $_.id -eq $MachineDetails.DesktopGroupId } | ForEach-Object { $_.name }
    
        try {
            $AVGPercentCpu = [math]::Round(($machine.Group | Measure-Object -Property PercentCpu -Average).Average)
            $AVGUsedMemory = [math]::Ceiling((($machine.Group | Measure-Object -Property UsedMemory -Average).Average) / 1gb)
            $AVGSessionCount = [math]::Ceiling(($machine.Group | Measure-Object -Property SessionCount -Average).Average)
            $AVGTotalMemory = [math]::Round($machine.Group[0].TotalMemory / 1gb)

        } catch {Write-Warning "Error: `n`tMessage:$($_.Exception.Message)"}
        $data.Add([PSCustomObject]@{
                DnsName                  = $MachineDetails.DnsName
                IsInMaintenanceMode      = $MachineDetails.IsInMaintenanceMode
                AgentVersion             = $MachineDetails.AgentVersion
                CurrentRegistrationState = $RegistrationState.($MachineDetails.CurrentRegistrationState)
                OSType                   = $MachineDetails.OSType
                Catalog                  = $catalog
                DesktopGroup             = $desktopgroup
                AVGPercentCpu            = $AVGPercentCpu
                AVGUsedMemory            = $AVGUsedMemory
                AVGTotalMemory           = $AVGTotalMemory
                AVGSessionCount          = $AVGSessionCount
            })
    }
    if ($Export -eq 'Excel') {
        $ExcelOptions = @{
            Path             = $ReportPath + '\Resources_Audit-' + (Get-Date -Format yyyy.MM.dd-HH.mm) + '.xlsx'
            AutoSize         = $True
            AutoFilter       = $True
            TitleBold        = $True
            TitleSize        = '28'
            TitleFillPattern = 'LightTrellis'
            TableStyle       = 'Light20'
            FreezeTopRow     = $True
            FreezePane       = '3'
        }
        $data | Export-Excel -Title 'Resource Audit' -WorksheetName Resources @ExcelOptions
    }
    if ($Export -eq 'HTML') { $data | Out-HtmlView -DisablePaging -Title 'Citrix Resources' -HideFooter -FixedHeader }
    if ($Export -eq 'Host') { $data }

} #end Function
