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
