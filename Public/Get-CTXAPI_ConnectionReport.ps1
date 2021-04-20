
<#PSScriptInfo

.VERSION 1.0.0

.GUID ccc3348a-02f0-4e82-91bf-d65549ca3533

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
Created [20/04/2021_10:46] Initital Script Creating

.PRIVATEDATA

#>

<# 


#requires –Modules ImportExcel,PSWriteHTML,PSWriteColor

.DESCRIPTION 
 Report on connections 

#> 

Param()


Function Get-CTXAPI_ConnectionReport {
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

	$mondata = Get-CTXAPI_MonitorData -CustomerId $CustomerId -SiteId $siteid -ApiToken $apitoken -region $region -hours $hours

	$data = @()
	foreach ($connection in $mondata.Connections) {
		try {
			$OneSession = $mondata.session | Where-Object { $_.SessionKey -eq $connection.SessionKey }
			$user = $mondata.users | Where-Object { $_.id -like $OneSession.UserId }
			$mashine = $mondata.machines | Where-Object { $_.id -like $OneSession.MachineId }
			try {
				$avgrtt = 0
				$mondata.SessionMetrics | Where-Object { $_.Sessionid -like $OneSession.SessionKey } | ForEach-Object { $avgrtt = $avgrtt + $_.IcaRttMS }
				$avgrtt = $avgrtt / ($mondata.SessionMetrics | Where-Object { $_.Sessionid -like $OneSession.SessionKey }).count
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
			AVG_ICA_RTT              = [math]::Round($avgrtt)
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
