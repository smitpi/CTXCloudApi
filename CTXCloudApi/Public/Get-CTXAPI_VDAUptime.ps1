
<#PSScriptInfo

.VERSION 1.1.7

.GUID bc970a9f-0566-4048-8332-0bceda215135

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
Created [06/04/2021_11:17] Initial Script Creating
Updated [20/04/2021_10:43] Script File Info was updated
Updated [05/05/2021_14:33] 'Update Manifest'
Updated [05/10/2021_21:22] Module Info Updated
Updated [07/10/2021_13:28] Script info updated for module
Updated [03/11/2021_19:17] Info Update
Updated [06/11/2021_16:49] Using the new api

.PRIVATEDATA

#>

#Requires -Module ImportExcel
#Requires -Module PSWriteHTML
#Requires -Module PSWriteColor


<#

.DESCRIPTION
Calculates VDA machine uptime based on registration/deregistration timestamps.
Builds a list with per-machine details and days online, optionally exporting to Excel/HTML.

#>



<#
.SYNOPSIS
Calculate VDA uptime and export or return results.

.DESCRIPTION
Calculates VDA machine uptime based on registration/deregistration timestamps.

.PARAMETER APIHeader
Header object created by Connect-CTXAPI; contains authentication and request headers.

.PARAMETER Export
Destination/output for the report. Supported values: Host, Excel, HTML. Default: Host.

.PARAMETER ReportPath
Destination folder for the exported report.

.EXAMPLE
Get-CTXAPI_VDAUptime -APIHeader $APIHeader -Export Excel -ReportPath C:\temp\
Exports an Excel workbook (VDAUptime-<yyyy.MM.dd-HH.mm>.xlsx) with uptime details.

.EXAMPLE
Get-CTXAPI_VDAUptime -APIHeader $APIHeader -Export HTML -ReportPath C:\Temp
Generates an HTML report titled "Citrix Uptime".

.EXAMPLE
Get-CTXAPI_VDAUptime -APIHeader $APIHeader | Select-Object DnsName, Days, OnlineSince, SummaryState
Returns objects to the host and selects common fields for quick inspection.

.INPUTS
None. Parameters are not accepted from the pipeline.

.OUTPUTS
System.Object[]
When Export is Host: array of uptime objects; when Export is Excel/HTML: no output objects and files are written to ReportPath.

.LINK
https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_VDAUptime

#>

function Get-CTXAPI_VDAUptime {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_VDAUptime')]
    param(
        [Parameter(Mandatory = $true)]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader,
        [Parameter(Mandatory = $false)]
        [ValidateSet('Host', 'Excel', 'HTML')]
        [string]$Export = 'Host',
        [Parameter(Mandatory = $false)]
        [ValidateScript( { (Test-Path $_) })]
        [string]$ReportPath = $env:temp)

    try {

        [System.Collections.generic.List[PSObject]]$complist = @()
        $machines = Get-CTXAPI_Machine -APIHeader $APIHeader

        foreach ($machine in $machines) {
            try {
                # Safely read and convert the last deregistration/registration time
                if ($machine.PSObject.Properties['LastDeregistrationTime'] -and -not [string]::IsNullOrWhiteSpace($machine.LastDeregistrationTime)) {
                    $lastBootTime = [Datetime]$machine.LastDeregistrationTime
                } elseif ($machine.PSObject.Properties['LastRegistrationTime'] -and -not [string]::IsNullOrWhiteSpace($machine.LastRegistrationTime)) {
                    # Fallback to LastRegistrationTime if available
                    $lastBootTime = [Datetime]$machine.LastRegistrationTime
                } else {
                    $lastBootTime = $null
                }

                # Compute uptime only when we have a valid start time
                if ($null -ne $lastBootTime) {
                    $Uptime = New-TimeSpan -Start $lastBootTime -End (Get-Date)
                } else {
                    $Uptime = $null
                }
            } catch {Write-Warning "Error: `n`tMessage:$($_.Exception.Message)"} 
            
            $complist.Add([PSCustomObject]@{
                    DnsName           = $machine.DnsName
                    AgentVersion      = $machine.AgentVersion
                    MachineCatalog    = $machine.MachineCatalog.Name
                    DeliveryGroup     = $machine.DeliveryGroup.Name
                    InMaintenanceMode = $machine.InMaintenanceMode
                    IPAddress         = $machine.IPAddress
                    OSType            = $machine.OSType
                    ProvisioningType  = $machine.ProvisioningType
                    SummaryState      = $machine.SummaryState
                    FaultState        = $machine.FaultState
                    Days              = if ($null -ne $Uptime) { $Uptime.Days } else { $null }
                    OnlineSince       = if ($null -eq $lastBootTime) { $null } else { $lastBootTime }
                })
        }
    } catch { Write-Warning 'Date calculation failed' }
    ##TODO - fix error  Message:Cannot convert null to type "System.DateTime".
    if ($Export -eq 'Excel') { 
        $ExcelOptions = @{
            Path             = $ReportPath + '\VDAUptime-' + (Get-Date -Format yyyy.MM.dd-HH.mm) + '.xlsx'
            AutoSize         = $True
            AutoFilter       = $True
            TitleBold        = $True
            TitleSize        = '28'
            TitleFillPattern = 'LightTrellis'
            TableStyle       = 'Light20'
            FreezeTopRow     = $True
            FreezePane       = '3'
        }
        $complist | Export-Excel -Title VDAUptime -WorksheetName VDAUptime @ExcelOptions
    }
    if ($Export -eq 'HTML') { $complist | Out-HtmlView -DisablePaging -Title 'Citrix Uptime' -HideFooter -FixedHeader }
    if ($Export -eq 'Host') { $complist }

} #end Function


