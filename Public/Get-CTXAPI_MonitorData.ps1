
<#PSScriptInfo

.VERSION 1.0.1

.GUID ce76995e-894d-40ee-ac4a-f700cd9abd01

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
Created [20/04/2021_12:17] Initital Script Creating
Updated [22/04/2021_11:42] Script Fle Info was updated

.PRIVATEDATA

#> 



<# 

.DESCRIPTION 
Get monitoring data

#> 

Param()


Function Get-CTXAPI_MonitorData {
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
		[Parameter(Mandatory = $true, Position = 3)]
		[ValidateNotNullOrEmpty()]
		[ValidateSet('us', 'eu', 'ap-s')]
		[string]$region,
		[ValidateNotNullOrEmpty()]
		[Parameter(Mandatory = $true, Position = 4)]
		[int]$hours)

	$headers = [System.Collections.Hashtable]@{
		Authorization       = "CwsAuth Bearer=$($ApiToken)"
		'Citrix-CustomerId' = $customerId
		Accept              = 'application/json'
	}
	function Export-Odata {
		[CmdletBinding()]
		param(
			[string]$URI,
			[System.Collections.Hashtable]$headers)
		$data = @()
		$NextLink = $URI
		While ($Null -ne $NextLink) {
			$tmp = Invoke-WebRequest -Uri $NextLink -Headers $headers | ConvertFrom-Json
			$tmp.Value | ForEach-Object { $data += $_ }
			$NextLink = $tmp.'@odata.NextLink' 
		}
		return $data
	}

	$now = Get-Date -Format yyyy-MM-ddTHH:mm:ss.ffffZ
	$past = ((Get-Date).AddHours(-$hours)).ToString('yyyy-MM-ddTHH:mm:ss.ffffZ')

	$tmpuri = [PSCustomObject]@{
		ApplicationActivitySummariesURI = 'https://api-' + $region + '.cloud.com/monitorodata\ApplicationActivitySummaries?$filter=(Granularity eq 60 and ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )'
		#ApplicationErrorsURI            = 'https://api-' + $region + '.cloud.com/monitorodata\ApplicationErrors?$filter=(ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )'
		#ApplicationFaultsURI            = 'https://api-' + $region + '.cloud.com/monitorodata\ApplicationFaults?$filter=(ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )'
		ApplicationsURI                 = 'https://api-' + $region + '.cloud.com/monitorodata\Applications'
		CatalogsURI                     = 'https://api-' + $region + '.cloud.com/monitorodata\Catalogs'
		ConnectionFailureLogsURI        = 'https://api-' + $region + '.cloud.com/monitorodata\ConnectionFailureLogs?$filter=(ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )'
		ConnectionsURI                  = 'https://api-' + $region + '.cloud.com/monitorodata\Connections?$apply=filter(ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )'
		DesktopGroupsURI                = 'https://api-' + $region + '.cloud.com/monitorodata\DesktopGroups'
		DesktopOSDesktopSummariesURI    = 'https://api-' + $region + '.cloud.com/monitorodata\DesktopOSDesktopSummaries?$filter=(Granularity eq 60 and ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )'
		HypervisorsURI                  = 'https://api-' + $region + '.cloud.com/monitorodata\Hypervisors'
		MachineMetricURI                = 'https://api-' + $region + '.cloud.com/monitorodata\MachineMetric?$filter=(CollectedDate ge ' + $past + ' and CollectedDate le ' + $now + ' )'
		MachineFailureLogsURI           = 'https://api-' + $region + '.cloud.com/monitorodata\MachineFailureLogs?$filter=(ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )'
		MachinesURI                     = 'https://api-' + $region + '.cloud.com/monitorodata\Machines'
		ResourceUtilizationURI          = 'https://api-' + $region + '.cloud.com/monitorodata\ResourceUtilization?$filter=(ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )'
		ServerOSDesktopSummariesURI     = 'https://api-' + $region + '.cloud.com/monitorodata\ServerOSDesktopSummaries?$filter=(Granularity eq 60 and ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )'
		SessionActivitySummariesURI     = 'https://api-' + $region + '.cloud.com/monitorodata\SessionActivitySummaries?$filter=(Granularity eq 60 and ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )'
		SessionMetricsURI               = 'https://api-' + $region + '.cloud.com/monitorodata\SessionMetrics?$apply=filter(CollectedDate ge ' + $past + ' and CollectedDate le ' + $now + ' )'
		SessionURI                      = 'https://api-' + $region + '.cloud.com/monitorodata\Sessions?$apply=filter(ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )'
		UsersURI                        = 'https://api-' + $region + '.cloud.com/monitorodata\Users'
		FailureLogSummariesURI          = 'https://api-' + $region + '.cloud.com/monitorodata\FailureLogSummaries?$filter=(ModifiedDate ge ' + $past + ' )'
	}

	$mon = @()
	Write-Color -Text "Fetching:","ApplicationActivitySummaries" -Color Yellow,Cyan 
	$mon += [PSCustomObject]@{ApplicationActivitySummaries = @(Export-Odata -URI $tmpuri.ApplicationActivitySummariesURI -headers $headers)}
Write-Color -Text "Fetching:","Applications" -Color Yellow,Cyan 
	$mon += [PSCustomObject]@{Applications = @(Export-Odata -URI $tmpuri.ApplicationsURI -headers $headers)}
Write-Color -Text "Fetching:","Catalogs" -Color Yellow,Cyan 
	$mon += [PSCustomObject]@{Catalogs = @(Export-Odata -URI $tmpuri.CatalogsURI -headers $headers)}
Write-Color -Text "Fetching:","ConnectionFailureLogs" -Color Yellow,Cyan 
	$mon += [PSCustomObject]@{ConnectionFailureLogs = @(Export-Odata -URI $tmpuri.ConnectionFailureLogsURI -headers $headers)}
Write-Color -Text "Fetching:","FailureLogSummaries" -Color Yellow,Cyan 
	$mon += [PSCustomObject]@{FailureLogSummaries = @(Export-Odata -URI $tmpuri.FailureLogSummariesURI -headers $headers)}
Write-Color -Text "Fetching:","Connections" -Color Yellow,Cyan 
	$mon += [PSCustomObject]@{Connections = @(Export-Odata -URI $tmpuri.ConnectionsURI -headers $headers)}
Write-Color -Text "Fetching:","DesktopGroups" -Color Yellow,Cyan 
	$mon += [PSCustomObject]@{DesktopGroups = @(Export-Odata -URI $tmpuri.DesktopGroupsURI -headers $headers)}
Write-Color -Text "Fetching:","DesktopOSDesktopSummaries" -Color Yellow,Cyan 
	$mon += [PSCustomObject]@{DesktopOSDesktopSummaries = @(Export-Odata -URI $tmpuri.DesktopOSDesktopSummariesURI -headers $headers)}
Write-Color -Text "Fetching:","Hypervisors" -Color Yellow,Cyan 
	$mon += [PSCustomObject]@{Hypervisors = @(Export-Odata -URI $tmpuri.HypervisorsURI -headers $headers)}
Write-Color -Text "Fetching:","MachineMetric" -Color Yellow,Cyan 
	$mon += [PSCustomObject]@{MachineMetric = @(Export-Odata -URI $tmpuri.MachineMetricURI -headers $headers)}
Write-Color -Text "Fetching:","MachineFailureLogs" -Color Yellow,Cyan 
	$mon += [PSCustomObject]@{MachineFailureLogs = @(Export-Odata -URI $tmpuri.MachineFailureLogsURI -headers $headers)}
Write-Color -Text "Fetching:","Machines" -Color Yellow,Cyan 
	$mon += [PSCustomObject]@{Machines = @(Export-Odata -URI $tmpuri.MachinesURI -headers $headers)}
Write-Color -Text "Fetching:","ResourceUtilization" -Color Yellow,Cyan 
	$mon += [PSCustomObject]@{ResourceUtilization = @(Export-Odata -URI $tmpuri.ResourceUtilizationURI -headers $headers)}
Write-Color -Text "Fetching:","ServerOSDesktopSummaries" -Color Yellow,Cyan 
	$mon += [PSCustomObject]@{ServerOSDesktopSummaries = @(Export-Odata -URI $tmpuri.ServerOSDesktopSummariesURI -headers $headers)}
Write-Color -Text "Fetching:","SessionActivitySummaries" -Color Yellow,Cyan 
	$mon += [PSCustomObject]@{SessionActivitySummaries = @(Export-Odata -URI $tmpuri.SessionActivitySummariesURI -headers $headers)}
Write-Color -Text "Fetching:","SessionMetrics" -Color Yellow,Cyan 
	$mon += [PSCustomObject]@{SessionMetrics = @(Export-Odata -URI $tmpuri.SessionMetricsURI -headers $headers)}
Write-Color -Text "Fetching:","Session" -Color Yellow,Cyan 
	$mon += [PSCustomObject]@{Session = @(Export-Odata -URI $tmpuri.SessionURI -headers $headers)}
Write-Color -Text "Fetching:","Users" -Color Yellow,Cyan 
	$mon += [PSCustomObject]@{Users = @(Export-Odata -URI $tmpuri.UsersURI -headers $headers)}
	$mon


} #end Function
