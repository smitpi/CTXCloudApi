
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
Resource utilization in the last x hours

#>

<#
.SYNOPSIS
Resource utilization in the last x hours

.DESCRIPTION
Resource utilization in the last x hours

.PARAMETER APIHeader
Use Connect-CTXAPI to create headers

.PARAMETER MonitorData
Use Get-CTXAPI_MonitorData to create OData

.PARAMETER region
Your Cloud instance hosted region.

.PARAMETER hours
Amount of time to report on.

.PARAMETER Export
In what format to export the reports.

.PARAMETER ReportPath
Destination folder for the exported report.

.EXAMPLE
Get-CTXAPI_ResourceUtilization -MonitorData $MonitorData -Export excel -ReportPath C:\temp\

#>

Function Get-CTXAPI_ResourceUtilization {
    [Cmdletbinding(DefaultParameterSetName = 'Fetch odata', HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_ResourceUtilization')]
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

    if ($Null -eq $MonitorData) { $monitor = Get-CTXAPI_MonitorData -APIHeader $APIHeader -region $region -hours $hours }
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
