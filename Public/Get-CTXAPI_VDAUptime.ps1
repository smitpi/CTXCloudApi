
<#PSScriptInfo

.VERSION 1.0.0

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

#>

<# 

.DESCRIPTION 
 Uses Registration date to calculate uptime 
 #Requires –Modules ImportExcel
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
                	[Parameter(Mandatory=$false, Position=3)]
                	[ValidateNotNull()]
                	[ValidateNotNullOrEmpty()]
					[switch]$ExportToExcel = $false,
					[Parameter(Mandatory = $false, Position = 4)]
					[ValidateScript( { (Test-Path $_) })]
					[string]$ReportPath = "c:\temp\"
)
$Complist = @()
Get-CTXAPI_Machines -CustomerId $CustomerId -SiteId $SiteId -ApiToken $apitoken | ForEach-Object {
$lastBootTime=[Datetime]::ParseExact($_.LastDeregistrationTime, "M/d/yyyy h:mm:ss tt", $null)

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
	DnsName              = $_.DnsName
	AgentVersion         = $_.AgentVersion
	MachineCatalog       = $_.MachineCatalog.Name
	DeliveryGroup        = $_.DeliveryGroup.Name
	InMaintenanceMode    = $_.InMaintenanceMode
	IPAddress            = $_.IPAddress
	OSType               = $_.OSType
	ProvisioningType     = $_.ProvisioningType
	SummaryState         = $_.SummaryState
	FaultState           = $_.FaultState
	Days                 = $CompUptime.Days
	TotalHours           = $CompUptime.TotalHours
	OnlineSince          = $CompUptime.OnlineSince
	DayOfWeek            = $CompUptime.DayOfWeek
}
}
if ($ExportToExcel -eq $true) {
	[string]$ExcelReportname = $ReportPath + "\VDAUptime-" + (Get-Date -Format yyyy.MM.dd-HH.mm) + ".xlsx"
	$complist | Export-Excel -Path $ExcelReportname -WorksheetName machines -AutoSize -AutoFilter
}
else {$Complist}

} #end Function
