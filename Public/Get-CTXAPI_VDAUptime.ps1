
<#PSScriptInfo

.VERSION 1.0.2

.GUID bc970a9f-0566-4048-8332-0bceda215135

.AUTHOR Pierre Smit

.COMPANYNAME iOCO Tech

.COPYRIGHT

.TAGS Citrix

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Created [06/04/2021_11:17] Initital Script Creating
Updated [20/04/2021_10:43] Script Fle Info was updated
Updated [22/04/2021_11:42] Script Fle Info was updated

.PRIVATEDATA

#> 

#Requires -Module ImportExcel
#Requires -Module PSWriteHTML
#Requires -Module PSWriteColor



<# 

.DESCRIPTION 
Uses Registration date to calculate uptime

#> 

Param()

Function Get-CTXAPI_VDAUptime {
	PARAM(
		[Parameter(Mandatory = $true, Position = 0)]
		[ValidateNotNullOrEmpty()]
		[string]$CustomerId,
		[Parameter(Mandatory = $true, Position = 1)]
		[ValidateNotNullOrEmpty()]
		[string]$SiteId,
		[Parameter(Mandatory = $true, Position = 2)]
		[ValidateNotNullOrEmpty()]
		[string]$ApiToken,
		[Parameter(Mandatory = $false, Position = 5)]
		[ValidateSet('Excel', 'HTML')]
		[string]$Export = 'Host',
		[Parameter(Mandatory = $false, Position = 6)]
		[ValidateScript( { (Test-Path $_) })]
		[string]$ReportPath = $env:temp)


	$Complist = @()
	Get-CTXAPI_Machines -CustomerId $CustomerId -SiteId $SiteId -ApiToken $apitoken | ForEach-Object {
		$lastBootTime = [Datetime]::ParseExact($_.LastDeregistrationTime, 'M/d/yyyy h:mm:ss tt', $null)

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
			DnsName           = $_.DnsName
			AgentVersion      = $_.AgentVersion
			MachineCatalog    = $_.MachineCatalog.Name
			DeliveryGroup     = $_.DeliveryGroup.Name
			InMaintenanceMode = $_.InMaintenanceMode
			IPAddress         = $_.IPAddress
			OSType            = $_.OSType
			ProvisioningType  = $_.ProvisioningType
			SummaryState      = $_.SummaryState
			FaultState        = $_.FaultState
			Days              = $CompUptime.Days
			TotalHours        = $CompUptime.TotalHours
			OnlineSince       = $CompUptime.OnlineSince
			DayOfWeek         = $CompUptime.DayOfWeek
		}
	}

	if ($Export -eq 'Excel') { $complist | Export-Excel -Path ($ReportPath + '\VDAUptime-' + (Get-Date -Format yyyy.MM.dd-HH.mm) + '.xlsx') -AutoSize -AutoFilter -Show }
	if ($Export -eq 'HTML') { $complist | Out-GridHtml -DisablePaging -Title 'Citrix Uptime' -HideFooter -FixedHeader }
	if ($Export -eq 'Host') { $complist }

} #end Function

