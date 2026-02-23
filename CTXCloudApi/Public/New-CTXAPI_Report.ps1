
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
 Creates varius reports from the monitor data 

#> 


<#
.SYNOPSIS
Generate Citrix Cloud monitoring reports in multiple formats (Host, Excel, HTML).

.DESCRIPTION
New-CTXAPI_Report generates detailed Citrix Cloud monitoring reports, including resource utilization, connection activity, connection failures, and machine failures. The function can output reports to the host, export to Excel, or create a styled HTML report with embedded branding. Data can be sourced from a provided MonitorData object or fetched live via API.

.PARAMETER APIHeader
The authentication header object for Citrix Cloud API requests. Required for all operations.

.PARAMETER MonitorData
Optional. Pre-fetched monitoring data object. If not provided, the function retrieves data using Get-CTXAPI_MonitorData.

.PARAMETER LastHours
Optional. Number of hours of historical data to include (default: 24). Used only if MonitorData is not provided.

.PARAMETER ReportType
Specifies which report(s) to generate. Valid values: ConnectionReport, ResourceUtilization, ConnectionFailureReport, MachineFailureReport, All.

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

.NOTES

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
		[Parameter(Mandatory = $false)]
		[int]$LastHours = 24,
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[ValidateSet('ConnectionReport', 'ResourceUtilization', 'ConnectionFailureReport', 'MachineFailureReport', 'All')]
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
	} else {
		Write-Verbose "Fetching MonitorData using Get-CTXAPI_MonitorData for last $LastHours hours."
		$monitordata = Get-CTXAPI_MonitorData -APIHeader $APIHeader -LastHours $LastHours
	}

	if ($PSBoundParameters.ContainsKey('ReportType') -and $ReportType -contains 'ResourceUtilization') {

		[System.Collections.generic.List[PSObject]]$ResourceUtilizationObject = @()
		$InGroups = $monitordata.ResourceUtilization | Group-Object -Property MachineId
		Write-Verbose ('Processing {0} machine groups.' -f $InGroups.Count)
		foreach ($machine in $InGroups) {
			Write-Verbose "Processing MachineId: $($machine.Name) with $($machine.Group.Count) data points."
			$MachineDetails = $monitordata.Machines | Where-Object {$_.id -like $machine.Name}
			$catalog = $monitordata.Catalogs | Where-Object { $_.id -eq $MachineDetails.CatalogId } | ForEach-Object { $_.name }
			$desktopgroup = $monitordata.DesktopGroups | Where-Object { $_.id -eq $MachineDetails.DesktopGroupId } | ForEach-Object { $_.name }
			try {
				$AVGPercentCpu = [math]::Round(($machine.Group | Measure-Object -Property PercentCpu -Average).Average)
				$AVGUsedMemory = [math]::Ceiling((($machine.Group | Measure-Object -Property UsedMemory -Average).Average) / 1gb)
				$AVGSessionCount = [math]::Ceiling(($machine.Group | Measure-Object -Property SessionCount -Average).Average)
				$AVGTotalMemory = [math]::Round($machine.Group[0].TotalMemory / 1gb)
				$StartCollection = $machine.Group.CollectedDate | Sort-Object | Select-Object -First 1
				$EndCollection = $machine.Group.CollectedDate | Sort-Object -Descending | Select-Object -First 1
				$timespan = New-TimeSpan -Start $StartCollection -End $EndCollection
				Write-Verbose "Averages: CPU=$AVGPercentCpu, UsedMemory=$AVGUsedMemory, SessionCount=$AVGSessionCount, TotalMemory=$AVGTotalMemory"
				Write-Verbose "Collection window: $StartCollection to $EndCollection ($timespan)"
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

	}

	if ($psboundparameters.containskey('ReportType') -and $ReportType -contains 'ConnectionReport') {
		[System.Collections.generic.List[PSObject]]$ConnectionReportObject = @()
		Write-Verbose ('Processing {0} connections.' -f $monitordata.Connections.Count)

		foreach ($connection in $monitordata.Connections) {
			Write-Verbose "[$(Get-Date -Format HH:mm:ss) PROCESS] $($monitordata.Connections.IndexOf($connection) + 1) of $($monitordata.Connections.Count)"
			try {
				$OneSession = $monitordata.Sessions | Where-Object { $_.SessionKey -eq $connection.SessionKey }
				$user = $monitordata.Users | Where-Object { $_.id -like $OneSession.UserId }
				$mashine = $monitordata.Machines | Where-Object { $_.id -like $OneSession.MachineId }
				Write-Verbose "SessionKey: $($connection.SessionKey), User: $($user.upn), Machine: $($mashine.DnsName)"
				try {
					$avgrtt = 0
					$ctxlatency = 0
					$sessdata = $monitordata.SessionMetrics | Where-Object { $_.Sessionid -like $OneSession.SessionKey }
					$avgrtt = $sessdata | Measure-Object -Property IcaRttMS -Average
					$ctxlatency = $sessdata | Measure-Object -Property IcaLatency -Average
					$StartCollection = $sessdata.CollectedDate | Sort-Object | Select-Object -First 1
					$EndCollection = $sessdata.CollectedDate | Sort-Object -Descending | Select-Object -First 1
					$timespan = New-TimeSpan -Start $StartCollection -End $EndCollection

					Write-Verbose "Metrics: RTT=$($avgrtt.Average), Latency=$($ctxlatency.Average)"
				} catch { Write-Warning "Not enough RTT data - $_.Exception.Message" }
			} catch { Write-Warning "Error processing - $_.Exception.Message" }
			$ConnectionReportObject.Add([PSCustomObject]@{
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
	}


	if ($psboundparameters.containskey('ReportType') -and $ReportType -contains 'ConnectionFailureReport') {
		[System.Collections.generic.List[PSObject]]$ConnectionFailureReportObject = @()
		foreach ($log in $monitordata.ConnectionFailureLogs) {
			$session = $monitordata.Sessions | Where-Object { $_.SessionKey -eq $log.SessionKey }
			$user = $monitordata.users | Where-Object { $_.id -like $Session.UserId }
			$mashine = $monitordata.machines | Where-Object { $_.id -like $Session.MachineId }
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
		}
	}

	if ($psboundparameters.containskey('ReportType') -and $ReportType -contains 'MachineFailureReport') {
		[System.Collections.generic.List[PSObject]]$MachineFailureReportObject = @()

		Write-Verbose "[$(Get-Date -Format HH:mm:ss) PROCESS] ""Fetching machine data from API"
		$machines = Get-CTXAPI_Machine -APIHeader $APIHeader
		foreach ($log in $mondata.MachineFailureLogs) {
			$MonDataMachine = $mondata.machines | Where-Object { $_.id -like $log.MachineId }
			$MachinesFiltered = $machines | Where-Object {$_.Name -like $MonDataMachine.Name }
			$MachineFailureReportObject.Add([PSCustomObject]@{
					Name                         = $MonDataMachine.DnsName
					AssociatedUserUPNs           = $MonDataMachine.AssociatedUserNames
					OSType                       = $MonDataMachine.OSType
					IsAssigned                   = $MonDataMachine.IsAssigned
					FailureStartDate             = if ($null -eq $log.FailureStartDate) { $null } else { Convert-UTCtoLocal -Time $log.FailureStartDate }
					FailureEndDate               = if ($null -eq $log.FailureEndDate) { $null } else { Convert-UTCtoLocal -Time $log.FailureEndDate }
					FaultState                   = $MachineFaultStateCode.($log.FaultState)
					LastDeregistrationReason     = $MachinesFiltered.LastDeregistrationReason
					LastDeregisteredCode         = $MachineDeregistration.($MonDataMachine.LastDeregisteredCode)
					LastDeregisteredDate         = if ($null -eq $MonDataMachine.LastDeregisteredDate) { $null } else { Convert-UTCtoLocal -Time $MonDataMachine.LastDeregisteredDate }
					LastConnectionFailure        = $MachinesFiltered.LastConnectionFailure
					LastPowerActionCompletedDate = if ($null -eq $MonDataMachine.LastPowerActionCompletedDate) { $null } else { Convert-UTCtoLocal -Time $MonDataMachine.LastPowerActionCompletedDate }
					LastPowerActionFailureReason = $MachineDeregistration.($MonDataMachine.LastPowerActionFailureReason)
					LastErrorReason              = $MachinesFiltered.LastErrorReason
					CurrentFaultState            = $MachinesFiltered.FaultState
					InMaintenanceMode            = $MachinesFiltered.InMaintenanceMode
					MaintenanceModeReason        = $MachinesFiltered.MaintenanceModeReason
					RegistrationState            = $MachinesFiltered.RegistrationState
				})
		}
	}


	$retun = @(
		[PSCustomObject]@{
			ResourceUtilizationReport = $ResourceUtilizationObject
			ConnectionReport          = $ConnectionReportObject
			ConnectionFailureReport   = $ConnectionFailureReportObject
			MachineFailureReport      = $MachineFailureReportObject
		}
	)


	if ($psboundparameters.containskey('ReportType') -and $Export -contains 'Host') {
		return $retun
	}
	if ($psboundparameters.containskey('ReportType') -and $Export -contains 'Excel') {
		$ReportFilename =  "Citrix_Report-$($APIHeader.CustomerName)-" + (Get-Date -Format yyyy.MM.dd-HH.mm) + '.xlsx'
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
		if ($retun.ResourceUtilizationReport) { 
			$retun.ResourceUtilizationReport | Export-Excel -Title ResourceUtilization -WorksheetName ResourceUtilization @ExcelOptions
		}
		if ($retun.ConnectionReport) { 
			$retun.ConnectionReport | Export-Excel -Title Connection -WorksheetName Connection @ExcelOptions
		}
		if ($retun.ConnectionFailureReport) { 
			$retun.ConnectionFailureReport | Export-Excel -Title ConnectionFailure -WorksheetName ConnectionFailure @ExcelOptions
		}
		if ($retun.MachineFailureReport) { 
			$retun.MachineFailureReport | Export-Excel -Title MachineFailure -WorksheetName MachineFailure @ExcelOptions
		}
	}

	if ($PSBoundParameters.ContainsKey('ReportType') -and $Export -contains 'HTML') {
		if ($null -eq $ReportPath) {
			Write-Warning 'HTML export failed. ReportPath is null or empty. Please specify a valid path using -ReportPath.'
			return
		}
		try {
			$ReportFilename =  "Citrix_Report-$($APIHeader.CustomerName)-" + (Get-Date -Format yyyy.MM.dd-HH.mm) + '.html'
			[System.IO.FileInfo]$HTMLReportname = Join-Path -Path $ReportPath -ChildPath $ReportFilename
			New-HTML -TitleText "$($APIHeader.CustomerName) Citrix Report" -FilePath $HTMLReportname.fullname -ShowHTML {
				New-HTMLHeading -Heading h1 -HeadingText $HeadingText -Color Black
				if ($retun.ResourceUtilizationReport ) {
					New-HTMLSection @SectionSettings -Content {
						New-HTMLSection -HeaderText 'Resource Utilization Report' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $retun.ResourceUtilizationReport  }
					}
				}
				if ($retun.ConnectionReport) {
					New-HTMLSection @SectionSettings -Content {
						New-HTMLSection -HeaderText 'Connection Report' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $retun.ConnectionReport }
					}
				}
				if ($retun.ConnectionFailureReport) {
					New-HTMLSection @SectionSettings -Content {
						New-HTMLSection -HeaderText 'Connection Failures Report' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $retun.ConnectionFailureReport }
					}
				}
				if ($retun.MachineFailureReport) {
					New-HTMLSection @SectionSettings -Content {
						New-HTMLSection -HeaderText 'Machine Failures Report' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $retun.MachineFailureReport }
					}
				}
			}
			Write-Verbose ('HTML report generated at: {0}' -f $HTMLReportname.fullname)
		} catch { Write-Warning "HTML export failed. $($Error[0])" }
	}
} #end Function
