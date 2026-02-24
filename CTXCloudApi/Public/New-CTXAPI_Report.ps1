
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
Specifies which report(s) to generate. Valid values: ConnectionReport, ResourceUtilization, ConnectionFailureReport, MachineFailureReport, SessionReport, MachineReport, All.

.PARAMETER Export
Specifies the output format. Valid values: Host (default), Excel, HTML.

.PARAMETER ReportPath
Directory path for exported reports (Excel/HTML). Defaults to $env:TEMP. Must exist.

.EXAMPLE
New-CTXAPI_Report -APIHeader $header -ReportType All -Export HTML -ReportPath C:\Reports
Generates all available reports and exports them as a styled HTML file to C:\Reports.

.EXAMPLE
New-CTXAPI_Report -APIHeader $header -ReportType ResourceUtilization -Export Excel
Exports only the resource utilization report to Excel in the default temp directory.

.EXAMPLE
New-CTXAPI_Report -APIHeader $header -MonitorData $data -ReportType ConnectionReport
Outputs the connection report to the host using pre-fetched monitoring data.

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
		[ValidateSet('ConnectionReport', 'ResourceUtilization', 'ConnectionFailureReport', 'MachineFailureReport', 'SessionReport', 'MachineReport', 'All')]
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

	$ResourceUtilizationObject = $null
	$ConnectionReportObject = $null
	$ConnectionFailureReportObject = $null
	$MachineFailureReportObject = $null
	$SessionReportObject = $null
	$MachineReportObject = $null

	if (($PSBoundParameters['ReportType'] -contains 'ResourceUtilization') -or ($PSBoundParameters['ReportType'] -contains 'All')) {
		[System.Collections.generic.List[PSObject]]$ResourceUtilizationObject = @()
		$InGroups = $monitordata.ResourceUtilization | Group-Object -Property MachineId
		foreach ($machine in $InGroups) {
			Write-Verbose "[$(Get-Date -Format HH:mm:ss) ResourceUtilization] $($InGroups.IndexOf($($machine)) + 1) of $($InGroups.Count)"		
			$MachineDetails = $monitordata.Machines | Where-Object {$_.id -like $machine.Name}
			$catalog = $monitordata.Catalogs | Where-Object { $_.id -eq $MachineDetails.CatalogId } | ForEach-Object { $_.name }
			$desktopgroup = $monitordata.DesktopGroups | Where-Object { $_.id -eq $MachineDetails.DesktopGroupId } | ForEach-Object { $_.name }
			try {
				Write-Verbose "[$(Get-Date -Format HH:mm:ss) ResourceUtilization] `t`t`t ResourceUtilization - $($machine.Group.Count)"
				$AVGPercentCpu = [math]::Round(($machine.Group | Measure-Object -Property PercentCpu -Average).Average)
				$AVGUsedMemory = [math]::Ceiling((($machine.Group | Measure-Object -Property UsedMemory -Average).Average) / 1gb)
				$AVGSessionCount = [math]::Ceiling(($machine.Group | Measure-Object -Property SessionCount -Average).Average)
				$AVGTotalMemory = [math]::Round($machine.Group[0].TotalMemory / 1gb)
				$StartCollection = $machine.Group.CollectedDate | Sort-Object | Select-Object -First 1
				$EndCollection = $machine.Group.CollectedDate | Sort-Object -Descending | Select-Object -First 1
				$timespan = New-TimeSpan -Start $StartCollection -End $EndCollection
				Write-Verbose "[$(Get-Date -Format HH:mm:ss) ResourceUtilization] Adding to object"
			} catch {Write-Warning "Error: `n`tMessage:$($_.Exception.Message)"}
			$ResourceUtilizationObject.Add([PSCustomObject]@{
					AssociatedUserNames      = $MachineDetails.AssociatedUserNames
					DnsName                  = $MachineDetails.DnsName
					IsInMaintenanceMode      = $MachineDetails.IsInMaintenanceMode
					AgentVersion             = $MachineDetails.AgentVersion
					CurrentRegistrationState = $RegistrationState.($MachineDetails.CurrentRegistrationState)
					OSType                   = $MachineDetails.OSType
					Catalog                  = $catalog
					DesktopGroup             = $desktopgroup
					Datametric               = $machine.Count
					AVGPercentCpu            = $AVGPercentCpu
					AVGUsedMemory            = $AVGUsedMemory
					AVGTotalMemory           = $AVGTotalMemory
					AVGSessionCount          = $AVGSessionCount
					StartCollection          = if ($null -eq $StartCollection) { $null } else { Convert-UTCtoLocal -Time $StartCollection }
					EndCollection            = if ($null -eq $EndCollection) { $null } else { Convert-UTCtoLocal -Time $EndCollection }
					CollectionDuration       = if ($null -eq $timespan) { $null } else { $timespan }
				})
		}
		Write-Verbose "[$(Get-Date -Format HH:mm:ss) ResourceUtilization] - Complete"
	}

	if (($PSBoundParameters['ReportType'] -contains 'ConnectionReport') -or ($PSBoundParameters['ReportType'] -contains 'All')) {
		[System.Collections.generic.List[PSObject]]$ConnectionReportObject = @()
		$allConnections = $monitordata.Connections
		$AllSessionMetrics = $monitordata.SessionMetrics | Group-Object -Property SessionId
		foreach ($connection in $allConnections) {
			Write-Verbose "[$(Get-Date -Format HH:mm:ss) ConnectionReport] $($allConnections.IndexOf($connection) + 1) of $($allConnections.Count)"
			try {
				$OneSession = $monitordata.Sessions | Where-Object { $_.SessionKey -eq $connection.SessionKey }
				$user = $monitordata.Users | Where-Object { $_.id -like $OneSession.UserId }
				$mashine = $monitordata.Machines | Where-Object { $_.id -like $OneSession.MachineId }
				try {
					$avgrtt = 0
					$ctxlatency = 0
					$sessdata = $AllSessionMetrics | Where-Object { $_.Name -like $OneSession.SessionKey } | Select-Object -ExpandProperty Group
					Write-Verbose "[$(Get-Date -Format HH:mm:ss) ConnectionReport] `t`t sessionmetrics = $($sessdata.Count)"
					$avgrtt = $sessdata | Measure-Object -Property IcaRttMS -Average
					$ctxlatency = $sessdata | Measure-Object -Property IcaLatency -Average
					$StartCollection = $sessdata.CollectedDate | Sort-Object | Select-Object -First 1
					$EndCollection = $sessdata.CollectedDate | Sort-Object -Descending | Select-Object -First 1
					$timespan = New-TimeSpan -Start $StartCollection -End $EndCollection
				} catch { Write-Warning "Not enough RTT data - $_.Exception.Message" }
			} catch { Write-Warning "Error processing - $_.Exception.Message" }
			$ConnectionReportObject.Add([PSCustomObject]@{
					User                     = $user.upn
					DnsName                  = $mashine.DnsName
					ConnectionState          = $ConnectionState.($OneSession.ConnectionState)
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
					EstablishmentDate        = if ($null -eq $connection.EstablishmentDate) { $null } else { Convert-UTCtoLocal -Time $connection.EstablishmentDate }
					LogOnStartDate           = if ($null -eq $connection.LogOnStartDate) { $null } else { Convert-UTCtoLocal -Time $connection.LogOnStartDate }
					LogOnEndDate             = if ($null -eq $connection.LogOnEndDate) { $null } else { Convert-UTCtoLocal -Time $connection.LogOnEndDate }
					AuthenticationDuration   = $connection.AuthenticationDuration
					LogOnDuration            = $OneSession.LogOnDuration
					DisconnectDate           = if ($null -eq $connection.DisconnectDate) { $null } else { Convert-UTCtoLocal -Time $connection.DisconnectDate }
					EndDate                  = if ($null -eq $OneSession.EndDate) { $null } else { Convert-UTCtoLocal -Time $OneSession.EndDate }
					ExitCode                 = $SessionFailureCode.($OneSession.ExitCode)
					FailureDate              = if ($null -eq $OneSession.FailureDate) { $null } else { Convert-UTCtoLocal -Time $OneSession.FailureDate }
					MetricsCounted           = if ($null -eq $sessdata) { 0 } else { $sessdata.Count }
					AVG_ICA_RTT              = if ($null -eq $avgrtt) { 0 } else { [math]::Round($avgrtt.Average) }
					AVG_ICA_Latency          = if ($null -eq $ctxlatency) { 0 } else { [math]::Round($ctxlatency.Average) }
					StartCollection          = if ($null -eq $StartCollection) { $null } else { Convert-UTCtoLocal -Time $StartCollection }
					EndCollection            = if ($null -eq $EndCollection) { $null } else { Convert-UTCtoLocal -Time $EndCollection }
					CollectionDuration       = if ($null -eq $timespan) { $null } else { $timespan }
				}) #PSList
		}
		Write-Verbose "[$(Get-Date -Format HH:mm:ss) ConnectionReport] - Complete"
	}

	if (($PSBoundParameters['ReportType'] -contains 'ConnectionFailureReport') -or ($PSBoundParameters['ReportType'] -contains 'All')) {
		[System.Collections.generic.List[PSObject]]$ConnectionFailureReportObject = @()
		$allConnectionFailureLogs = $monitordata.ConnectionFailureLogs
		foreach ($log in $allConnectionFailureLogs) {
			Write-Verbose "[$(Get-Date -Format HH:mm:ss) ConnectionFailureReport] $($allConnectionFailureLogs.IndexOf($log) + 1) of $($allConnectionFailureLogs.Count)"
			$session = $monitordata.Sessions | Where-Object { $_.SessionKey -eq $log.SessionKey }
			Write-Verbose "[$(Get-Date -Format HH:mm:ss) ConnectionFailureReport] `t`t sessions = $($session.count)"
			$user = $monitordata.users | Where-Object { $_.id -like $Session.UserId }
			$mashine = $monitordata.machines | Where-Object { $_.id -like $Session.MachineId }
			try {
				$ConnectionFailureReportObject.Add([PSCustomObject]@{
						User                       = $user.Upn
						DnsName                    = $mashine.DnsName
						CurrentRegistrationState   = $RegistrationState.($mashine.CurrentRegistrationState)
						FailureDate                = if ($null -eq $session.FailureDate) { $null } else { Convert-UTCtoLocal -Time $session.FailureDate }
						ConnectionFailureEnumValue	= $SessionFailureCode.($log.ConnectionFailureEnumValue)
						IsInMaintenanceMode        = $log.IsInMaintenanceMode
						PowerState                 = $PowerStateCode.($log.PowerState)
						RegistrationState          = $RegistrationState.($log.RegistrationState)
						FailureId                  = $ConnectionFailureType.($session.FailureId)
						ConnectionState            = $ConnectionState.($session.ConnectionState)
						LifecycleState             = $LifecycleState.($session.LifecycleState)
						SessionType                = $SessionType.($session.SessionType)
					})
			} catch { Write-Warning "Error processing connection failure log - $_" }
		}
		Write-Verbose "[$(Get-Date -Format HH:mm:ss) ConnectionFailureReport] - Complete"
	}

	if (($PSBoundParameters['ReportType'] -contains 'MachineFailureReport') -or ($PSBoundParameters['ReportType'] -contains 'All')) {
		[System.Collections.generic.List[PSObject]]$MachineFailureReportObject = @()
		$machines = $monitordata.machines
		$AllMachineFailureLogs = $monitordata.MachineFailureLogs
		foreach ($log in $AllMachineFailureLogs) {
			Write-Verbose "[$(Get-Date -Format HH:mm:ss) MachineFailureReport] $($AllMachineFailureLogs.IndexOf($log) + 1) of $($AllMachineFailureLogs.Count)"
			$MonDataMachine = $monitordata.machines | Where-Object { $_.id -like $log.MachineId }
			$MachinesFiltered = $machines | Where-Object {$_.Name -like $MonDataMachine.Name }
			$MachineFailureReportObject.Add([PSCustomObject]@{
					Name                         = $MonDataMachine.DnsName
					AssociatedUserUPNs           = $MonDataMachine.AssociatedUserNames
					OSType                       = $MonDataMachine.OSType
					IsAssigned                   = $MonDataMachine.IsAssigned
					FailureStartDate             = if ($null -eq $log.FailureStartDate) { $null } else { Convert-UTCtoLocal -Time $log.FailureStartDate }
					FailureEndDate               = if ($null -eq $log.FailureEndDate) { $null } else { Convert-UTCtoLocal -Time $log.FailureEndDate }
					FaultState                   = $MachineFaultStateCode.($log.FaultState)
					LastDeregistrationReason     = $MachineDeregistration.($MachinesFiltered.LastDeregisteredCode)
					LastDeregisteredDate         = if ($null -eq $MonDataMachine.LastDeregisteredDate) { $null } else { Convert-UTCtoLocal -Time $MonDataMachine.LastDeregisteredDate }
					LastPowerActionCompletedDate = if ($null -eq $MonDataMachine.LastPowerActionCompletedDate) { $null } else { Convert-UTCtoLocal -Time $MonDataMachine.LastPowerActionCompletedDate }
					LastPowerActionFailureReason = $MachineDeregistration.($MonDataMachine.LastPowerActionFailureReason)
					CurrentFaultState            = $MachineFaultStateCode.($MachinesFiltered.FaultState)
					InMaintenanceMode            = $MachinesFiltered.IsInMaintenanceMode
					RegistrationState            = $RegistrationState.($MachinesFiltered.CurrentRegistrationState)
				})
		}
		Write-Verbose "[$(Get-Date -Format HH:mm:ss) MachineFailureReport] - Complete"

	}

	if (($PSBoundParameters['ReportType'] -contains 'SessionReport') -or ($PSBoundParameters['ReportType'] -contains 'All')) {
		[System.Collections.generic.List[PSObject]]$SessionReportObject = @()
		$AllSessions = $monitordata.sessions
		$AllsessionMetrics = $monitordata.SessionMetrics | Group-Object -Property SessionId
		foreach ($session in $AllSessions) {
			Write-Verbose "[$(Get-Date -Format HH:mm:ss) SessionReport] $($AllSessions.IndexOf($session) + 1) of $($AllSessions.Count)"
			$connections = $monitordata.connections | Where-Object { $_.SessionKey -like $session.SessionKey }
			Write-Verbose "[$(Get-Date -Format HH:mm:ss) SessionReport] `t`t connections - $($connections.count)"
			$sessionmetrics = $AllsessionMetrics | Where-Object { $_.Name -like $session.SessionKey }
			Write-Verbose "[$(Get-Date -Format HH:mm:ss) SessionReport] `t`t Sessionmetrics - $($sessionmetrics.Group.count)"
			$machine = $monitordata.machines | Where-Object { $_.Id -like $session.MachineId }
			$user = $monitordata.users | Where-Object { $_.Id -like $session.UserId }
			$IcaRttMS = $sessionmetrics.group | Measure-Object -Property IcaRttMS -AllStats
			$IcaLatency = $sessionmetrics.group | Measure-Object -Property IcaLatency -AllStats
			Write-Verbose "[$(Get-Date -Format HH:mm:ss) SessionReport] Adding to object"
			$SessionReportObject.Add([PSCustomObject]@{
					MachineName         = $machine.Name
					UserName            = $user.Upn
					SessionStartTime    = if ($null -eq $session.StartDate) { $null } else { Convert-UTCtoLocal -Time $session.StartDate }
					SessionEndTime      = if ($null -eq $session.EndDate) { $null } else { Convert-UTCtoLocal -Time $session.EndDate }
					LogOnDuration       = $session.LogOnDuration
					ClientLogOnDuration = $session.ClientLogOnDuration
					FailureId           = $SessionFailureCode.($session.FailureId)
					ConnectionState     = $ConnectionState.($session.ConnectionState)
					BrokeringDuration   = $connections.BrokeringDuration
					IcaRttMS            = [math]::Round($IcaRttMS.Average)
					IcaLatency          = [math]::Round($IcaLatency.Average)
				}) #PSList
			Write-Verbose "[$(Get-Date -Format HH:mm:ss) SessionReport] Object added`n`n`n"
		}
		Write-Verbose "[$(Get-Date -Format HH:mm:ss) SessionReport] - Complete"
	}

	if (($PSBoundParameters['ReportType'] -contains 'MachineReport') -or ($PSBoundParameters['ReportType'] -contains 'All')) {
		[System.Collections.generic.List[PSObject]]$MachineReportObject = @()
		$machineList = $monitordata.machines | Where-Object {$_.LifecycleState -eq 0}
		foreach ($machine in $machineList) {
			Write-Verbose "[$(Get-Date -Format HH:mm:ss) MachineReport] $($machineList.IndexOf($machine) + 1) of $($machineList.Count)"
			$resourceUtilization = $monitordata.ResourceUtilizationSummary | Where-Object { $_.MachineId -like $machine.id }
			Write-Verbose "[$(Get-Date -Format HH:mm:ss) MachineReport] `t`t ResourceUtilizationSummary - $($resourceUtilization.count)"
			$catalog = $monitordata.catalogs | Where-Object { $_.Id -like $machine.CatalogId }
			$desktopGroup = $monitordata.DesktopGroups | Where-Object { $_.Id -like $machine.DesktopGroupId }
			$AvgPercentCpu = $resourceUtilization | Measure-Object -Property AvgPercentCpu -Average
			$AvgUsedMemory = $resourceUtilization | Measure-Object -Property AvgUsedMemory -Average
			$AvgIcaRttInMs = $resourceUtilization | Measure-Object -Property AvgIcaRttInMs -Average
			$AvgLogOnDurationInMs = $resourceUtilization | Measure-Object -Property AvgLogOnDurationInMs -Average
			$UptimeInMinutes = $resourceUtilization | Measure-Object -Property UptimeInMinutes -Average
			$UpTimeWithoutSessionInMinutes = $resourceUtilization | Measure-Object -Property UpTimeWithoutSessionInMinutes -Average
			$AvgDiskLatency = $resourceUtilization | Measure-Object -Property AvgDiskLatency -Average
			Write-Verbose "[$(Get-Date -Format HH:mm:ss) MachineReport] Adding to object"
			$MachineReportObject.Add([PSCustomObject]@{
					Name                          = $machine.Name
					IsAssigned                    = $machine.IsAssigned
					IsInMaintenanceMode           = $machine.IsInMaintenanceMode
					AssociatedUserUPNs            = $machine.AssociatedUserUPNs
					CurrentRegistrationState      = $MachineDeregistration.($machine.CurrentRegistrationState)
					CurrentPowerState             = $PowerStateCode.($machine.CurrentPowerState)
					CurrentSessionCount           = $machine.CurrentSessionCount
					FaultState                    = $MachineFaultStateCode.($machine.FaultState)
					CatalogName                   = $catalog.Name
					DesktopGroupName              = $desktopGroup.Name	
					AvgPercentCpu                 = [math]::Round($AvgPercentCpu.Average)
					AvgUsedMemory                 = [math]::Round($AvgUsedMemory.Average)
					AvgIcaRttInMs                 = [math]::Round($AvgIcaRttInMs.Average)
					AvgLogOnDurationInMs          = [math]::Round($AvgLogOnDurationInMs.Average)
					UptimeInMinutes               = [math]::Round($UptimeInMinutes.Average)
					UpTimeWithoutSessionInMinutes = [math]::Round($UpTimeWithoutSessionInMinutes.Average)
					AvgDiskLatency                = [math]::Round($AvgDiskLatency.Average)
				}) #PSList
			Write-Verbose "[$(Get-Date -Format HH:mm:ss) MachineReport] Object added`n`n`n"
		}
		Write-Verbose "[$(Get-Date -Format HH:mm:ss) MachineReport] - Complete"
	}


	$ReturnObject = [pscustomobject]@{}
	if ($null -ne $ResourceUtilizationObject) { $ReturnObject | Add-Member -NotePropertyName 'ResourceUtilization' -NotePropertyValue $ResourceUtilizationObject }
	if ($null -ne $ConnectionReportObject) { $ReturnObject | Add-Member -NotePropertyName 'ConnectionReport' -NotePropertyValue $ConnectionReportObject }
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
		if ($ReturnObject.psobject.properties.name -contains 'ResourceUtilization') { 
			Write-Verbose ('Exporting ResourceUtilization with {0} rows' -f $ReturnObject.ResourceUtilization.Count)
			$ReturnObject.ResourceUtilization | Export-Excel -Title 'Resource Utilization' -WorksheetName 'ResourceUtilization' @ExcelOptions
		}
		if ($ReturnObject.psobject.properties.name -contains 'ConnectionReport') { 
			Write-Verbose ('Exporting ConnectionReport with {0} rows' -f $ReturnObject.ConnectionReport.Count)
			$ReturnObject.ConnectionReport | Export-Excel -Title 'Connection Report' -WorksheetName 'Connection' @ExcelOptions
		}
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
				if ($ReturnObject.psobject.properties.name -contains 'ResourceUtilization') {
					New-HTMLSection @SectionSettings -Content {
						New-HTMLSection -HeaderText 'Resource Utilization Report' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $ReturnObject.ResourceUtilization  }
					}
				}
				if ($ReturnObject.psobject.properties.name -contains 'ConnectionReport') {
					New-HTMLSection @SectionSettings -Content {
						New-HTMLSection -HeaderText 'Connection Report' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $ReturnObject.ConnectionReport }
					}
				}
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
