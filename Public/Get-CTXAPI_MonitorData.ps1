`
<#PSScriptInfo

.VERSION 1.0.3

.GUID ce76995e-894d-40ee-ac4a-f700cd9abd01

.AUTHOR Pierre Smit

.COMPANYNAME iOCO Tech

.COPYRIGHT

.TAGS PowerShell Citrix PowerShell

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Created [20/04/2021_12:17] Initital Script Creating
Updated [22/04/2021_11:42] Script Fle Info was updated
Updated [23/04/2021_19:03] Reports on progress
Updated [24/04/2021_07:21] added more api calls

.PRIVATEDATA

#> 

#Requires -Module PSWriteColor




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
		[int]$hours
)


	function Export-Odata {
		[CmdletBinding()]
		param(
			[string]$URI,
			[System.Collections.Hashtable]$headers)

		$data = @()
		$NextLink = $URI

		Write-Color -Text 'Fetching :',$URI.split('?')[0].split('\')[1] -Color Yellow,Cyan -ShowTime -DateTimeFormat HH:mm:ss -NoNewLine
		$APItimer.Restart()
		While ($Null -ne $NextLink) {
			$tmp = Invoke-WebRequest -Uri $NextLink -Headers $headers | ConvertFrom-Json
			$tmp.Value | ForEach-Object { $data += $_ }
			$NextLink = $tmp.'@odata.NextLink' 
		}
		[String]$seconds = '[' + ($APItimer.elapsed.seconds).ToString() + 'sec]'
		Write-Color $seconds -Color Red
		return $data

	}

	$timer = [Diagnostics.Stopwatch]::StartNew();
	$APItimer = [Diagnostics.Stopwatch]::StartNew();
	$headers = [System.Collections.Hashtable]@{
		Authorization       = "CwsAuth Bearer=$($ApiToken)"
		'Citrix-CustomerId' = $customerId
		Accept              = 'application/json'
	}
	$now = Get-Date -Format yyyy-MM-ddTHH:mm:ss.ffffZ
	$past = ((Get-Date).AddHours(-$hours)).ToString('yyyy-MM-ddTHH:mm:ss.ffffZ')

		$datereport = (Get-Date) - (Get-Date).AddHours(-$hours)

		Write-Color -Text 'Getting data for:' -Color Yellow -LinesBefore 1 -ShowTime
		Write-Color -Text 'Days: ',([math]::Round($datereport.Totaldays)) -Color Yellow,Cyan -StartTab 4
		Write-Color -Text 'Hours: ',([math]::Round($datereport.Totalhours)) -Color Yellow,Cyan -StartTab 4 -LinesAfter 2

$data = @()
		$data = [PSCustomObject]@{
			ApplicationActivitySummaries = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\ApplicationActivitySummaries?$filter=(Granularity eq 60 and ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )') -headers $headers
			ApplicationInstances         = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\ApplicationInstances?$filter=(ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )') -headers $headers
			Applications                 = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\Applications') -headers $headers
			Catalogs                     = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\Catalogs') -headers $headers
			ConnectionFailureLogs        = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\ConnectionFailureLogs?$filter=(ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )') -headers $headers
			Connections                  = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\Connections?$apply=filter(ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )') -headers $headers
			DesktopGroups                = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\DesktopGroups') -headers $headers
			DesktopOSDesktopSummaries    = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\DesktopOSDesktopSummaries?$filter=(Granularity eq 60 and ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )') -headers $headers
			FailureLogSummaries          = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\FailureLogSummaries?$filter=(ModifiedDate ge ' + $past + ' )') -headers $headers
			Hypervisors                  = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\Hypervisors') -headers $headers
			LogOnSummaries               = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\LogOnSummaries?$filter=(ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )') -headers $headers
			MachineFailureLogs           = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\MachineFailureLogs?$filter=(ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )') -headers $headers
			MachineMetric                = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\MachineMetric?$filter=(CollectedDate ge ' + $past + ' and CollectedDate le ' + $now + ' )') -headers $headers
			Machines                     = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\Machines') -headers $headers
			ServerOSDesktopSummaries     = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\ServerOSDesktopSummaries?$filter=(Granularity eq 60 and ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )') -headers $headers
			SessionActivitySummaries     = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\SessionActivitySummaries?$filter=(Granularity eq 60 and ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )') -headers $headers
			SessionAutoReconnects        = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\SessionAutoReconnects?$filter=(CreatedDate ge ' + $past + ' and CreatedDate le ' + $now + ' )') -headers $headers
			Session                      = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\Sessions?$apply=filter(ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )') -headers $headers
			Users                        = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\Users') -headers $headers
            #LoadIndexes                  = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\LoadIndexes?$filter=(ModifiedDate ge ' + $past + ' )') -headers $headers
			#LoadIndexSummaries           = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\LoadIndexSummaries?$filter=(ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )') -headers $headers
			LogOnMetrics                 = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\LogOnMetrics?$filter=(UserInitStartDate ge ' + $past + ' and UserInitStartDate le ' + $now + ' )') -headers $headers
			#Processes                    = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\Processes?$filter=(ProcessCreationDate ge ' + $past + ' and ProcessCreationDate le ' + $now + ' )') -headers $headers
			#ProcessUtilization           = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\ProcessUtilization?$filter=(CollectedDate ge ' + $past + ' and CollectedDate le ' + $now + ' )') -headers $headers
			ResourceUtilizationSummary   = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\ResourceUtilizationSummary?$filter=(ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )') -headers $headers
			ResourceUtilization          = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\ResourceUtilization?$filter=(ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )') -headers $headers
			SessionMetrics               = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\SessionMetrics?$apply=filter(CollectedDate ge ' + $past + ' and CollectedDate le ' + $now + ' )') -headers $headers
		}

		$timer.Stop()
		$APItimer.Stop()
		$timer.Elapsed | Select-Object Days, Hours, Minutes, Seconds | Format-List
		$data
} #end Function
