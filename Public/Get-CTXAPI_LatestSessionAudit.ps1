
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



	$Today = Get-Date -Format yyyy-MM-ddTHH:mm:ss.ffffZ
	$LastWeek = ((Get-Date).AddHours(-$hours)).ToString('yyyy-MM-ddTHH:mm:ss.ffffZ')

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

	function fetch-odata {
		[CmdletBinding()]
		param(
			[string]$URI,
			[System.Collections.Hashtable]$headers)
		$data = @()
		$NextLink = $URI
		While ($Null -ne $NextLink) {
			$tmp = Invoke-WebRequest -Uri $NextLink -Headers $headers | ConvertFrom-Json
			$tmp.Value | ForEach-Object { $data += $_ }
			$NextLink = $tmp.'@odata.NextLink' 
		}
		return $data
	}



	$sessions = fetch-odata -URI $SessionURI -headers $headers
	$sessionsMetric = fetch-odata -URI $SessionMetricURI -headers $headers
	$connections = fetch-odata -URI $ConnectionsURI -headers $headers
	$users = fetch-odata -URI $UsersURI -headers $headers
	$machines = fetch-odata -URI $MachinesURI -headers $headers


	$data = @()
	foreach ($session in $sessions) {
		try {
			$connection = ($connections | Where-Object { $_.SessionKey -eq $session.SessionKey })[-1]
			$user = $users | Where-Object { $_.id -like $session.UserId }
			$mashine = $machines | Where-Object { $_.id -like $session.MachineId }
			try {
				$avgrtt = 0
				$sessionsMetric | Where-Object { $_.Sessionid -like $session.SessionKey } | ForEach-Object { $avgrtt = $avgrtt + $_.IcaRttMS }
				$avgrtt = $avgrtt / ($sessionsMetric | Where-Object { $_.Sessionid -like $Session.SessionKey }).count
			} catch {}
		} catch { Write-Warning "Not enough data - $_.Exception.Message" }
		$data += [PSCustomObject]@{
			FullName                 = $user.FullName
			Upn                      = $user.upn
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
			LogOnStartDate           = $connection.LogOnStartDate
			LogOnEndDate             = $connection.LogOnEndDate
			AuthenticationDuration   = $connection.AuthenticationDuration
			LogOnDuration            = $session.LogOnDuration
			EndDate                  = $session.EndDate
			ExitCode                 = $ConnectionFailureType.($session.ExitCode)
			FailureDate              = $session.FailureDate
			ConnectionState          = $ConnectionState.($session.ConnectionState)
			AVG_ICA_RTT              = $avgrtt
		}
	}

	if ($ExportToExcel) {
		[string]$ExcelReportname = $ReportPath + '\Session_Audit-' + (Get-Date -Format yyyy.MM.dd-HH.mm) + '.xlsx'
		$data | Export-Excel -Path $ExcelReportname -AutoSize -AutoFilter -Show
	} else { $data | Out-GridHtml;$data }



} #end Function
<#
$Global:AllocationType = @{
    0 = @{"Name" = "Unknown"; "Description" = "Unknown. When the Broker does not send an allocation type."};
    1 = @{"Name" = "Static"; "Description" = "Machines get assigned to a user either by the admin or on first use. This relationship is static and changes only if an admin explicitly changes the assignments."};
    2 = @{"Name" = "Random"; "Description" = "Machines are allocated to users randomly from a pool of available machines."};
    3 = @{"Name" = "Permanent"; "Description" = "Equivalent to 'Static'."}
}
$Global:ApplicationType = @{
    0 = @{"Name" = "HostedOnDesktop"; "Description" = "The application is hosted from a desktop."};
    1 = @{"Name" = "InstalledOnClient"; "Description" = "The application is installed on a client."}
}
$Global:CatalogType = @{
    0 = @{"Name" = "ThinCloned"; "Description" = "A thin-cloned catalog is used for original golden VM images that are cloned when they are assigned to a VM, and users' changes to the VM image are retained after the VM is restarted."};
    1 = @{"Name" = "SingleImage"; "Description" = "A single-image catalog is used when multiple machines provisioned with Provisioning Services for VMs all share a single golden VM image when they run and, when restarted, they revert to the original VM image state."};
    2 = @{"Name" = "PowerManaged"; "Description" = "This catalog kind is for managed machines that are manually provisioned by administrators. All machines in this type of catalog are managed, and so must be associated with a hypervisor connection."};
    3 = @{"Name" = "Unmanaged"; "Description" = "This catalog kind is for unmanaged machines, so there is no associated hypervisor connection."};
    4 = @{"Name" = "Pvs"; "Description" = "This catalog kind is for managed machines that are provisioned using Provisioning Services. All machines in this type of catalog are managed, and so must be associated with a hypervisor connection. Only shared desktops are suitable for this catalog kind."};
    5 = @{"Name" = "Pvd"; "Description" = "A personal vDisk catalog is similar to a single-image catalog, but it also uses personal vDisk technology."};
    6 = @{"Name" = "PvsPvd"; "Description" = "A Provisioning Services-personal vDisk (PvsPvd) catalog is similar to a Provisioning Services catalog, but it also uses personal vDisk technology."}
}
$Global:HotfixChangeType = @{
    0 = @{"Name" = "Remove"; "Description" = "Removed"};
    1 = @{"Name" = "Add"; "Description" = "Added"}
}
$Global:DeliveryType = @{
    0 = @{"Name" = "DesktopsOnly"; "Description" = "Only desktops are published."};
    1 = @{"Name" = "AppsOnly"; "Description" = "Only applications are published."};
    2 = @{"Name" = "DesktopsAndApps"; "Description" = "Both desktops and applications are published."}
}
$Global:DesktopKind = @{
    0 = @{"Name" = "Private"; "Description" = "Private"};
    1 = @{"Name" = "Shared"; "Description" = "Shared"}
}
$Global:LifecycleState = @{
    0 = @{"Name" = "Active"; "Description" = "Default value - entity is active"};
    1 = @{"Name" = "Deleted"; "Description" = "Object was deleted"};
    2 = @{"Name" = "RequiresResolution"; "Description" = "Object was created, but values are missing, so a background process should poll to update missing values"};
    3 = @{"Name" = "Stub"; "Description" = "Stub object - for example, a Machine or Session that didn't really exist but is created by internal processing logic to preserve data relationships"}
}
$Global:MachineRole = @{
    0 = @{"Name" = "VDA"; "Description" = "VDA machine"};
    1 = @{"Name" = "DDC"; "Description" = "DDC machine"};
    2 = @{"Name" = "DDC, VDA"; "Description" = "Machine acting as VDA and DDC"}
}
$Global:PersistentUserChanges = @{
    0 = @{"Name" = "Unknown"; "Description" = "Unknown"};
    1 = @{"Name" = "Discard"; "Description" = "User changes are discarded."};
    2 = @{"Name" = "OnLocal"; "Description" = "User changes are persisted locally."};
    3 = @{"Name" = "OnPvd"; "Description" = "User changes are persisted on the Pvd."}
}
$Global:ProvisioningType = @{
    0 = @{"Name" = "Unknown"; "Description" = "Unknown"};
    1 = @{"Name" = "MCS"; "Description" = "Machine provisioned by Machine Creation Services (machine must be a VM)."};
    2 = @{"Name" = "PVS"; "Description" = "Machine provisioned by Provisioning Services (may be physical, blade, VM,...)."};
    3 = @{"Name" = "Manual"; "Description" = "No automated provisioning."}
}





#>