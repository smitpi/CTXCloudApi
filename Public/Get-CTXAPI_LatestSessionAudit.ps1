
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

.DESCRIPTION 
 Reports on the last 100 sessions 

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
		[Parameter(Mandatory = $false, Position = 4)]
		[switch]$ExportToExcel = $false,
		[Parameter(Mandatory = $false, Position = 5)]
		[ValidateScript( { (Test-Path $_) })]
		[string]$ReportPath = $env:temp
	)


	$Today = Get-Date -Format yyyy-MM-ddTHH:mm:ss.ffffZ
	$LastWeek = ((Get-Date).AddHours(-48)).ToString('yyyy-MM-ddTHH:mm:ss.ffffZ')

	$SessionURI = 'https://api-' + $region + '.cloud.com/monitorodata\Sessions?$apply=filter(StartDate ge ' + $LastWeek + ' and StartDate le ' + $Today + ' )'
	$ConnectionsURI = 'https://api-' + $region + '.cloud.com/monitorodata\Connections?$apply=filter(LogOnStartDate ge ' + $LastWeek + ' and LogOnStartDate le ' + $Today + ' )'
	$UsersURI = 'https://api-' + $region + '.cloud.com/monitorodata\Users'
	$MachinesURI = 'https://api-' + $region + '.cloud.com/monitorodata\Machines'
	$SessionMetricURI = 'https://api-' + $region + '.cloud.com/monitorodata\SessionMetrics?$apply=filter(CollectedDate ge ' + $LastWeek + ' and CollectedDate le ' + $Today + ' )'


	$headers = @{Authorization = "CwsAuth Bearer=$($ApiToken)" }
	$headers += @{
		'Citrix-CustomerId' = $customerId
		Accept              = 'application/json'
	}

	$sessions = ((Invoke-WebRequest -Uri $SessionURI -Headers $headers).Content | ConvertFrom-Json).value
	$sessionsMetric = ((Invoke-WebRequest -Uri $SessionMetricURI -Headers $headers).Content | ConvertFrom-Json).value
	$connections = ((Invoke-WebRequest -Uri $ConnectionsURI -Headers $headers).Content | ConvertFrom-Json).value
	$users = ((Invoke-WebRequest -Uri $UsersURI -Headers $headers).Content | ConvertFrom-Json).value
	$machines = ((Invoke-WebRequest -Uri $MachinesURI -Headers $headers).Content | ConvertFrom-Json).value

	$data = @()
	foreach ($connection in $connections) {
		try {
			$session = $sessions | Where-Object { $_.SessionKey -like $connection.SessionKey }
			$user = $users | Where-Object { $_.id -like $session.UserId }
			$mashine = $machines | Where-Object { $_.id -like $session.MachineId }
			$avgrtt = 0
			$sessionsMetric | Where-Object { $_.Sessionid -like $connection.SessionKey } | ForEach-Object { $avgrtt = $avgrtt + $_.IcaRttMS }
			$avgrtt = $avgrtt / ($sessionsMetric | Where-Object { $_.Sessionid -like $connection.SessionKey }).count
		} catch { Write-Warning 'Not enough data' }
		$data += [PSCustomObject]@{
			FullName                 = $user.FullName
			Upn                      = $user.upn
			DnsName                  = $mashine.DnsName
			IPAddress                = $mashine.IPAddress
			IsInMaintenanceMode      = $mashine.IsInMaintenanceMode
			CurrentRegistrationState = $mashine.CurrentRegistrationState
			OSType                   = $mashine.OSType
			ClientName               = $connection.ClientName
			ClientVersion            = $connection.ClientVersion
			ClientAddress            = $connection.ClientAddress
			ClientPlatform           = $connection.ClientPlatform
			IsReconnect              = $connection.IsReconnect
			IsSecureIca              = $connection.IsSecureIca
			Protocol                 = $connection.Protocol
			LogOnStartDate           = $connection.LogOnStartDate
			LogOnEndDate             = $connection.LogOnEndDate
			AuthenticationDuration   = $connection.AuthenticationDuration
			LogOnDuration            = $session.LogOnDuration
			EndDate                  = $session.EndDate
			ExitCode                 = $session.ExitCode
			FailureDate              = $session.FailureDate
			ConnectionState          = $session.ConnectionState
			AVG_ICA_RTT              = $avgrtt
		}


	}

	if ($ExportToExcel) {
		[string]$ExcelReportname = $ReportPath + '\Session_Audit-' + (Get-Date -Format yyyy.MM.dd-HH.mm) + '.xlsx'
		$data | Export-Excel -Path $ExcelReportname -AutoSize -AutoFilter -Show
	} else { $data | Out-GridHtml;$data }



} #end Function
