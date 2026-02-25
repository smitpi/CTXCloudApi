
<#PSScriptInfo

.VERSION 0.1.0

.GUID 208b6ee0-ecf1-44f3-a04e-ee2cbc2f3117

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
Created [23/02/2026_06:21] Initial Script

.PRIVATEDATA

#>

<# 

.DESCRIPTION 
 Creates various Citrix Cloud monitoring reports from the monitor data or live API.

#> 


<#
.SYNOPSIS
Generate Citrix Cloud monitoring reports in multiple formats (Host, Excel, HTML).

.DESCRIPTION
New-CTXAPI_Report generates detailed Citrix Cloud monitoring reports, including resource utilization, connection activity, connection failures, session reports, and machine failures. The function can output reports to the host, export to Excel, or create a styled HTML report with embedded branding. Data can be sourced from a provided MonitorData object or fetched live via API.

.PARAMETER APIHeader
The authentication header object for Citrix Cloud API requests. Required for all operations.

.PARAMETER MonitorData
Optional. Pre-fetched monitoring data object. If not provided, the function retrieves data using Get-CTXAPI_MonitorData.

.PARAMETER LastHours
Optional. Number of hours of historical data to include (default: 24). Used only if MonitorData is not provided.

.PARAMETER ReportType
Specifies which report(s) to generate. Valid values: ConnectionFailureReport, MachineFailureReport, SessionReport, MachineReport, All.

.PARAMETER Export
Specifies the output format. Valid values: Host (default), Excel, HTML.

.PARAMETER ReportPath
Directory path for exported reports (Excel/HTML). Defaults to $env:TEMP. Must exist.

.EXAMPLE
New-CTXAPI_Report -APIHeader $header -ReportType All -Export HTML -ReportPath C:\Reports
Generates all available reports and exports them as a styled HTML file to C:\Reports.

#>
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
		[ValidateSet('ConnectionFailureReport', 'MachineFailureReport', 'SessionReport', 'MachineReport', 'All')]
		[string[]]$ReportType,
		[Parameter(Mandatory = $false)]
		[ValidateSet('Host', 'Excel', 'HTML')]
		[string]$Export = 'Host',
		[Parameter(Mandatory = $false)]
		[ValidateScript( { (Test-Path $_) })]
		[System.IO.DirectoryInfo]$ReportPath = $env:temp
	)

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
			
				$user = $user.Upn
				$DnsName = $mashine.DnsName
				$FailureDate = $session.FailureDate
				$ConnectionFailure = $script:SessionFailureCode[[int]$log.ConnectionFailureEnumValue]
				$IsInMaintenanceMode = $log.IsInMaintenanceMode
				$PowerState = $script:PowerStateCode[[int]$log.PowerState]
				$RegistrationState = $script:RegistrationState[[int]$log.RegistrationState]
				$FailureId = $script:ConnectionFailureType[[int]$session.FailureId]
				$ConnectionState = $script:ConnectionState[[int]$session.ConnectionState]
				$LifecycleState = $script:LifecycleState[[int]$session.LifecycleState]
				$SessionType = $script:SessionType[[int]$session.SessionType]
				$ConnectionFailureReportObject.Add([PSCustomObject]@{
						User                       = Check-Variable -VariableName $user
						DnsName                    = Check-Variable -VariableName $DnsName
						FailureDate                = Check-Variable -VariableName $FailureDate
						ConnectionFailureEnumValue = Check-Variable -VariableName $ConnectionFailure
						IsInMaintenanceMode        = Check-Variable -VariableName $IsInMaintenanceMode
						PowerState                 = Check-Variable -VariableName $PowerState
						RegistrationState          = Check-Variable -VariableName $RegistrationState
						FailureId                  = Check-Variable -VariableName $FailureId
						ConnectionState            = Check-Variable -VariableName $ConnectionState
						LifecycleState             = Check-Variable -VariableName $LifecycleState
						SessionType                = Check-Variable -VariableName $SessionType
					})
			} catch {
				Write-Warning "Error processing session metrics.- SessionKey: $($session.SessionKey)"
				Write-Warning "Message: $($_.Exception.Message)"
				Write-Warning "Script Line: $($_.InvocationInfo.ScriptLineNumber)"
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
				$MonDataMachine = $monitordata.machines | Where-Object { $_.id -like $log.MachineId }
				$MachinesFiltered = $machines | Where-Object {$_.Name -like $MonDataMachine.Name }

				$DnsName = $MonDataMachine.DnsName
				$AssociatedUserNames = $MonDataMachine.AssociatedUserNames
				$OSType = $MonDataMachine.OSType
				$IsAssigned = $MonDataMachine.IsAssigned
				$FailureStartDate = $log.FailureStartDate
				$FailureEndDate = $log.FailureEndDate
				$FaultState = $MachineFaultStateCode.($log.FaultState)
				$LastDeregistrationReason = $MachineDeregistration.($MachinesFiltered.LastDeregisteredCode)
				$LastDeregisteredDate = $MonDataMachine.LastDeregisteredDate
				$LastPowerActionCompletedDate = $MonDataMachine.LastPowerActionCompletedDate
				$LastPowerActionFailureReason = $MachineDeregistration.($MonDataMachine.LastPowerActionFailureReason)
				$CurrentFaultState = $MachineFaultStateCode.($MachinesFiltered.FaultState)
				$IsInMaintenanceMode = $MachinesFiltered.IsInMaintenanceMode
				$RegistrationState = $RegistrationState.($MachinesFiltered.CurrentRegistrationState)

				$MachineFailureReportObject.Add([PSCustomObject]@{
						Name                         = Check-Variable -VariableName $DnsName
						AssociatedUserUPNs           = Check-Variable -VariableName $AssociatedUserNames
						OSType                       = Check-Variable -VariableName $OSType
						IsAssigned                   = Check-Variable -VariableName $IsAssigned
						FailureStartDate             = Check-Variable -VariableName $FailureStartDate
						FailureEndDate               = Check-Variable -VariableName $FailureEndDate
						FaultState                   = Check-Variable -VariableName $FaultState
						LastDeregistrationReason     = Check-Variable -VariableName $LastDeregistrationReason
						LastDeregisteredDate         = Check-Variable -VariableName $LastDeregisteredDate
						LastPowerActionCompletedDate = Check-Variable -VariableName $LastPowerActionCompletedDate
						LastPowerActionFailureReason = Check-Variable -VariableName $LastPowerActionFailureReason
						CurrentFaultState            = Check-Variable -VariableName $CurrentFaultState
						InMaintenanceMode            = Check-Variable -VariableName $IsInMaintenanceMode
						RegistrationState            = Check-Variable -VariableName $RegistrationState
					})
			} catch {
				Write-Warning "Error processing session metrics.- SessionKey: $($session.SessionKey)"
				Write-Warning "Message: $($_.Exception.Message)"
				Write-Warning "Script Line: $($_.InvocationInfo.ScriptLineNumber)"
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
				
				$FilterConnect = $ColGroup | Where-Object { $_.Name -like $session.SessionKey } 
				[System.Collections.generic.List[PSObject]]$Connections = @()
				$FilterConnect.Group | ForEach-Object { $Connections.Add($_) }
				Write-Verbose "[$(Get-Date -Format HH:mm:ss)] [Connections] $($FilterConnect.Count) connections found for session $($session.SessionKey)"

				$FilterMetrics = $AllsessionMetrics | Where-Object { $_.Name -like $session.SessionKey } 
				[System.Collections.generic.List[PSObject]]$SessionMetrics = @()
				$FilterMetrics.Group | ForEach-Object { $SessionMetrics.Add($_) }
				Write-Verbose "[$(Get-Date -Format HH:mm:ss)] [Metrics] $($FilterMetrics.Count) metrics found for session $($session.SessionKey)"

				$MachineName = $machine.Name
				$User = $user.Upn
				$ConnectionState = $ConnectionState.($session.ConnectionState)
				$IsReconnect = $Connections[-1].IsReconnect
				$LogOnDuration = $session.LogOnDuration
				$ClientLogOnDuration = $session.ClientLogOnDuration
				$AuthenticationDuration = ($Connections.AuthenticationDuration | Measure-Object -Sum).Sum
				$BrokeringDuration = ($Connections.BrokeringDuration | Measure-Object -Sum).Sum

				$IcaLatency = [math]::Round(($SessionMetrics.icaLatency | Measure-Object -Average).Average)	
				$IcaRttMS = [math]::Round(($SessionMetrics.icaRttMS | Measure-Object -Average).Average)

				$WorkspaceType = $WorkspaceType.(($Connections[-1].WorkspaceType))
				$ClientLocationCountry = $Connections[-1].ClientLocationCountry
				$ClientPlatform = $Connections[-1].ClientPlatform
				$FailureId = $SessionFailureCode.($session.FailureId)
				$FailureDate = $session.FailureDate
				$SessionStartTime = $session.StartDate
				$SessionEndTime = $session.EndDate
			} catch {
				Write-Warning "Error processing session metrics.- SessionKey: $($session.SessionKey)"
				Write-Warning "Message: $($_.Exception.Message)"
				Write-Warning "Script Line: $($_.InvocationInfo.ScriptLineNumber)"
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
				Write-Verbose "[$(Get-Date -Format HH:mm:ss) MachineReport] `t`t ResourceUtilizationSummary - $($resourceUtilization.count)"
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
				$FaultState = $MachineFaultStateCode.($machine.FaultState)
				$CurrentSessionCount = $machine.CurrentSessionCount
				$CurrentPowerState = $PowerStateCode.($machine.CurrentPowerState)
				$CurrentRegistrationState = $RegistrationState.($machine.CurrentRegistrationState)
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
				Write-Warning "Error processing session metrics.- SessionKey: $($machine.id)"
				Write-Warning "Message: $($_.Exception.Message)"
				Write-Warning "Script Line: $($_.InvocationInfo.ScriptLineNumber)"
			}
		}
		Write-Verbose "[$(Get-Date -Format HH:mm:ss) MachineReport] - Complete"
	}

	$ReturnObject = [pscustomobject]@{}
	if ($null -ne $ConnectionFailureReportObject) { $ReturnObject | Add-Member -NotePropertyName 'ConnectionFailureReport' -NotePropertyValue $ConnectionFailureReportObject }
	if ($null -ne $MachineFailureReportObject) { $ReturnObject | Add-Member -NotePropertyName 'MachineFailureReport' -NotePropertyValue $MachineFailureReportObject }
	if ($null -ne $SessionReportObject) { $ReturnObject | Add-Member -NotePropertyName 'SessionReport' -NotePropertyValue $SessionReportObject }
	if ($null -ne $MachineReportObject) { $ReturnObject | Add-Member -NotePropertyName 'MachineReport' -NotePropertyValue $MachineReportObject }

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
			}
			Write-Verbose ('HTML report generated at: {0}' -f $HTMLReportname.fullname)
		} catch { Write-Warning "HTML export failed. $($_)" }
	}
	Write-Verbose "[$(Get-Date -Format HH:mm:ss) Function] - Complete"
} #end Function




# 	[System.Collections.generic.List[PSObject]]$SessionReportObject = @()
# 	$AllSessions = $monitordata.sessions
# 	$AllsessionMetrics = $monitordata.SessionMetrics | Group-Object -Property SessionId
# 	$ColGroup = $monitordata.connections | Group-Object -Property SessionKey
# 	foreach ($session in $AllSessions) {
# 		Write-Verbose "[$(Get-Date -Format HH:mm:ss) SessionReport] $($AllSessions.IndexOf($session) + 1) of $($AllSessions.Count) - SessionKey: $($session.SessionKey)"
# 		[System.Collections.generic.List[PSObject]]$connections = @()
# 		$ColGroup | Where-Object { $_.Name -like $session.SessionKey } | ForEach-Object { $connections.Add($_.Group) }
# 		Write-Verbose "[$(Get-Date -Format HH:mm:ss) SessionReport] `t`t connections - $($connections.Count)"
# 		try {
# 			if (-not [string]::IsNullOrEmpty($connections)) {
# 				if ($connections.count -gt 1) {
# 					$LastConnection = $connections[-1]
# 					$connections = $connections
# 				} else {
# 					$LastConnection = $connections[0]
# 					$connections = $connections
# 				}
# 				# if ($null -ne $LastConnection.WorkspaceType) {
# 				# 	$WorkspaceType = $WorkspaceType.($LastConnection.WorkspaceType)
# 				# } else {
# 				# 	$WorkspaceType = $null
# 				# }
# 				try {
# 					$AuthenticationDuration = $LastConnection.AuthenticationDuration
# 					$BrokeringDuration = $LastConnection.BrokeringDuration
# 					#$AuthenticationDuration = [math]::Round(($connections.AuthenticationDuration | Measure-Object -Sum -ErrorAction SilentlyContinue).Sum / 1000) 
# 					#$BrokeringDuration = [math]::Round(($connections.BrokeringDuration | Measure-Object -Sum -ErrorAction SilentlyContinue).Sum / 1000)
# 				} catch { 
# 					Write-Warning "Error calculating AuthenticationDuration or BrokeringDuration - Message: $($_.Exception.Message)"
# 					$AuthenticationDuration = $null
# 					$BrokeringDuration = $null
# 				}
# 				$IsReconnect = if ($null -ne $LastConnection.IsReconnect) { $LastConnection.IsReconnect } else { $null }
# 				$ClientLocationCountry = $LastConnection.ClientLocationCountry
# 				$ClientPlatform = $LastConnection.ClientPlatform
# 			} else {
# 				$WorkspaceType = $null
# 				$AuthenticationDuration = $null
# 				$BrokeringDuration = $null
# 				$IsReconnect = $null
# 				$ClientLocationCountry = $null
# 				$ClientPlatform = $null
# 				$LastConnection = $null
# 				$connections = $null
# 			}
# 		} catch {
# 			Write-Warning "Error processing session connections.- SessionKey: $($session.SessionKey)"
# 			Write-Warning "Message: $($_.Exception.Message)"
# 			Write-Warning "Script Line: $($_.InvocationInfo.ScriptLineNumber)"
# 		} # `n`n$($connections | Out-String)
# 		try {
# 			[System.Collections.generic.List[PSObject]]$sessionmetrics = @()
# 			$AllsessionMetrics | Where-Object { $_.Name -like $session.SessionKey } | ForEach-Object { $sessionmetrics.Add($_.Group) }
# 			Write-Verbose "[$(Get-Date -Format HH:mm:ss) SessionReport] `t`t Sessionmetrics - $($sessionmetrics.Count)"
# 			$IcaRttMS = $sessionmetrics | Measure-Object -Property IcaRttMS -Average -ErrorAction SilentlyContinue
# 			$IcaLatency = $sessionmetrics | Measure-Object -Property IcaLatency -Average -ErrorAction SilentlyContinue
# 			#$IcaRttMS = if ($sessionmetrics.IcaRttMS) { ($sessionmetrics.IcaRttMS | Measure-Object -Average).Average } else { $null }
# 			#$IcaLatency = if ($sessionmetrics.IcaLatency) { ($sessionmetrics.IcaLatency | Measure-Object -Average).Average } else { $null }
# 		} catch { 
# 			Write-Warning "Error processing session metrics.- SessionKey: $($session.SessionKey)"
# 			Write-Warning "Message: $($_.Exception.Message)"
# 			Write-Warning "Script Line: $($_.InvocationInfo.ScriptLineNumber)"$user.Upn
# 			Write-Warning "metricscount: $($sessionmetrics.count | Out-String)"

# 		}	
# 		$machine = $monitordata.machines | Where-Object { $_.Id -like $session.MachineId }
# 		$user = $monitordata.users | Where-Object { $_.Id -like $session.UserId }
# 		if (-not [string]::IsNullOrEmpty($session.LogOnDuration)) {
# 			$LogOnDuration = [math]::Round($session.LogOnDuration / 1000)
# 		} else {
# 			$LogOnDuration = $null
# 		}
# 		if (-not [string]::IsNullOrEmpty($session.ClientLogOnDuration)) {
# 			$ClientLogOnDuration = [math]::Round($session.ClientLogOnDuration / 1000)
# 		} else {
# 			$ClientLogOnDuration = $null
# 		}
# 		Write-Verbose "[$(Get-Date -Format HH:mm:ss) SessionReport] Adding to object"
# 		$SessionReportObject.Add([PSCustomObject]@{
# 				MachineName            = Check-Variable -VariableName $machine.Name
# 				UserName               = Check-Variable -VariableName $user.Upn -ErrorAction SilentlyContinue
# 				ConnectionState        = Check-Variable -VariableName $ConnectionState.($session.ConnectionState)
# 				#IsReconnect            = Check-Variable -VariableName $IsReconnect
# 				LogOnDuration          = Check-Variable -VariableName $LogOnDuration
# 				ClientLogOnDuration    = Check-Variable -VariableName $ClientLogOnDuration
# 				AuthenticationDuration = Check-Variable -VariableName $AuthenticationDuration
# 				BrokeringDuration      = Check-Variable -VariableName $BrokeringDuration
# 				IcaRttMS               = Check-Variable -VariableName $IcaRttMS
# 				IcaLatency             = Check-Variable -VariableName $IcaLatency
# 				#WorkspaceType          = Check-Variable -VariableName $WorkspaceType
# 				ClientLocationCountry  = Check-Variable -VariableName $ClientLocationCountry
# 				ClientPlatform         = Check-Variable -VariableName $ClientPlatform
# 				FailureId              = Check-Variable -VariableName $SessionFailureCode.($session.FailureId)
# 				FailureDate            = Check-Variable -VariableName $session.FailureDate
# 				SessionStartTime       = Check-Variable -VariableName $session.StartDate
# 				SessionEndTime         = Check-Variable -VariableName $session.EndDate
# 			}) #PSList
# 		Write-Verbose "[$(Get-Date -Format HH:mm:ss) SessionReport] Object added`n`n`n"
# 	}
# 	Write-Verbose "[$(Get-Date -Format HH:mm:ss) SessionReport] - Complete"
# }
