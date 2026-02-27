
<#PSScriptInfo

.VERSION 0.1.0

.GUID f76fe7fa-dc1a-49a2-b033-ed82b3568f83

.AUTHOR Pierre Smit

.COMPANYNAME HTPCZA Tech

.COPYRIGHT

.TAGS ps ctx

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Created [26/02/2026_10:38] Initial Script

.PRIVATEDATA

#>

<# 

.DESCRIPTION 
 Creates varius reports from the monitor data 

#> 


<#

.SYNOPSIS
Generate Citrix Cloud monitoring reports in multiple formats (Host, Excel, HTML).

.DESCRIPTION
New-CTXAPI_Report generates detailed Citrix Cloud monitoring reports, including resource utilization, connection activity, connection failures, session reports, machine failures, and login duration analytics. The function can output reports to the host, export to Excel, or create a styled HTML report with embedded branding. Data can be sourced from a provided MonitorData object or fetched live via API.

.PARAMETER APIHeader
The authentication header object for Citrix Cloud API requests. Required for all operations.

.PARAMETER MonitorData
Optional. Pre-fetched monitoring data object. If not provided, the function retrieves data using Get-CTXAPI_MonitorData.

.PARAMETER LastHours
Optional. Number of hours of historical data to include (default: 24). Used only if MonitorData is not provided.

.PARAMETER ReportType
Specifies which report(s) to generate. Valid values:
 - ConnectionFailureReport: Details on failed connection attempts.
 - MachineFailureReport: Details on machine failures and fault states.
 - SessionReport: Session-level analytics and metrics.
 - MachineReport: Machine resource utilization and status.
 - LoginDurationReport: Per-hour and total login duration breakdowns.
 - All: All available reports.

.PARAMETER Export
Specifies the output format. Valid values: Host (default), Excel, HTML.

.PARAMETER ReportPath
Directory path for exported reports (Excel/HTML). Defaults to $env:TEMP. Must exist.

.OUTPUTS
PSCustomObject containing one or more of the following properties, depending on ReportType:
 - ConnectionFailureReport
 - MachineFailureReport
 - SessionReport
 - MachineReport
 - PerHourLoginDurationReport (LoginDurationReport)
 - TotalLoginDurationReport (LoginDurationReport)

.NOTES
Requires the ImportExcel and PSHTML modules for Excel and HTML export functionality.
ReportPath must exist for file exports.

.EXAMPLE
New-CTXAPI_Report -APIHeader $header -ReportType All -Export HTML -ReportPath C:\Reports
Generates all available reports and exports them as a styled HTML file to C:\Reports.

.EXAMPLE
New-CTXAPI_Report -APIHeader $header -ReportType LoginDurationReport -Export Excel -ReportPath C:\Reports
Generates per-hour and total login duration reports and exports them to Excel.

.EXAMPLE
New-CTXAPI_Report -APIHeader $header -ReportType SessionReport -Export Host
Returns session analytics to the host (console output).


#>

function New-CTXAPI_Report {
	[Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/New-CTXAPI_Report')]
	[OutputType([System.Object[]])]
	#region Parameter
	param(
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[PSTypeName('CTXAPIHeaderObject')]$APIHeader,
		[Parameter(Mandatory = $false, ParameterSetName = 'Got odata')]
		[PSTypeName('CTXMonitorData')]$MonitorData,
		[ValidateNotNullOrEmpty()]
		[Parameter(Mandatory = $false, ParameterSetName = 'Needdata')]
		[int]$LastHours = 24,
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[ValidateSet('ConnectionFailureReport', 'MachineFailureReport', 'SessionReport', 'MachineReport', 'LoginDurationReport', 'All')]
		[string[]]$ReportType,
		[Parameter(Mandatory = $false)]
		[ValidateSet('Host', 'Excel', 'HTML')]
		[string]$Export = 'Host',
		[Parameter(Mandatory = $false)]
		[ValidateScript( { (Test-Path $_) })]
		[System.IO.DirectoryInfo]$ReportPath = $env:temp
	)
	if (-not(Test-CTXAPI_Header -APIHeader $APIHeader)) {Test-CTXAPI_Header -APIHeader $APIHeader -AutoRenew}
	else {	Write-Verbose "[$(Get-Date -Format HH:mm:ss) APIHEADER] Header still valid"}

	if ($PSBoundParameters.ContainsKey('MonitorData')) {
		Write-Verbose 'Using provided MonitorData.'
		$monitordata = $MonitorData
		Write-Verbose ('MonitorData contains: Sessions={0}, Connections={1}, Machines={2}, Users={3}' -f $monitordata.sessions.Count, $monitordata.connections.Count, $monitordata.machines.Count, $monitordata.users.Count)
	} else {
		Write-Verbose "Fetching MonitorData using Get-CTXAPI_MonitorData for last $LastHours hours."
		$monitordata = Get-CTXAPI_MonitorData -APIHeader $APIHeader -LastHours $LastHours
		Write-Verbose ('Fetched MonitorData: Sessions={0}, Connections={1}, Machines={2}, Users={3}' -f $monitordata.sessions.Count, $monitordata.connections.Count, $monitordata.machines.Count, $monitordata.users.Count)
	}

	$ConnectionFailureReportObject = $null
	$MachineFailureReportObject = $null
	$SessionReportObject = $null
	$MachineReportObject = $null
	$PerHourLoginDurationReportObject = $null
	$TotalLoginDurationReportObject = $null


	if (($PSBoundParameters['ReportType'] -contains 'ConnectionFailureReport') -or ($PSBoundParameters['ReportType'] -contains 'All')) {
		[System.Collections.generic.List[PSObject]]$ConnectionFailureReportObject = @()
		$allConnectionFailureLogs = $monitordata.ConnectionFailureLogs
		foreach ($log in $allConnectionFailureLogs) {
			try {
				Write-Verbose "[$(Get-Date -Format HH:mm:ss) ConnectionFailureReport] $($allConnectionFailureLogs.IndexOf($log) + 1) of $($allConnectionFailureLogs.Count)"
				$session = $monitordata.Sessions | Where-Object { $_.SessionKey -eq $log.SessionKey }
				Write-Verbose "[$(Get-Date -Format HH:mm:ss) ConnectionFailureReport] `t`t sessions = $($session.count)"
				$user = $monitordata.users | Where-Object { $_.id -like $Session.UserId }
				$mashine = $monitordata.machines | Where-Object { $_.id -like $Session.MachineId }
			
				$user = if ($user) { $user.Upn } else { $null }
				$DnsName = if ($mashine) { $mashine.DnsName } else { $null }
				$FailureDate = $session.FailureDate
				$ConnectionFailure = $script:SessionFailureCode.([int]$log.ConnectionFailureEnumValue)
				$IsInMaintenanceMode = $log.IsInMaintenanceMode
				$PowerState = $script:PowerStateCode.([int]$log.PowerState)
				$RegistrationState = $script:RegistrationState.([int]$log.RegistrationState)
				$ConnectionState = $script:ConnectionState.([int]$session.ConnectionState)
				$LifecycleState = $script:LifecycleState.([int]$session.LifecycleState)
				$SessionType = $script:SessionType.([int]$session.SessionType)
				$ConnectionFailureReportObject.Add([PSCustomObject]@{
						User                       = Check-Variable -VariableName $user
						DnsName                    = Check-Variable -VariableName $DnsName
						FailureDate                = Check-Variable -VariableName $FailureDate
						ConnectionFailureEnumValue = Check-Variable -VariableName $ConnectionFailure
						IsInMaintenanceMode        = Check-Variable -VariableName $IsInMaintenanceMode
						PowerState                 = Check-Variable -VariableName $PowerState
						RegistrationState          = Check-Variable -VariableName $RegistrationState
						ConnectionState            = Check-Variable -VariableName $ConnectionState
						LifecycleState             = Check-Variable -VariableName $LifecycleState
						SessionType                = Check-Variable -VariableName $SessionType
					})
			} catch {
				Write-Warning "[ConnectionFailureReport] Error processing session metrics.- SessionKey: $($session.SessionKey)"
				Write-Warning "[ConnectionFailureReport] Message: $($_.Exception.Message)"
				Write-Warning "[ConnectionFailureReport] Script ScriptLineNumber: $($_.InvocationInfo.ScriptLineNumber)"
				Write-Warning "[ConnectionFailureReport] Script Line: $($_.InvocationInfo.Line)"
				Write-Warning "[ConnectionFailureReport] Script BoundParameters: $($_.InvocationInfo.BoundParameters | Out-String)"
			}
		}
		Write-Verbose "[$(Get-Date -Format HH:mm:ss) ConnectionFailureReport] - Complete"
	}

	if (($PSBoundParameters['ReportType'] -contains 'MachineFailureReport') -or ($PSBoundParameters['ReportType'] -contains 'All')) {
		[System.Collections.generic.List[PSObject]]$MachineFailureReportObject = @()
		$machines = $monitordata.machines
		$AllMachineFailureLogs = $monitordata.MachineFailureLogs
		foreach ($log in $AllMachineFailureLogs) {
			try {
				Write-Verbose "[$(Get-Date -Format HH:mm:ss) MachineFailureReport] $($AllMachineFailureLogs.IndexOf($log) + 1) of $($AllMachineFailureLogs.Count)"
				$MachinesFiltered = $monitordata.machines | Where-Object { $_.id -like $log.MachineId }

				$DnsName = $MachinesFiltered.DnsName
				$AssociatedUserNames = $MachinesFiltered.AssociatedUserNames
				$OSType = $MachinesFiltered.OSType
				$IsAssigned = $MachinesFiltered.IsAssigned
				$FailureStartDate = $log.FailureStartDate
				$FailureEndDate = $log.FailureEndDate
				$FailureReason = $script:MachineFaultStateCode.([int]$log.FaultState)
				$LastDeregistrationReason = $script:MachineDeregistration.([int]$MachinesFiltered.LastDeregisteredCode)
				$LastDeregisteredDate = $MachinesFiltered.LastDeregisteredDate
				$LastPowerActionType = $script:PowerActionTypeCode.([int]$MachinesFiltered.LastPowerActionType)
				$LastPowerActionReason = $script:PowerActionReasonCode.([int]$MachinesFiltered.LastPowerActionReason)
				$LastPowerActionFailureReason = $script:MachineDeregistration.([int]$MachinesFiltered.LastPowerActionFailureReason)
				$LastPowerActionCompletedDate = $MachinesFiltered.LastPowerActionCompletedDate
				$CurrentFaultState = $script:MachineFaultStateCode.([int]$MachinesFiltered.FaultState)
				$CurrentIsInMaintenanceMode = $MachinesFiltered.IsInMaintenanceMode
				$CurrentRegistrationState = $script:RegistrationState.([int]$MachinesFiltered.CurrentRegistrationState)

				$MachineFailureReportObject.Add([PSCustomObject]@{
						Name                         = Check-Variable -VariableName $DnsName
						AssociatedUserUPNs           = Check-Variable -VariableName $AssociatedUserNames
						OSType                       = Check-Variable -VariableName $OSType
						IsAssigned                   = Check-Variable -VariableName $IsAssigned
						FailureStartDate             = Check-Variable -VariableName $FailureStartDate
						FailureEndDate               = Check-Variable -VariableName $FailureEndDate
						FailureReason                = Check-Variable -VariableName $FailureReason
						LastDeregistrationReason     = Check-Variable -VariableName $LastDeregistrationReason
						LastDeregisteredDate         = Check-Variable -VariableName $LastDeregisteredDate
						LastPowerActionType          = Check-Variable -VariableName $LastPowerActionType
						LastPowerActionReason        = Check-Variable -VariableName $LastPowerActionReason
						LastPowerActionFailureReason = Check-Variable -VariableName $LastPowerActionFailureReason
						LastPowerActionCompletedDate = Check-Variable -VariableName $LastPowerActionCompletedDate
						CurrentFaultState            = Check-Variable -VariableName $CurrentFaultState
						CurrentIsInMaintenanceMode   = Check-Variable -VariableName $IsInMaintenanceMode
						CurrentRegistrationState     = Check-Variable -VariableName $CurrentRegistrationState
					})
			} catch {
				Write-Warning "[MachineFailureReport] Error processing session metrics.- SessionKey: $($log.MachineId)"
				Write-Warning "[MachineFailureReport] Message: $($_.Exception.Message)"
				Write-Warning "[MachineFailureReport] Script ScriptLineNumber: $($_.InvocationInfo.ScriptLineNumber)"
				Write-Warning "[MachineFailureReport] Script Line: $($_.InvocationInfo.Line)"
				Write-Warning "[MachineFailureReport] Script BoundParameters: $($_.InvocationInfo.BoundParameters | Out-String)"
			}
		}
		Write-Verbose "[$(Get-Date -Format HH:mm:ss) MachineFailureReport] - Complete"
	}

	if (($PSBoundParameters['ReportType'] -contains 'SessionReport') -or ($PSBoundParameters['ReportType'] -contains 'All')) {
		[System.Collections.generic.List[PSObject]]$SessionReportObject = @()
		$AllSessions = $monitordata.sessions
		$AllsessionMetrics = $monitordata.SessionMetrics | Group-Object -Property SessionId
		$ColGroup = $monitordata.connections | Group-Object -Property SessionKey
		foreach ($session in $AllSessions) {
			try {
				Write-Verbose "[$(Get-Date -Format HH:mm:ss) PROCESS] $($AllSessions.IndexOf($session) + 1) of $($AllSessions.Count)"
				$machine = $monitordata.machines | Where-Object { $_.Id -like $session.MachineId }
				$user = $monitordata.users | Where-Object { $_.Id -like $session.UserId }
				##todo use sessions.currentconnectionid $monitordata.Connections | Where-Object { $_.id -like "8238504" }
				$FilterConnect = $ColGroup | Where-Object { $_.Name -like $session.SessionKey } 
				[System.Collections.generic.List[PSObject]]$Connections = @()
				if ($FilterConnect) {
					$FilterConnect.Group | ForEach-Object { $Connections.Add($_) }
					Write-Verbose "[$(Get-Date -Format HH:mm:ss)] [Connections] $($FilterConnect.Count) connections found for session $($session.SessionKey)"
					$ConnectionState = $script:ConnectionState.([int]$session.ConnectionState)
					$IsReconnect = $Connections[-1].IsReconnect
					$AuthenticationDuration = (($Connections.AuthenticationDuration | Measure-Object -Sum).Sum / 1000) 
					$BrokeringDuration = (($Connections.BrokeringDuration | Measure-Object -Sum).Sum / 1000)
					$WorkspaceType = $script:WorkspaceType.([int]$Connections[-1].WorkspaceType)
					$ClientLocationCountry = $Connections[-1].ClientLocationCountry
					$ClientPlatform = $Connections[-1].ClientPlatform
				} else {
					Write-Verbose "[$(Get-Date -Format HH:mm:ss)] [Connections] No connections found for session $($session.SessionKey)"
					$ConnectionState = $null
					$IsReconnect = $null
					$AuthenticationDuration = $null
					$BrokeringDuration = $null
					$WorkspaceType = $null
					$ClientLocationCountry = $null
					$ClientPlatform = $null
				}
				$FilterMetrics = $AllsessionMetrics | Where-Object { $_.Name -like $session.SessionKey } 
				[System.Collections.generic.List[PSObject]]$SessionMetrics = @()
				if ($FilterMetrics) { 
					$FilterMetrics.Group | ForEach-Object { $SessionMetrics.Add($_) } 
					$IcaLatency = [math]::Round((($SessionMetrics.icaLatency | Measure-Object -Average).Average))
					$IcaRttMS = [math]::Round((($SessionMetrics.icaRttMS | Measure-Object -Average).Average))
					Write-Verbose "[$(Get-Date -Format HH:mm:ss)] [Metrics] $($FilterMetrics.Count) metrics found for session $($session.SessionKey)"
				} else {
					Write-Verbose "[$(Get-Date -Format HH:mm:ss)] [Metrics] No metrics found for session $($session.SessionKey)"
					$IcaLatency = $null
					$IcaRttMS = $null
				}
				$MachineName = if ($machine) { $machine.Name } else { $null }
				$User = if ($user) { $user.Upn } else { $null }

				$LogOnDuration = if ($session.LogOnDuration -ne $null) { [math]::Round($session.LogOnDuration / 1000) } else { $null }
				$ClientLogOnDuration = if ($session.ClientLogOnDuration -ne $null) { [math]::Round($session.ClientLogOnDuration / 1000) } else { $null }

				$FailureId = $script:SessionFailureCode.([int]$session.FailureId)
				$FailureDate = $session.FailureDate
				$SessionStartTime = $session.StartDate
				$SessionEndTime = $session.EndDate
			} catch {
				Write-Warning "[SessionReport] Error processing session metrics.- SessionKey: $($session.SessionKey)"
				Write-Warning "[SessionReport] Message: $($_.Exception.Message)"
				Write-Warning "[SessionReport] Script ScriptLineNumber: $($_.InvocationInfo.ScriptLineNumber)"
				Write-Warning "[SessionReport] Script Line: $($_.InvocationInfo.Line)"
				Write-Warning "[SessionReport] Script BoundParameters: $($_.InvocationInfo.BoundParameters | Out-String)"
			}
			Write-Verbose "[$(Get-Date -Format HH:mm:ss) SessionReport] Adding to object"
			$SessionReportObject.Add([PSCustomObject]@{
					MachineName            = Check-Variable -VariableName $MachineName
					UserName               = Check-Variable -VariableName $User
					ConnectionState        = Check-Variable -VariableName $ConnectionState
					IsReconnect            = Check-Variable -VariableName $IsReconnect
					LogOnDuration          = Check-Variable -VariableName $LogOnDuration
					ClientLogOnDuration    = Check-Variable -VariableName $ClientLogOnDuration
					AuthenticationDuration = Check-Variable -VariableName $AuthenticationDuration
					BrokeringDuration      = Check-Variable -VariableName $BrokeringDuration
					IcaRttMS               = Check-Variable -VariableName $IcaRttMS
					IcaLatency             = Check-Variable -VariableName $IcaLatency
					WorkspaceType          = Check-Variable -VariableName $WorkspaceType
					ClientLocationCountry  = Check-Variable -VariableName $ClientLocationCountry
					ClientPlatform         = Check-Variable -VariableName $ClientPlatform
					FailureId              = Check-Variable -VariableName $FailureId
					FailureDate            = Check-Variable -VariableName $FailureDate
					SessionStartTime       = Check-Variable -VariableName $SessionStartTime
					SessionEndTime         = Check-Variable -VariableName $SessionEndTime
				}) #PSList
			Write-Verbose "[$(Get-Date -Format HH:mm:ss) SessionReport] Object added`n`n`n"

		}
	}

	if (($PSBoundParameters['ReportType'] -contains 'MachineReport') -or ($PSBoundParameters['ReportType'] -contains 'All')) {
		[System.Collections.generic.List[PSObject]]$MachineReportObject = @()
		$machineList = $monitordata.machines | Where-Object {$_.LifecycleState -eq 0}
		foreach ($machine in $machineList) {
			try {
				Write-Verbose "[$(Get-Date -Format HH:mm:ss) MachineReport] $($machineList.IndexOf($machine) + 1) of $($machineList.Count)"
				$resourceUtilization = $monitordata.ResourceUtilizationSummary | Where-Object { $_.MachineId -like $machine.id }
				Write-Verbose "[$(Get-Date -Format HH:mm:ss) MachineReport] `t`t ResourceUtilizationSummary"
				$catalog = $monitordata.catalogs | Where-Object { $_.Id -like $machine.CatalogId }
				$desktopGroup = $monitordata.DesktopGroups | Where-Object { $_.Id -like $machine.DesktopGroupId }

				$AvgUsedMemory = [math]::Round((($resourceUtilization | Measure-Object -Property AvgUsedMemory -Average).average) / 1MB)
				$AvgIcaRttInMs = [math]::Round(($resourceUtilization | Measure-Object -Property AvgIcaRttInMs -Average).average)
				$AvgPercentCpu = [math]::Round(($resourceUtilization | Measure-Object -Property AvgPercentCpu -Average).average)
				$AvgLogOnDurationInSec = [math]::Round((($resourceUtilization | Measure-Object -Property AvgLogOnDurationInMs -Average).average) / 1000)
				$UptimeInMinutes = [math]::Round(($resourceUtilization | Measure-Object -Property UptimeInMinutes -Average).average)
				$UpTimeWithoutSessionInMinutes = [math]::Round(($resourceUtilization | Measure-Object -Property UpTimeWithoutSessionInMinutes -Average).average)
				$AvgDiskLatency = [math]::Round(($resourceUtilization | Measure-Object -Property AvgDiskLatency -Average).average)
				$StartSumDate = $resourceUtilization.SummaryDate | Sort-Object | Select-Object -First 1
				$EndSumDate = $resourceUtilization.SummaryDate | Sort-Object | Select-Object -Last 1
				$timespan = (New-TimeSpan -Start $StartSumDate -End $EndSumDate).TotalHours

				$OSType = $machine.OSType
				$DesktopGroupName = $desktopGroup.Name
				$MachineCatalogName = $catalog.Name
				$FaultState = $script:MachineFaultStateCode.([int]$machine.FaultState)
				$CurrentSessionCount = $machine.CurrentSessionCount
				$CurrentPowerState = $script:PowerStateCode.([int]$machine.CurrentPowerState)
				$CurrentRegistrationState = $script:RegistrationState.([int]$machine.CurrentRegistrationState)
				$IsInMaintenanceMode = $machine.IsInMaintenanceMode
				$AssociatedUserUPNs = $machine.AssociatedUserUPNs
				$IsAssigned = $machine.IsAssigned
				$MachineName = $machine.Name


				Write-Verbose "[$(Get-Date -Format HH:mm:ss) MachineReport] Adding to object"
				$MachineReportObject.Add([PSCustomObject]@{
						Name                          = Check-Variable -VariableName $MachineName
						IsAssigned                    = Check-Variable -VariableName $IsAssigned
						AssociatedUserUPNs            = Check-Variable -VariableName $AssociatedUserUPNs
						IsInMaintenanceMode           = Check-Variable -VariableName $IsInMaintenanceMode
						CurrentRegistrationState      = Check-Variable -VariableName $CurrentRegistrationState
						CurrentPowerState             = Check-Variable -VariableName $CurrentPowerState
						CurrentSessionCount           = Check-Variable -VariableName $CurrentSessionCount
						FaultState                    = Check-Variable -VariableName $FaultState
						CatalogName                   = Check-Variable -VariableName $MachineCatalogName
						DesktopGroupName              = Check-Variable -VariableName $DesktopGroupName
						OSType                        = Check-Variable -VariableName $OSType
						AvgPercentCpu                 = Check-Variable -VariableName $AvgPercentCpu
						AvgUsedMemory                 = Check-Variable -VariableName $AvgUsedMemory
						AvgIcaRttInMs                 = Check-Variable -VariableName $AvgIcaRttInMs
						AvgLogOnDurationInSec         = Check-Variable -VariableName $AvgLogOnDurationInSec
						UptimeInMinutes               = Check-Variable -VariableName $UptimeInMinutes
						UpTimeWithoutSessionInMinutes = Check-Variable -VariableName $UpTimeWithoutSessionInMinutes
						AvgDiskLatency                = Check-Variable -VariableName $AvgDiskLatency
						CollectionDateStart           = Check-Variable -VariableName $StartSumDate
						CollectionDateEnd             = Check-Variable -VariableName $EndSumDate
						CollectionDuration            = Check-Variable -VariableName $timespan
					}) #PSList
				Write-Verbose "[$(Get-Date -Format HH:mm:ss) MachineReport] Object added`n"
			} catch {
				Write-Warning "[MachineReport] Error processing session metrics.- SessionKey: $($machine.id)"
				Write-Warning "[MachineReport] Message: $($_.Exception.Message)"
				Write-Warning "[MachineReport] Script ScriptLineNumber: $($_.InvocationInfo.ScriptLineNumber)"
				Write-Warning "[MachineReport] Script Line: $($_.InvocationInfo.Line)"
				Write-Warning "[MachineReport] Script BoundParameters: $($_.InvocationInfo.BoundParameters | Out-String)"
			}
		}
		Write-Verbose "[$(Get-Date -Format HH:mm:ss) MachineReport] - Complete"
	}

	if (($PSBoundParameters['ReportType'] -contains 'LoginDurationReport') -or ($PSBoundParameters['ReportType'] -contains 'All')) {

		[System.Collections.generic.List[PSObject]]$PerHourLoginDurationReportObject = @()
		[System.Collections.generic.List[PSObject]]$TotalLoginDurationReportObject = @()

		$AllLogons = $MonitorData.LogOnSummaries
		$GroupedLogons = $AllLogons | Group-Object -Property DesktopGroupId
		foreach ($login in $GroupedLogons) {
			try {
				$DesktopGroup = $MonitorData.DesktopGroups | Where-Object { $_.Id -like $login.Name }
				foreach ($Perhour in $login.Group) {
					try {
						$DesktopGroup = $MonitorData.DesktopGroups | Where-Object { $_.Id -like $Perhour.DesktopGroupId }

						$CollectDate = Convert-UTCtoLocal -Time $Perhour.SummaryDate
						$Hour = $CollectDate.Hour
						$DesktopGroupName = $DesktopGroup.Name
						$TotalHourLogins = $Perhour.TotalCount
						$AvgBrokeringDuration = Calc-Avg -Duration $Perhour.BrokeringDuration -Count $Perhour.TotalCount -ToSeconds
						$avgVMPowerOnDuration = Calc-Avg -Duration $Perhour.VMPowerOnDuration -Count $Perhour.TotalCount -ToSeconds
						$avgVMRegistrationDuration = Calc-Avg -Duration $Perhour.VMRegistrationDuration -Count $Perhour.TotalCount -ToSeconds
						$avgAuthenticationDuration = Calc-Avg -Duration $Perhour.AuthenticationDuration -Count $Perhour.TotalCount -ToSeconds
						$avgGpoDuration = Calc-Avg -Duration $Perhour.GpoDuration -Count $Perhour.TotalCount -ToSeconds
						$avgLogOnScriptsDuration = Calc-Avg -Duration $Perhour.LogOnScriptsDuration -Count $Perhour.TotalCount -ToSeconds
						$avgInteractiveDuration = Calc-Avg -Duration $Perhour.InteractiveDuration -Count $Perhour.TotalCount -ToSeconds
						$avgProfileLoadDuration = Calc-Avg -Duration $Perhour.ProfileLoadDuration -Count $Perhour.TotalCount -ToSeconds
						$avgClientLogOnDuration = Calc-Avg -Duration $Perhour.ClientLogOnDuration -Count $Perhour.TotalCount -ToSeconds
				
						$PerHourLoginDurationReportObject.Add([PSCustomObject]@{
								CollectDate               = Check-Variable -VariableName $CollectDate
								Hour                      = Check-Variable -VariableName $Hour
								DesktopGroupName          = Check-Variable -VariableName $DesktopGroupName
								TotalHourLogins           = Check-Variable -VariableName $TotalHourLogins
								AvgBrokeringDuration      = Check-Variable -VariableName $AvgBrokeringDuration
								AvgVMPowerOnDuration      = Check-Variable -VariableName $avgVMPowerOnDuration
								AvgVMRegistrationDuration = Check-Variable -VariableName $avgVMRegistrationDuration
								AvgAuthenticationDuration = Check-Variable -VariableName $avgAuthenticationDuration
								AvgGpoDuration            = Check-Variable -VariableName $avgGpoDuration
								AvgLogOnScriptsDuration   = Check-Variable -VariableName $avgLogOnScriptsDuration
								AvgInteractiveDuration    = Check-Variable -VariableName $avgInteractiveDuration
								AvgProfileLoadDuration    = Check-Variable -VariableName $avgProfileLoadDuration
								AvgClientLogOnDuration    = Check-Variable -VariableName $avgClientLogOnDuration
							}) #PSList
					} catch {
						Write-Warning "[HourlyReport] Message: $($_.Exception.Message)"
						Write-Warning "[HourlyReport] Script ScriptLineNumber: $($_.InvocationInfo.ScriptLineNumber)"
						Write-Warning "[HourlyReport] Script Line: $($_.InvocationInfo.Line)"
						Write-Warning "[HourlyReport] Script BoundParameters: $($_.InvocationInfo.BoundParameters | Out-String)"
					}
				}

				
				$DesktopGroupName = $DesktopGroup.Name
				$TotalDuration = [math]::Round(($login.Group | Measure-Object -Property TotalDuration -Sum).Sum / 1000)
				$TotalCount = ($login.Group | Measure-Object -Property TotalCount -Sum).Sum
				$BrokeringDuration = [math]::Round(($login.Group | Measure-Object -Property BrokeringDuration -Sum).Sum / 1000)
				$VMPowerOnDuration = [math]::Round(($login.Group | Measure-Object -Property VMPowerOnDuration -Sum).Sum / 1000)
				$VMRegistrationDuration = [math]::Round(($login.Group | Measure-Object -Property VMRegistrationDuration -Sum).Sum / 1000)
				$AuthenticationDuration = [math]::Round(($login.Group | Measure-Object -Property AuthenticationDuration -Sum).Sum / 1000)
				$GpoDuration = [math]::Round(($login.Group | Measure-Object -Property GpoDuration -Sum).Sum / 1000)
				$InteractiveDuration = [math]::Round(($login.Group | Measure-Object -Property InteractiveDuration -Sum).Sum / 1000)
				$ProfileLoadDuration = [math]::Round(($login.Group | Measure-Object -Property ProfileLoadDuration -Sum).Sum / 1000)
				$ClientLogOnDuration = [math]::Round(($login.Group | Measure-Object -Property ClientLogOnDuration -Sum).Sum / 1000)
				$StartSumDate = Convert-UTCtoLocal $login.Group.SummaryDate[0]
				$EndSumDate = Convert-UTCtoLocal $login.Group.SummaryDate[-1]

				$TotalLoginDurationReportObject.Add(
					[PSCustomObject]@{
						DesktopGroupName       = Check-Variable -VariableName $DesktopGroupName
						TotalDuration          = Check-Variable -VariableName $TotalDuration
						TotalCount             = Check-Variable -VariableName $TotalCount
						BrokeringDuration      = Check-Variable -VariableName $BrokeringDuration
						VMPowerOnDuration      = Check-Variable -VariableName $VMPowerOnDuration
						VMRegistrationDuration = Check-Variable -VariableName $VMRegistrationDuration
						AuthenticationDuration = Check-Variable -VariableName $AuthenticationDuration
						GpoDuration            = Check-Variable -VariableName $GpoDuration
						InteractiveDuration    = Check-Variable -VariableName $InteractiveDuration
						ProfileLoadDuration    = Check-Variable -VariableName $ProfileLoadDuration
						ClientLogOnDuration    = Check-Variable -VariableName $ClientLogOnDuration
						StartSumDate           = Check-Variable -VariableName $StartSumDate
						EndSumDate             = Check-Variable -VariableName $EndSumDate
						DataCollectionPoints   = Check-Variable -VariableName $login.Group.Count
					})
			} catch {
				Write-Warning "Error processing session metrics.- name: $($login.Name)"
				Write-Warning "Message: $($_.Exception.Message)"
				Write-Warning "Script ScriptLineNumber: $($_.InvocationInfo.ScriptLineNumber)"
				Write-Warning "Script Line: $($_.InvocationInfo.Line)"
				Write-Warning "Script BoundParameters: $($_.InvocationInfo.BoundParameters | Out-String)"
			}
		}
	}

	$ReturnObject = [pscustomobject]@{}
	if ($null -ne $ConnectionFailureReportObject) { $ReturnObject | Add-Member -NotePropertyName 'ConnectionFailureReport' -NotePropertyValue $ConnectionFailureReportObject }
	if ($null -ne $MachineFailureReportObject) { $ReturnObject | Add-Member -NotePropertyName 'MachineFailureReport' -NotePropertyValue $MachineFailureReportObject }
	if ($null -ne $SessionReportObject) { $ReturnObject | Add-Member -NotePropertyName 'SessionReport' -NotePropertyValue $SessionReportObject }
	if ($null -ne $MachineReportObject) { $ReturnObject | Add-Member -NotePropertyName 'MachineReport' -NotePropertyValue $MachineReportObject }
	if ($null -ne $PerHourLoginDurationReportObject) { $ReturnObject | Add-Member -NotePropertyName 'PerHourLoginDurationReport' -NotePropertyValue $PerHourLoginDurationReportObject }
	if ($null -ne $TotalLoginDurationReportObject) { $ReturnObject | Add-Member -NotePropertyName 'TotalLoginDurationReport' -NotePropertyValue $TotalLoginDurationReportObject }


	if ($PSBoundParameters.ContainsKey('Export') -and $Export -contains 'Host') {
		Write-Verbose 'Returning report object to host.'
		return $ReturnObject
	}
	
	if ($PSBoundParameters.ContainsKey('Export') -and $Export -contains 'Excel') {
		Write-Verbose "[$(Get-Date -Format HH:mm:ss) ExcelExport] "
		$ReportFilename = "Citrix_Report-$($APIHeader.CustomerName)-" + (Get-Date -Format yyyy.MM.dd-HH.mm) + '.xlsx'
		[string]$ExcelReportname = Join-Path -Path $ReportPath -ChildPath $ReportFilename
		$ExcelOptions = @{
			Path             = $ExcelReportname
			AutoSize         = $True
			AutoFilter       = $True
			TitleBold        = $True
			TitleSize        = '28'
			TitleFillPattern = 'LightTrellis'
			TableStyle       = 'Light20'
			FreezeTopRow     = $True
			FreezePane       = '3'
		}
		Write-Verbose ('Exporting to Excel: {0}' -f $ExcelOptions.Path)
		if ($ReturnObject.psobject.properties.name -contains 'ConnectionFailureReport') { 
			Write-Verbose ('Exporting ConnectionFailureReport with {0} rows' -f $ReturnObject.ConnectionFailureReport.Count)
			$ReturnObject.ConnectionFailureReport | Export-Excel -Title 'Connection Failure Report' -WorksheetName 'ConnectionFailure' @ExcelOptions
		}
		if ($ReturnObject.psobject.properties.name -contains 'MachineFailureReport') { 
			Write-Verbose ('Exporting MachineFailureReport with {0} rows' -f $ReturnObject.MachineFailureReport.Count)
			$ReturnObject.MachineFailureReport | Export-Excel -Title 'Machine Failure Report' -WorksheetName 'MachineFailure' @ExcelOptions
		}
		if ($ReturnObject.psobject.properties.name -contains 'SessionReport') { 
			Write-Verbose ('Exporting SessionReport with {0} rows' -f $ReturnObject.SessionReport.Count)
			$ReturnObject.SessionReport | Export-Excel -Title 'Session Report' -WorksheetName 'Session' @ExcelOptions
		}
		if ($ReturnObject.psobject.properties.name -contains 'MachineReport') { 
			Write-Verbose ('Exporting MachineReport with {0} rows' -f $ReturnObject.MachineReport.Count)
			$ReturnObject.MachineReport | Export-Excel -Title 'Machine Report' -WorksheetName 'Machine' @ExcelOptions
		}
		if ($ReturnObject.psobject.properties.name -contains 'PerHourLoginDurationReport') { 
			Write-Verbose ('Exporting PerHourLoginDurationReport with {0} rows' -f $ReturnObject.PerHourLoginDurationReport.Count)
			$ReturnObject.PerHourLoginDurationReport | Export-Excel -Title 'Per Hour Login Duration Report' -WorksheetName 'PerHourLoginDuration' @ExcelOptions
		}
		if ($ReturnObject.psobject.properties.name -contains 'TotalLoginDurationReport') { 
			Write-Verbose ('Exporting TotalLoginDurationReport with {0} rows' -f $ReturnObject.TotalLoginDurationReport.Count)
			$ReturnObject.TotalLoginDurationReport | Export-Excel -Title 'Total Login Duration Report' -WorksheetName 'TotalLoginDuration' @ExcelOptions
		}
	}

	if ($PSBoundParameters.ContainsKey('Export') -and $Export -contains 'HTML') {
		if ($null -eq $ReportPath) {
			Write-Warning 'HTML export failed. ReportPath is null or empty. Please specify a valid path using -ReportPath.'
			return
		}
		try {
			Write-Verbose "[$(Get-Date -Format HH:mm:ss) HTMLExport] "
			$HeadingText = "$($APIHeader.CustomerName) Citrix Report - Generated on $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
			$ReportFilename = "Citrix_Report-$($APIHeader.CustomerName)-" + (Get-Date -Format yyyy.MM.dd-HH.mm) + '.html'
			[System.IO.FileInfo]$HTMLReportname = Join-Path -Path $ReportPath -ChildPath $ReportFilename
			New-HTML -TitleText "$($APIHeader.CustomerName) Citrix Report" -FilePath $HTMLReportname.fullname -ShowHTML {
				New-HTMLHeading -Heading h1 -HeadingText $HeadingText -Color Black
				if ($ReturnObject.psobject.properties.name -contains 'ConnectionFailureReport') {
					New-HTMLSection @SectionSettings -Content {
						New-HTMLSection -HeaderText 'Connection Failures Report' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $ReturnObject.ConnectionFailureReport }
					}
				}
				if ($ReturnObject.psobject.properties.name -contains 'MachineFailureReport') {
					New-HTMLSection @SectionSettings -Content {
						New-HTMLSection -HeaderText 'Machine Failures Report' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $ReturnObject.MachineFailureReport }
					}
				}
				if ($ReturnObject.psobject.properties.name -contains 'MachineReport') {
					New-HTMLSection @SectionSettings -Content {
						New-HTMLSection -HeaderText 'Machine Report' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $ReturnObject.MachineReport }
					}
				}
				if ($ReturnObject.psobject.properties.name -contains 'SessionReport') {
					New-HTMLSection @SectionSettings -Content {
						New-HTMLSection -HeaderText 'Session Report' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $ReturnObject.SessionReport }
					}
				}
				if ($ReturnObject.psobject.properties.name -contains 'PerHourLoginDurationReport') {
					New-HTMLSection @SectionSettings -Content {
						New-HTMLSection -HeaderText 'Per Hour Login Duration Report' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $ReturnObject.PerHourLoginDurationReport }
					}
				}
				if ($ReturnObject.psobject.properties.name -contains 'TotalLoginDurationReport') {
					New-HTMLSection @SectionSettings -Content {
						New-HTMLSection -HeaderText 'Total Login Duration Report' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $ReturnObject.TotalLoginDurationReport }
					}
				}
			}
			Write-Verbose ('HTML report generated at: {0}' -f $HTMLReportname.fullname)
		} catch { Write-Warning "HTML export failed. $($_)" }
	}
	Write-Verbose "[$(Get-Date -Format HH:mm:ss) Function] - Complete"
} #end Function
