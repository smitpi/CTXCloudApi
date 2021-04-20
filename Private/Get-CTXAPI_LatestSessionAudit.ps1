<#PSScriptInfo

.VERSION 1.0.0

.GUID c42d9457-55ce-4d08-8128-ce3a9c4c7e78

.AUTHOR Pierre Smit

.COMPANYNAME iOCO Tech

.COPYRIGHT

.TAGS Citrix

.LICENS$regionRI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Created [17/04/2021_15:54] Initital Script Creating

.PRIVATEDATA

#>

<# 
#requires –Modules ImportExcel,PSWriteHTML,PSWriteColor

.DESCRIPTION 
 Reports on the last x hours of connections 

#> 

Param()


Function Get-CTXAPI_LatestSessionAudit {
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
		[Parameter(Mandatory = $false, Position = 4)]
		[int]$hours,
		[Parameter(Mandatory = $false, Position = 5)]
		[switch]$ExportToExcel = $false,
		[Parameter(Mandatory = $false, Position = 6)]
		[ValidateScript( { (Test-Path $_) })]
		[string]$ReportPath = $env:temp
	)

	$RegistrationState = [PSCustomObject]@{
		0 = 'Unknown'
		1 = 'Registered'
		2 = 'Unregistered'
	}
	$ConnectionState = [PSCustomObject]@{
		0 = 'Unknown'
		1 = 'Connected'
		2 = 'Disconnected'
		3 = 'Terminated'
		4 = 'PreparingSession'
		5 = 'Active'
		6 = 'Reconnecting'
		7 = 'NonBrokeredSession'
		8 = 'Other'
		9 = 'Pending'
	}
	$ConnectionFailureType = [PSCustomObject]@{
		0 = 'None'
		1 = 'ClientConnectionFailure'
		2 = 'MachineFailure'
		3 = 'NoCapacityAvailable'
		4 = 'NoLicensesAvailable'
		5 = 'Configuration'
	}
	$SessionFailureCode = [PSCustomObject]@{
		0   = 'Unknown'
		1   = 'None'
		2   = 'SessionPreparation'
		3   = 'RegistrationTimeout'
		4   = 'ConnectionTimeout'
		5   = 'Licensing'
		6   = 'Ticketing'
		7   = 'Other'
		8   = 'GeneralFail'
		9   = 'MaintenanceMode'
		10  = 'ApplicationDisabled'
		11  = 'LicenseFeatureRefused'
		12  = 'NoDesktopAvailable'
		13  = 'SessionLimitReached'
		14  = 'DisallowedProtocol'
		15  = 'ResourceUnavailable'
		16  = 'ActiveSessionReconnectDisabled'
		17  = 'NoSessionToReconnect'
		18  = 'SpinUpFailed'
		19  = 'Refused'
		20  = 'ConfigurationSetFailure'
		21  = 'MaxTotalInstancesExceeded'
		22  = 'MaxPerUserInstancesExceeded'
		23  = 'CommunicationError'
		24  = 'MaxPerMachineInstancesExceeded'
		25  = 'MaxPerEntitlementInstancesExceeded'
		100 = 'NoMachineAvailable'
		101 = 'MachineNotFunctional'
	}

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
		ApplicationErrorsURI            = 'https://api-' + $region + '.cloud.com/monitorodata\ApplicationErrors?$filter=(ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )'
		ApplicationFaultsURI            = 'https://api-' + $region + '.cloud.com/monitorodata\ApplicationFaults?$filter=(ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )'
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
	}
	$ApiURI = $tmpuri.psobject.properties | Select-Object name,value

	$ApiURI | ForEach-Object {
		try {
			[string]$apiname = $_.name.Replace('URI','')
			Write-Color -Text 'Exporting:',$apiname -Color Yellow,Cyan
			New-Variable -Name $apiname -Value (Export-Odata -URI $_.value -headers $headers) -Force
		} catch { Write-Error "Error fetching data -" $apiname }
	}


	$data = @()
	foreach ($connection in $connections) {
		try {
			$OneSession = $session | Where-Object { $_.SessionKey -eq $connection.SessionKey }
			$user = $users | Where-Object { $_.id -like $OneSession.UserId }
			$mashine = $machines | Where-Object { $_.id -like $OneSession.MachineId }
			try {
				$avgrtt = 0
				$SessionMetrics | Where-Object { $_.Sessionid -like $OneSession.SessionKey } | ForEach-Object { $avgrtt = $avgrtt + $_.IcaRttMS }
				$avgrtt = $avgrtt / ($SessionMetrics | Where-Object { $_.Sessionid -like $OneSession.SessionKey }).count
			} catch { Write-Warning "Not enough RTT data - $_.Exception.Message" }
		} catch { Write-Warning "Error processing - $_.Exception.Message" }
		$data += [PSCustomObject]@{
			Id                       = $connection.id
			FullName                 = $user.FullName
			Upn                      = $user.upn
			ConnectionState          = $ConnectionState.($OneSession.ConnectionState)
			DnsName                  = $mashine.DnsName
			IPAddress                = $mashine.IPAddress
			IsInMaintenanceMode      = $mashine.IsInMaintenanceMode
			CurrentRegistrationState = $RegistrationState.($mashine.CurrentRegistrationState)
			OSType                   = $mashine.OSType
			ClientName               = $connection.ClientName
			ClientVersion            = $connection.ClientVersion
			ClientAddress            = $connection.ClientAddress
			ClientPlatform           = $connection.ClientPlatform
			IsReconnect              = $connection.IsReconnect
			IsSecureIca              = $connection.IsSecureIca
			Protocol                 = $connection.Protocol
			EstablishmentDate        = $connection.EstablishmentDate
			LogOnStartDate           = $connection.LogOnStartDate
			LogOnEndDate             = $connection.LogOnEndDate
			AuthenticationDuration   = $connection.AuthenticationDuration
			LogOnDuration            = $OneSession.LogOnDuration
			DisconnectDate           = $connection.DisconnectDate
			EndDate                  = $OneSession.EndDate
			ExitCode                 = $SessionFailureCode.($OneSession.ExitCode)
			FailureDate              = $OneSession.FailureDate
			AVG_ICA_RTT              = $avgrtt
		}
	}

	if ($ExportToExcel) {
		[string]$ExcelReportname = $ReportPath + '\Session_Audit-' + (Get-Date -Format yyyy.MM.dd-HH.mm) + '.xlsx'
		$data | Export-Excel -Path $ExcelReportname -AutoSize -AutoFilter -Show
	} else { 
		$data | Out-GridHtml -DisablePaging -Title 'Citrix Sessions' -HideFooter -SearchHighlight -FixedHeader 
		$data
	}



} #end Function