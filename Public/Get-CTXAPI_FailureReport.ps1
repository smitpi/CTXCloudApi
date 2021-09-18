
<#PSScriptInfo

.VERSION 1.0.4

.GUID bcce614e-ed5b-4f57-b35d-526154d152a9

.AUTHOR Pierre Smit

.COMPANYNAME iOCO Tech

.COPYRIGHT

.TAGS Citrix PowerShell

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
Updated [05/05/2021_00:03] added monitor data
Updated [05/05/2021_14:33] 'Update Manifest'

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
	[Cmdletbinding()]
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
        [Parameter(Mandatory = $false,ParameterSetName='Got odata')]
		[pscustomobject]$MonitorData = $null,
		[Parameter(Mandatory = $false, Position = 3,ParameterSetName='Fetch odata')]
		[ValidateNotNullOrEmpty()]
		[ValidateSet('us', 'eu', 'ap-s')]
		[string]$region,
		[ValidateNotNullOrEmpty()]
		[Parameter(Mandatory = $false, Position = 4,ParameterSetName='Fetch odata')]
		[int]$hours = 24,
		[Parameter(Mandatory = $true, Position = 5)]
		[ValidateNotNullOrEmpty()]
		[ValidateSet('Connection', 'Machine')]
		[string]$FailureType,
		[Parameter(Mandatory = $false, Position = 6)]
		[ValidateSet('Excel', 'HTML')]
		[string]$Export = 'Host',
		[Parameter(Mandatory = $false, Position = 7)]
		[ValidateScript( { (Test-Path $_) })]
		[string]$ReportPath = $env:temp
	)

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
