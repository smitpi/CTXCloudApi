
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
Uses Registration date to calculate uptime

#>



<#
.SYNOPSIS
Uses Registration date to calculate uptime

.DESCRIPTION
Uses Registration date to calculate uptime

.PARAMETER APIHeader
Use Connect-CTXAPI to create headers

.PARAMETER Export
In what format to export the reports.

.PARAMETER ReportPath
Destination folder for the exported report.

.EXAMPLE
Get-CTXAPI_VDAUptime -APIHeader $APIHeader -Export excel -ReportPath C:\temp\

#>

Function Get-CTXAPI_VDAUptime {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_VDAUptime')]
    PARAM(
        [Parameter(Mandatory = $true)]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader,
        [Parameter(Mandatory = $false)]
        [ValidateSet('Excel', 'HTML')]
        [string]$Export = 'Host',
        [Parameter(Mandatory = $false)]
        [ValidateScript( { (Test-Path $_) })]
        [string]$ReportPath = $env:temp)

    try {
        $Complist = @()
        $machines = Get-CTXAPI_Machines -APIHeader $APIHeader

        foreach ($machine in $machines) {
            if ($null -eq $machine.LastDeregistrationTime) { $lastBootTime = Get-Date -Format 'M/d/yyyy h:mm:ss tt' }
            else { $lastBootTime = [Datetime]::ParseExact($machine.LastDeregistrationTime, 'M/d/yyyy h:mm:ss tt', $null) }

            $Uptime = (New-TimeSpan -Start $lastBootTime -End (Get-Date))
            $SelectProps =
            'Days',
            'Hours',
            'Minutes',
            @{
                Name       = 'TotalHours'
                Expression = { [math]::Round($Uptime.TotalHours) }
            },
            @{
                Name       = 'OnlineSince'
                Expression = { $LastBootTime }
            },
            @{
                Name       = 'DayOfWeek'
                Expression = { $LastBootTime.DayOfWeek }
            }
            $CompUptime = $Uptime | Select-Object $SelectProps
            $Complist += [PSCustomObject]@{
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
                Days              = $CompUptime.Days
                TotalHours        = $CompUptime.TotalHours
                OnlineSince       = $CompUptime.OnlineSince
                DayOfWeek         = $CompUptime.DayOfWeek
            }
        }
    }
    catch { Write-Warning 'Date calculation failed' }
    if ($Export -eq 'Excel') { $complist | Export-Excel -Path ($ReportPath + '\VDAUptime-' + (Get-Date -Format yyyy.MM.dd-HH.mm) + '.xlsx') -AutoSize -AutoFilter -Show }
    if ($Export -eq 'HTML') { $complist | Out-HtmlView -DisablePaging -Title 'Citrix Uptime' -HideFooter -FixedHeader }
    if ($Export -eq 'Host') { $complist }

} #end Function

