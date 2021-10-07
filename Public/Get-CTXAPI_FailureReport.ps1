
<#PSScriptInfo

.VERSION 1.1.1

.GUID 73cfd5d4-233b-4c97-bfad-0f280a0188dc

.AUTHOR Pierre Smit

.COMPANYNAME iOCO Tech

.COPYRIGHT

.TAGS ctx

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Created [06/10/2021_18:14] Initital Script Creating
Updated [06/10/2021_19:01] "Help Files Added"

.PRIVATEDATA

#>

<#

.DESCRIPTION
"Reports on connection failures"

#>

Param()





#.ExternalHelp CTXCloudApi-help.xml
Function Get-CTXAPI_FailureReport {
	[Cmdletbinding()]
    [OutputType([System.Object[]])]
    PARAM(
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[string]$CustomerId,
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[string]$SiteId,
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[string]$ApiToken,
        [Parameter(Mandatory = $false,ParameterSetName='Got odata')]
		[pscustomobject]$MonitorData = $null,
		[Parameter(Mandatory = $false,ParameterSetName='Fetch odata')]
		[ValidateNotNullOrEmpty()]
		[ValidateSet('us', 'eu', 'ap-s')]
		[string]$region,
		[ValidateNotNullOrEmpty()]
		[Parameter(Mandatory = $false,ParameterSetName='Fetch odata')]
		[int]$hours = 24,
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[ValidateSet('Connection', 'Machine')]
		[string]$FailureType,
		[Parameter(Mandatory = $false)]
		[ValidateSet('Excel', 'HTML')]
		[string]$Export = 'Host',
		[Parameter(Mandatory = $false)]
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
	if ($Export -eq 'HTML') { $data | Out-HtmlView -DisablePaging -Title 'Citrix Failures' -HideFooter -SearchHighlight -FixedHeader }
	if ($Export -eq 'Host') { $data }

} #end Function
