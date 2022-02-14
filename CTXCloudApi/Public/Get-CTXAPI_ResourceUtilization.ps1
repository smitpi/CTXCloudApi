
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


    $data = @()
    foreach ($Machines in ($monitor.Machines | Where-Object { $_.MachineRole -ne 1 })) {

        $ResourceUtilization = $monitor.ResourceUtilization | Where-Object { $_.MachineId -eq $Machines.Id }
        $catalog = $monitor.Catalogs | Where-Object { $_.id -eq $Machines.CatalogId } | ForEach-Object { $_.name }
        $desktopgroup = $monitor.DesktopGroups | Where-Object { $_.id -eq $Machines.DesktopGroupId } | ForEach-Object { $_.name }

        try {
            $PercentCpu = $UsedMemory = $SessionCount = 0
            foreach ($Resource in $ResourceUtilization) {
                $PercentCpu = $PercentCpu + $Resource.PercentCpu
                $UsedMemory = $UsedMemory + $Resource.UsedMemory
                $SessionCount = $SessionCount + $Resource.SessionCount
            }
            $AVGPercentCpu = [math]::Round($PercentCpu / $ResourceUtilization.Count)
            $AVGUsedMemory = [math]::Ceiling(($UsedMemory / $ResourceUtilization.Count) / 1gb)
            $AVGTotalMemory = [math]::Round($ResourceUtilization[0].TotalMemory / 1gb)
            $AVGSessionCount = [math]::Round($SessionCount / $ResourceUtilization.Count)
        }
        catch { Write-Warning 'divide by 0 attempted' }
        $data += [PSCustomObject]@{
            DnsName                  = $Machines.DnsName
            IsInMaintenanceMode      = $Machines.IsInMaintenanceMode
            AgentVersion             = $Machines.AgentVersion
            CurrentRegistrationState = $RegistrationState.($Machines.CurrentRegistrationState)
            OSType                   = $Machines.OSType
            Catalog                  = $catalog
            DesktopGroup             = $desktopgroup
            AVGPercentCpu            = $AVGPercentCpu
            AVGUsedMemory            = $AVGUsedMemory
            AVGTotalMemory           = $AVGTotalMemory
            AVGSessionCount          = $AVGSessionCount
        }
    }
    if ($Export -eq 'Excel') { $data | Export-Excel -Path ($ReportPath + '\Resources_Audit-' + (Get-Date -Format yyyy.MM.dd-HH.mm) + '.xlsx') -AutoSize -AutoFilter -Show }
    if ($Export -eq 'HTML') { $data | Out-HtmlView -DisablePaging -Title 'Citrix Resources' -HideFooter -FixedHeader }
    if ($Export -eq 'Host') { $data }

} #end Function
