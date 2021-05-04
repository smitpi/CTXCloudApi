
<#PSScriptInfo

.VERSION 1.0.2

.GUID bcce614e-ed5b-4f57-b35d-526154d152a9

.AUTHOR Pierre Smit

.COMPANYNAME iOCO Tech

.COPYRIGHT

.TAGS PowerShell Citrix

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Created [22/04/2021_10:08] Initital Script Creating
Updated [22/04/2021_11:42] Script Fle Info was updated
Updated [24/04/2021_07:21] Added details from machines api to extract more data

.PRIVATEDATA

#> 

#Requires -Module ImportExcel
#Requires -Module PSWriteHTML
#Requires -Module PSWriteColor


<# 

.DESCRIPTION 
Creates a report on connection and machine failures in the last x hours

#> 

Param()


Function Get-CTXAPI_FailureReport {
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
        [Parameter(Mandatory = $false, Position = 3)]
		[pscustomobject]$MonitorData = $null,
		[Parameter(Mandatory = $false, Position = 4)]
		[ValidateNotNullOrEmpty()]
		[ValidateSet('us', 'eu', 'ap-s')]
		[string]$region,
		[ValidateNotNullOrEmpty()]
		[Parameter(Mandatory = $false, Position = 5)]
		[int]$hours = 24,
		[Parameter(Mandatory = $true, Position = 6)]
		[ValidateNotNullOrEmpty()]
		[ValidateSet('Connection', 'Machine')]
		[string]$FailureType,
		[Parameter(Mandatory = $false, Position = 7)]
		[ValidateSet('Excel', 'HTML')]
		[string]$Export = 'Host',
		[Parameter(Mandatory = $false, Position = 8)]
		[ValidateScript( { (Test-Path $_) })]
		[string]$ReportPath = $env:temp
	)

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
	$ConnectionFailureType = [PSCustomObject]@{
		0 = 'None'
		1 = 'ClientConnectionFailure'
		2 = 'MachineFailure'
		3 = 'NoCapacityAvailable'
		4 = 'NoLicensesAvailable'
		5 = 'Configuration'
	}
	$RegistrationState = [PSCustomObject]@{
		0 = 'Unknown'
		1 = 'Registered'
		2 = 'Unregistered'
	}

    if ($Null -eq $MonitorData) { $mondata = Get-CTXAPI_MonitorData -CustomerId $CustomerId -SiteId $siteid -ApiToken $apitoken -region $region -hours $hours }
    else {$mondata = $MonitorData }

	$data = @()

	if ($FailureType -eq 'Machine') {
		$machines = Get-CTXAPI_machines -CustomerId $CustomerId -SiteId $SiteId -ApiToken $ApiToken
		foreach ($log in $mondata.MachineFailureLogs) {
			$MonDataMachine = $mondata.Machines | Where-Object { $_.id -eq $log.MachineId }
			$APIMachine = $machines | Where-Object { $_.dnsname -like $MonDataMachine.DnsName }
			$data += [PSCustomObject]@{
				Name                     = $MonDataMachine.DnsName
				IP                       = $MonDataMachine.IPAddress
				OSType                   = $MonDataMachine.OSType
				FailureStartDate         = $log.FailureStartDate
				FailureEndDate           = $log.FailureEndDate
				FaultState               = $log.FaultState
				LastDeregistrationReason = $APIMachine.LastDeregistrationReason
				LastConnectionFailure    = $APIMachine.LastConnectionFailure
				LastErrorReason          = $APIMachine.LastErrorReason
				CurrentFaultState        = $APIMachine.FaultState

			}

		}
	}
	if ($FailureType -eq 'Connection') {
		foreach ($log in $mondata.ConnectionFailureLogs) {
			$session = $mondata.Session | Where-Object { $_.SessionKey -eq $log.SessionKey }
			$user = $mondata.users | Where-Object { $_.id -like $Session.UserId }
			$mashine = $mondata.machines | Where-Object { $_.id -like $Session.MachineId }	
			$data += [PSCustomObject]@{
				UserName                   = $user.UserName
				FullName                   = $user.FullName
				DnsName                    = $mashine.DnsName
				IPAddress                  = $mashine.IPAddress
				CurrentRegistrationState   = $RegistrationState.($mashine.CurrentRegistrationState)
				FailureDate                = $log.FailureDate
				ConnectionFailureEnumValue	= $SessionFailureCode.($log.ConnectionFailureEnumValue)
			}
		}
	}



	if ($Export -eq 'Excel') { $data | Export-Excel -Path ($ReportPath + '\Failure_Audit-' + (Get-Date -Format yyyy.MM.dd-HH.mm) + '.xlsx') -AutoSize -AutoFilter -Show } 
	if ($Export -eq 'HTML') { $data | Out-GridHtml -DisablePaging -Title 'Citrix Failures' -HideFooter -SearchHighlight -FixedHeader }
	if ($Export -eq 'Host') { $data }

} #end Function
