
<#PSScriptInfo

.VERSION 1.2.3

.GUID 3e0321fa-75f4-4cb4-b4d4-cb806bc52a5a

.AUTHOR Pierre Smit

.COMPANYNAME iOCO Tech

.COPYRIGHT

.TAGS "api" "cloud") "vda" ("ctx" api cloud ctx ps vda

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Created [06/10/2021_18:17] Initital Script Creating
Updated [06/10/2021_20:09] "Help Files Added"
Updated [07/10/2021_13:28] Script info updated for module
Updated [03/11/2021_19:17] Info Upate

.PRIVATEDATA

#> 







<#

.DESCRIPTION 
"Get the data from odata"

#>


#.ExternalHelp CTXCloudApi-help.xml
Function Get-CTXAPI_MonitorData {
	<#
.SYNOPSIS
Collect Monitoring Odata for other reports

.DESCRIPTION
Collect Monitoring Odata for other reports

.PARAMETER APIHeader
Use Connect-CTXAPI to create headers

.PARAMETER region
Your Cloud region

.PARAMETER hours
Duration of the report

.EXAMPLE
Get-CTXAPI_MonitorData -APIHeader $APIHeader -region $region -hours 24

#>
	[Cmdletbinding()]
	PARAM(
		[Parameter(Mandatory = $true)]
		[PSTypeName('CTXAPIHeaderObject')]$APIHeader,
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[ValidateSet('us', 'eu', 'ap-s')]
		[string]$region,
		[ValidateNotNullOrEmpty()]
		[Parameter(Mandatory = $true)]
		[int]$hours
	)



	$timer = [Diagnostics.Stopwatch]::StartNew();
	$APItimer = [Diagnostics.Stopwatch]::StartNew();

	$now = Get-Date -Format yyyy-MM-ddTHH:mm:ss.ffffZ
	$past = ((Get-Date).AddHours(-$hours)).ToString('yyyy-MM-ddTHH:mm:ss.ffffZ')

	$datereport = (Get-Date) - (Get-Date).AddHours(-$hours)

	Write-Color -Text 'Getting data for:' -Color Yellow -LinesBefore 1 -ShowTime
	Write-Color -Text 'Days: ', ([math]::Round($datereport.Totaldays)) -Color Yellow, Cyan -StartTab 4
	Write-Color -Text 'Hours: ', ([math]::Round($datereport.Totalhours)) -Color Yellow, Cyan -StartTab 4 -LinesAfter 2

	[pscustomobject]@{
		PSTypeName                   = 'CTXMonitorData'
		ApplicationActivitySummaries = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\ApplicationActivitySummaries?$filter=(Granularity eq 60 and ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )') -headers $APIHeader.headers
		ApplicationInstances         = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\ApplicationInstances?$filter=(ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )') -headers $APIHeader.headers
		Applications                 = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\Applications') -headers $APIHeader.headers
		Catalogs                     = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\Catalogs') -headers $APIHeader.headers
		ConnectionFailureLogs        = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\ConnectionFailureLogs?$filter=(ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )') -headers $APIHeader.headers
		Connections                  = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\Connections?$apply=filter(ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )') -headers $APIHeader.headers
		DesktopGroups                = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\DesktopGroups') -headers $APIHeader.headers
		DesktopOSDesktopSummaries    = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\DesktopOSDesktopSummaries?$filter=(Granularity eq 60 and ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )') -headers $APIHeader.headers
		FailureLogSummaries          = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\FailureLogSummaries?$filter=(ModifiedDate ge ' + $past + ' )') -headers $APIHeader.headers
		Hypervisors                  = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\Hypervisors') -headers $APIHeader.headers
		LogOnSummaries               = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\LogOnSummaries?$filter=(ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )') -headers $APIHeader.headers
		MachineFailureLogs           = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\MachineFailureLogs?$filter=(ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )') -headers $APIHeader.headers
		MachineMetric                = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\MachineMetric?$filter=(CollectedDate ge ' + $past + ' and CollectedDate le ' + $now + ' )') -headers $APIHeader.headers
		Machines                     = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\Machines') -headers $APIHeader.headers
		ServerOSDesktopSummaries     = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\ServerOSDesktopSummaries?$filter=(Granularity eq 60 and ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )') -headers $APIHeader.headers
		SessionActivitySummaries     = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\SessionActivitySummaries?$filter=(Granularity eq 60 and ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )') -headers $APIHeader.headers
		SessionAutoReconnects        = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\SessionAutoReconnects?$filter=(CreatedDate ge ' + $past + ' and CreatedDate le ' + $now + ' )') -headers $APIHeader.headers
		Session                      = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\Sessions?$apply=filter(ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )') -headers $APIHeader.headers
		Users                        = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\Users') -headers $APIHeader.headers
		#LoadIndexes                  = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\LoadIndexes?$filter=(ModifiedDate ge ' + $past + ' )') -headers $APIHeader.headers
		#LoadIndexSummaries           = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\LoadIndexSummaries?$filter=(ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )') -headers $APIHeader.headers
		LogOnMetrics                 = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\LogOnMetrics?$filter=(UserInitStartDate ge ' + $past + ' and UserInitStartDate le ' + $now + ' )') -headers $APIHeader.headers
		#Processes                    = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\Processes?$filter=(ProcessCreationDate ge ' + $past + ' and ProcessCreationDate le ' + $now + ' )') -headers $APIHeader.headers
		#ProcessUtilization           = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\ProcessUtilization?$filter=(CollectedDate ge ' + $past + ' and CollectedDate le ' + $now + ' )') -headers $APIHeader.headers
		ResourceUtilizationSummary   = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\ResourceUtilizationSummary?$filter=(ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )') -headers $APIHeader.headers
		ResourceUtilization          = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\ResourceUtilization?$filter=(ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )') -headers $APIHeader.headers
		SessionMetrics               = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\SessionMetrics?$apply=filter(CollectedDate ge ' + $past + ' and CollectedDate le ' + $now + ' )') -headers $APIHeader.headers
	}

	$timer.Stop()
	$APItimer.Stop()
} #end Function
