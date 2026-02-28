<#PSScriptInfo

.VERSION 1.1.8

.GUID bc970a9f-0566-4048-8332-0bceda215135

.AUTHOR Pierre Smit

.COMPANYNAME Private

.COPYRIGHT 

.TAGS ctx ps api

.LICENSEURI 

.PROJECTURI 

.ICONURI 

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS 

.EXTERNALSCRIPTDEPENDENCIES 

.RELEASENOTES
[02/18/2026 10:18:42] Updated with new paging logic

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
psobject[]
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
        [System.IO.DirectoryInfo]$ReportPath = $env:temp)


    if (-not(Test-CTXAPI_Header -APIHeader $APIHeader)) {Test-CTXAPI_Header -APIHeader $APIHeader -AutoRenew}
    else {	Write-Verbose "[$(Get-Date -Format HH:mm:ss) APIHEADER] Header still valid"}

    
    Write-Verbose "Starting Get-CTXAPI_VDAUptime with Export: $Export and ReportPath: $ReportPath"
    try {
        [System.Collections.generic.List[PSObject]]$complist = @()
        Write-Verbose 'Retrieving machines from Get-CTXAPI_Machine'
        $machines = Get-CTXAPI_Machine -APIHeader $APIHeader
        Write-Verbose ('Retrieved {0} machines.' -f $machines.Count)

        foreach ($machine in $machines) {
            try {
                Write-Verbose "Processing machine: $($machine.DnsName)"
                # Safely read and convert the last deregistration/registration time
                if ($machine.PSObject.Properties['LastDeregistrationTime'] -and -not [string]::IsNullOrWhiteSpace($machine.LastDeregistrationTime)) {
                    $lastBootTime = [Datetime]$machine.LastDeregistrationTime
                    Write-Verbose "Using LastDeregistrationTime: $lastBootTime"
                } elseif ($machine.PSObject.Properties['LastRegistrationTime'] -and -not [string]::IsNullOrWhiteSpace($machine.LastRegistrationTime)) {
                    $lastBootTime = [Datetime]$machine.LastRegistrationTime
                    Write-Verbose "Using LastRegistrationTime: $lastBootTime"
                } else {
                    $lastBootTime = $null
                    Write-Verbose 'No valid boot time found.'
                }

                # Compute uptime only when we have a valid start time
                if ($null -ne $lastBootTime) {
                    $Uptime = New-TimeSpan -Start $lastBootTime -End (Get-Date)
                    Write-Verbose "Calculated uptime: $($Uptime.Days) days."
                } else {
                    $Uptime = $null
                }
            } catch { Write-Warning "Error: `n`tMessage:$($_.Exception.Message)" } 

            $tmp = [PSCustomObject]@{
                DnsName           = $machine.DnsName
                AgentVersion      = $machine.AgentVersion
                MachineCatalog    = if ($machine.MachineCatalog -and $machine.MachineCatalog.PSObject.Properties['Name']) { $machine.MachineCatalog.Name } else { $null }
                DeliveryGroup     = if ($machine.DeliveryGroup -and $machine.DeliveryGroup.PSObject.Properties['Name']) { $machine.DeliveryGroup.Name } else { $null }
                InMaintenanceMode = $machine.InMaintenanceMode
                IPAddress         = $machine.IPAddress
                OSType            = $machine.OSType
                ProvisioningType  = $machine.ProvisioningType
                SummaryState      = $machine.SummaryState
                FaultState        = $machine.FaultState
                Days              = if ($null -ne $Uptime) { $Uptime.Days } else { $null }
                OnlineSince       = if ($null -eq $lastBootTime) { $null } else { $lastBootTime }
            }
            Write-Verbose ('Uptime object: {0}' -f ($tmp | ConvertTo-Json -Compress))
            $complist.Add($tmp)
        }
    } catch { Write-Warning "Date calculation failed. $($_.Exception.Message)" }

    Write-Verbose ('Total uptime objects: {0}' -f $complist.Count)
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
        Write-Verbose ('Exporting to Excel: {0}' -f $ExcelOptions.Path)
        $complist | Export-Excel -Title VDAUptime -WorksheetName VDAUptime @ExcelOptions
    }
    if ($Export -eq 'HTML') {
        Write-Verbose 'Exporting to HTML view.'
        $complist | Out-HtmlView -DisablePaging -Title 'Citrix Uptime' -HideFooter -FixedHeader
    }
    if ($Export -eq 'Host') {
        Write-Verbose 'Returning uptime objects to host.'
        $complist
    }
} #end Function


