
<#PSScriptInfo

.VERSION 1.0.1

.GUID 9134ee8e-5ab7-4162-a33a-d95fc24069f9

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
Created [06/04/2021_08:05] Initital Script Creating
Updated [06/04/2021_09:03] Script Fle Info was updated

#> 



<# 

.DESCRIPTION 
Get vda uptime. Needs to be run from inside the client network

#> 


Param()


Function Get-CTX_VDAUptime {
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
try {
$OSInfo = Get-CimInstance Win32_OperatingSystem -ComputerName $_.IPAddress
$LastBootTime = $OSInfo.LastBootUpTime
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
		Name       = 'LastBootTime'
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
	LastBootTime         = $CompUptime.LastBootTime
	DayOfWeek            = $CompUptime.DayOfWeek
}
}
catch {
write-error "Unable to connect to $_.IPAddress"
}
}
if ($ExportToExcel -eq $true) {
	[string]$ExcelReportname = $ReportPath + "\VDAUptime-" + (Get-Date -Format yyyy.MM.dd-HH.mm) + ".xlsx"
	$complist | Export-Excel -Path $ExcelReportname -WorksheetName machines -AutoSize -AutoFilter
}
else {$Complist}
} #end Function
