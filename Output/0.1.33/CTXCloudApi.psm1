#region Private Functions
#region Calc-Avg.ps1
########### Private Function ###############
# Source:           Calc-Avg.ps1
# Module:           CTXCloudApi
# ModuleVersion:    0.1.33
# Company:          Private
# CreatedOn:        2/26/2026 9:21:34 AM
# ModifiedOn:       2/26/2026 9:23:02 AM
############################################
function Calc-Avg {
	param( 
		[long]$Duration,
		[int]$Count
	) 

	if ($Count -gt 0) { 
		$calc = $Duration / [double]$Count
		return [math]::Round($calc)
	} else { return $null } 
}
#endregion
#region Check-Variable.ps1
########### Private Function ###############
# Source:           Check-Variable.ps1
# Module:           CTXCloudApi
# ModuleVersion:    0.1.33
# Company:          Private
# CreatedOn:        2/25/2026 7:13:19 AM
# ModifiedOn:       2/25/2026 10:35:10 AM
############################################
function Check-Variable {
	[CmdletBinding()]
	param (
		$VariableName
	)
	if ([string]::IsNullOrEmpty($VariableName)) {
		Write-Verbose "[$(Get-Date -Format HH:mm:ss)] [Check-Variable]  Variable is null or empty. Returning null."
		return $null
	} else {
		$Type = ($VariableName.GetType()).Name
		Write-Verbose "[$(Get-Date -Format HH:mm:ss)] [Check-Variable]  Variable is of type $Type."
		if ($Type -eq 'DateTime') {
			Write-Verbose "[$(Get-Date -Format HH:mm:ss)] [Check-Variable]  Variable is of type DateTime. Converting to local time."
			$out = Convert-UTCtoLocal -Time $VariableName
			return $out
		} else {
			Write-Verbose "[$(Get-Date -Format HH:mm:ss)] [Check-Variable]  Variable is not of type DateTime. Returning original value."
			return $VariableName
		}
	}
}
#endregion
#region Convert-UTCtoLocal.ps1
########### Private Function ###############
# Source:           Convert-UTCtoLocal.ps1
# Module:           CTXCloudApi
# ModuleVersion:    0.1.33
# Company:          Private
# CreatedOn:        2/22/2026 5:04:24 PM
# ModifiedOn:       2/25/2026 8:56:17 AM
############################################
function Convert-UTCtoLocal { 
	[OutputType([datetime])]
	param( 
		[parameter(Mandatory = $true)] 
		[datetime] $Time 
	)

	$utc = [datetime]::SpecifyKind($Time, [DateTimeKind]::Utc)
	$local = $utc.ToLocalTime()

	return $local

}
#endregion
#region Export-Odata.ps1
########### Private Function ###############
# Source:           Export-Odata.ps1
# Module:           CTXCloudApi
# ModuleVersion:    0.1.33
# Company:          Private
# CreatedOn:        11/26/2024 11:31:21 AM
# ModifiedOn:       2/25/2026 8:53:29 AM
############################################
function Export-Odata {
    [OutputType([System.Object[]])]
    param(
        [string]$URI,
        [Hashtable]$headers)

    [System.Collections.generic.List[PSObject]]$MonitorDataObject = @()
    $NextLink = $URI

    ##TODO - add page count 
    $uriObj = [Uri]($URI -replace '\\', '/')
    $resourceName = $uriObj.Segments[-1].TrimEnd('/')
    Write-Verbose "[$(Get-Date -Format HH:mm:ss)] Exporting OData resource: `t`t$resourceName"
    while (-not([string]::IsNullOrEmpty($NextLink))) {
        Write-Verbose "[$(Get-Date -Format HH:mm:ss)] [$($resourceName)] Fetching next page..."
        try {
            $request = Invoke-RestMethod -Method Get -Uri $NextLink -Headers $headers -ErrorAction Stop
        } catch {
            Write-Error "[$(Get-Date -Format HH:mm:ss)] [$($resourceName)] Failed to fetch data: $_"
            break
        }

        if ($null -eq $request) { break }

        # Detect OData error payloads and stop paging
        $errorProp = $null
        if ($request -is [object] -and $null -ne $request.PSObject) {
            $errorProp = $request.PSObject.Properties['error']
        }
        if ($null -ne $errorProp) {
            Write-Error "[$(Get-Date -Format HH:mm:ss)] [$($resourceName)] Failed to fetch data: $_"
            break
        }

        # Safely add items from 'value' if present
        $valueProp = $null
        if ($request -is [object] -and $null -ne $request.PSObject -and $null -ne $request.PSObject.Properties) {
            $valueProp = $request.PSObject.Properties['value']
        }
        if ($null -ne $valueProp -and $null -ne $valueProp.Value) {
            foreach ($item in $valueProp.Value) { $MonitorDataObject.Add($item) }
        }

        # Safely get nextLink (case-insensitive) if present
        $nextLinkProp = $null
        if ($request -is [object] -and $null -ne $request.PSObject -and $null -ne $request.PSObject.Properties) {
            $nextLinkProp = ($request.PSObject.Properties | Where-Object { $_.Name -ieq '@odata.nextLink' })
        }
        if ($null -ne $nextLinkProp -and -not [string]::IsNullOrEmpty($nextLinkProp.Value)) { 
            Write-Verbose "[$(Get-Date -Format HH:mm:ss) [$($resourceName)] PROCESS] Fetching next page...`n`n"
            $NextLink = $nextLinkProp.Value 
        } else { 
            Write-Verbose "[$(Get-Date -Format HH:mm:ss) [$($resourceName)] PROCESS] No more pages to fetch.`n`n"
            $NextLink = $null 
        }
    }
    Write-Verbose "[$(Get-Date -Format HH:mm:ss) [$($resourceName)] PROCESS] Exited paging loop. Total items fetched: $($MonitorDataObject.Count)`n`n"
    return $MonitorDataObject

}
#endregion
#region Get-CTXAPIDatapages.ps1
########### Private Function ###############
# Source:           Get-CTXAPIDatapages.ps1
# Module:           CTXCloudApi
# ModuleVersion:    0.1.33
# Company:          Private
# CreatedOn:        2/22/2026 1:05:04 PM
# ModifiedOn:       2/25/2026 9:01:51 AM
############################################
function Get-CTXAPIDatapages {
	[Cmdletbinding()]
	[OutputType([System.Collections.Generic.List[PSObject]])]
	param(
		[Parameter(Mandatory = $true)]
		$APIHeader,
		[Parameter(Mandatory = $true)]
		[string]$uri
	)
	$uriObj = [Uri]($URI -replace '\\', '/')
	$resourceName = $uriObj.Segments[-1].TrimEnd('/')
	
	[System.Collections.generic.List[PSObject]]$ReturnObject = @()
	Write-Verbose "[$(Get-Date -Format HH:mm:ss)] [$($resourceName)] Requesting initial page: $uri"
	$response = Invoke-RestMethod -Uri $uri -Method GET -Headers $APIHeader.headers
	Write-Verbose "[$(Get-Date -Format HH:mm:ss)] [$($resourceName)] Received $($response.Items.Count) items from initial page"
	$response.Items | ForEach-Object {
		$ReturnObject.Add($_)
	}

	if ($response.PSObject.Properties['ContinuationToken']) {
		$ContinuationToken = $response.ContinuationToken
		Write-Verbose "[$(Get-Date -Format HH:mm:ss)] [$($resourceName)] Continuation token found"
	} else {
		$ContinuationToken = $null
		Write-Verbose "[$(Get-Date -Format HH:mm:ss)] [$($resourceName)] No continuation token found."
	}

	while (-not [string]::IsNullOrEmpty($ContinuationToken)) {
		$requestUriContinue = $uri + '&continuationtoken=' + $ContinuationToken
		Write-Verbose "[$(Get-Date -Format HH:mm:ss)] [$($resourceName)] Requesting next page"
		$responsePage = Invoke-RestMethod -Uri $requestUriContinue -Method GET -Headers $APIHeader.headers

		if ($responsePage.PSObject.Properties['Items']) {
			Write-Verbose "[$(Get-Date -Format HH:mm:ss)] [$($resourceName)] Received $($responsePage.Items.Count) items from continuation page."
			$responsePage.Items | ForEach-Object {
				$ReturnObject.Add($_)
			}
		} else {
			Write-Verbose "[$(Get-Date -Format HH:mm:ss)] [$($resourceName)] No items found in continuation page."
		}

		if ($responsePage.PSObject.Properties['ContinuationToken'] -and -not [string]::IsNullOrEmpty($responsePage.ContinuationToken)) {
			$ContinuationToken = $responsePage.ContinuationToken
			Write-Verbose "[$(Get-Date -Format HH:mm:ss)] [$($resourceName)] Next continuation token: $ContinuationToken"
		} else {
			$ContinuationToken = $null
			Write-Verbose "[$(Get-Date -Format HH:mm:ss)] [$($resourceName)] No further continuation token found."
		}
	}
	Write-Verbose "[$(Get-Date -Format HH:mm:ss)] [$($resourceName)] Returning $($ReturnObject.Count) total items."
	return $ReturnObject

} #end function
#endregion
#region Reports-Colors.ps1
########### Private Function ###############
# Source:           Reports-Colors.ps1
# Module:           CTXCloudApi
# ModuleVersion:    0.1.33
# Company:          Private
# CreatedOn:        11/26/2024 11:31:34 AM
# ModifiedOn:       2/24/2026 5:13:21 PM
############################################
$script:CTXAPI_Color1 = '#2b1200'
$script:CTXAPI_Color2 = '#f37000'
#$script:CTXAPI_LogoURL = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSDhA8LhyiU70Dc6v9zh5Gnb-8W05xMP2d2mw&s'
$script:CTXAPI_LogoURL = 'https://www.vhv.rs/dpng/d/607-6072047_0-replies-4-retweets-5-likes-citrix-cloud.png'
#region Html Settings
$script:TableSettings = @{
	Style           = 'cell-border'
	TextWhenNoData  = 'No Data to display here'
	Buttons         = 'searchBuilder', 'pdfHtml5', 'excelHtml5'
	AutoSize        = $true
	DisableSearch   = $true
	FixedHeader     = $true
	HideFooter      = $true
	ScrollCollapse  = $true
	ScrollX         = $true
	ScrollY         = $true
	SearchHighlight = $true
}
$script:SectionSettings = @{
	BackgroundColor       = 'grey'
	CanCollapse           = $true
	HeaderBackGroundColor = $CTXAPI_Color1
	HeaderTextAlignment   = 'center'
	HeaderTextColor       = $CTXAPI_Color2
	HeaderTextSize        = '20'
	BorderRadius          = '15px'
}
$script:TableSectionSettings = @{
	BackgroundColor       = 'white'
	CanCollapse           = $true
	HeaderBackGroundColor = $CTXAPI_Color2
	HeaderTextAlignment   = 'center'
	HeaderTextColor       = $CTXAPI_Color1
	HeaderTextSize        = '15'
}
#endregion


#endregion
#region Reports-Variables.ps1
########### Private Function ###############
# Source:           Reports-Variables.ps1
# Module:           CTXCloudApi
# ModuleVersion:    0.1.33
# Company:          Private
# CreatedOn:        11/26/2024 11:31:29 AM
# ModifiedOn:       2/26/2026 8:08:50 AM
############################################
# https://developer-docs.citrix.com/en-us/monitor-service-odata-api/monitor-service-enums

# =========================
# AllocationType
# =========================
$script:AllocationType = [PSCustomObject]@{
    0 = 'Unknown'
    1 = 'Static'
    2 = 'Random'
    3 = 'Permanent'
}

# =========================
# SessionFailureCode
# =========================
$script:SessionFailureCode = [PSCustomObject]@{
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

# =========================
# CatalogType
# =========================
$script:CatalogType = [PSCustomObject]@{
    0 = 'ThinCloned'
    1 = 'SingleImage'
    2 = 'PowerManaged'
    3 = 'UnManaged'
    4 = 'Pvs'
    5 = 'Pvd'
    6 = 'PvsPvd'
}

# =========================
# ConditionTargetType
# =========================
$script:ConditionTargetType = [PSCustomObject]@{
    0 = 'Unknown'
    1 = 'Site'
    2 = 'Controller'
    3 = 'DesktopGroup'
    4 = 'Catalog'
    5 = 'RdsWorker'
    6 = 'Vdi'
    7 = 'User'
}

# =========================
# ConnectionFailureType
# =========================
$script:ConnectionFailureType = [PSCustomObject]@{
    0 = 'None'
    1 = 'ClientConnectionFailure'
    2 = 'MachineFailure'
    3 = 'NoCapacityAvailable'
    4 = 'NoLicensesAvailable'
    5 = 'Configuration'
}

# =========================
# ConnectionState
# =========================
$script:ConnectionState = [PSCustomObject]@{
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

# =========================
# DeliveryType
# =========================
$script:DeliveryType = [PSCustomObject]@{
    0 = 'DesktopsOnly'
    1 = 'AppsOnly'
    2 = 'DesktopsAndApps'
}

# =========================
# MachineDeregistration
# =========================
$script:MachineDeregistration = [PSCustomObject]@{
    0    = 'AgentShutdown'
    1    = 'AgentSuspended'
    2    = 'AgentRequested'
    100  = 'IncompatibleVersion'
    101  = 'AgentAddressResolutionFailed'
    102  = 'AgentNotContactable'
    103  = 'AgentWrongActiveDirectoryOU'
    104  = 'EmptyRegistrationRequest'
    105  = 'MissingRegistrationCapabilities'
    106  = 'MissingAgentVersion'
    108  = 'NotLicensedForFeature'
    109  = 'UnsupportedCredentialSecurityVersion'
    110  = 'InvalidRegistrationRequest'
    111  = 'SingleMultiSessionMismatch'
    112  = 'FunctionalLevelTooLowForCatalog'
    113  = 'FunctionalLevelTooLowForDesktopGroup'
    114  = 'OSNotCompatibleWithDdc'
    115  = 'VMNotCompatibleWithDdc'
    200  = 'PowerOff'
    201  = 'DesktopRestart'
    202  = 'DesktopRemoved'
    203  = 'AgentRejectedSettingsUpdate'
    204  = 'SendSettingsFailure'
    205  = 'SessionAuditFailure'
    206  = 'SessionPrepareFailure'
    207  = 'ContactLost'
    208  = 'SettingsCreationFailure'
    300  = 'UnknownError'
    301  = 'BrokerRegistrationLimitReached'
    400  = 'None'
    401  = 'HypervisorReportedFailure'
    402  = 'HypervisorRateLimitExceeded'
    1000 = 'HardRegistrationPending'
    1001 = 'SoftRegistered'
    1002 = 'Unknown'
}

# =========================
# DesktopKind
# =========================
$script:DesktopKind = [PSCustomObject]@{
    0 = 'Private'
    1 = 'Shared'
}

# =========================
# DesktopType
# =========================
$script:DesktopType = [PSCustomObject]@{
    0 = 'None'
    1 = 'Vdi'
    2 = 'RemotePc'
    3 = 'Rds'
    4 = 'Unknown'
}

# =========================
# FailureCategory
# =========================
$script:FailureCategory = [PSCustomObject]@{
    0 = 'Unknown'
    1 = 'Connection'
    2 = 'Machine'
}

# =========================
# LifecycleState
# =========================
$script:LifecycleState = [PSCustomObject]@{
    0 = 'Active'
    1 = 'Deleted'
    2 = 'RequiresResolution'
    3 = 'Stub'
}

# =========================
# LogonBreakdownType
# =========================
$script:LogonBreakdownType = [PSCustomObject]@{
    0 = 'None'
    1 = 'UsersLastSession'
    2 = 'UsersSessionAverage'
    3 = 'DesktopGroupAverage'
}

# =========================
# LogOnStep
# =========================
$script:LogOnStep = [PSCustomObject]@{
    0 = 'Total'
    1 = 'Brokering'
    2 = 'VMStart'
    3 = 'Hdx'
    4 = 'Authentication'
    5 = 'Gpos'
    6 = 'LogOnScripts'
    7 = 'ProfileLoad'
    8 = 'Interactive'
}

# =========================
# MachineFaultStateCode
# =========================
$script:MachineFaultStateCode = [PSCustomObject]@{
    0 = 'Unknown'
    1 = 'None'
    2 = 'FailedToStart'
    3 = 'StuckOnBoot'
    4 = 'Unregistered'
    5 = 'MaxCapacity'
    6 = 'VirtualMachineNotFound'
}

# =========================
# MachineRole
# =========================
$script:MachineRole = [PSCustomObject]@{
    0 = 'Vda'
    1 = 'Ddc'
    2 = 'Both'
}

# =========================
# PowerActionReasonCode
# =========================
$script:PowerActionReasonCode = [PSCustomObject]@{
    0 = 'Unknown'
    1 = 'Reset'
    2 = 'Pvd'
    3 = 'Schedule'
    4 = 'Launch'
    5 = 'Admin'
    6 = 'Untaint'
    7 = 'Policy'
    8 = 'IdlePool'
}

# =========================
# PowerActionTypeCode
# =========================
$script:PowerActionTypeCode = [PSCustomObject]@{
    0 = 'Unknown'
    1 = 'PowerOn'
    2 = 'PowerOff'
    3 = 'Shutdown'
    4 = 'Reset'
    5 = 'Restart'
    6 = 'Suspend'
    7 = 'Resume'
}

# =========================
# ProvisioningType
# =========================
$script:ProvisioningType = [PSCustomObject]@{
    0 = 'Unknown'
    1 = 'MCS'
    2 = 'PVS'
    3 = 'Manual'
}

# =========================
# PowerStateCode
# =========================
$script:PowerStateCode = [PSCustomObject]@{
    0  = 'Unknown'
    1  = 'Unavailable'
    2  = 'Off'
    3  = 'On'
    4  = 'Suspended'
    5  = 'TurningOn'
    6  = 'TurningOff'
    7  = 'Suspending'
    8  = 'Resuming'
    9  = 'Unmanaged'
    10 = 'NotSupported'
    11 = 'VirtualMachineNotFound'
}

# =========================
# PersistentUserChangesType
# =========================
$script:PersistentUserChangesType = [PSCustomObject]@{
    0 = 'Unknown'
    1 = 'Discard'
    2 = 'OnLocal'
    3 = 'OnPvd'
}

$script:AllocationType = [PSCustomObject]@{
    0 = 'Unknown'
    1 = 'Static'
    2 = 'Random'
    3 = 'Permanent'
}

$script:SessionFailureCode = [PSCustomObject]@{
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

$script:CatalogType = [PSCustomObject]@{
    0 = 'ThinCloned'
    1 = 'SingleImage'
    2 = 'PowerManaged'
    3 = 'UnManaged'
    4 = 'Pvs'
    5 = 'Pvd'
    6 = 'PvsPvd'
}

$script:ConditionTargetType = [PSCustomObject]@{
    0 = 'Unknown'
    1 = 'Site'
    2 = 'Controller'
    3 = 'DesktopGroup'
    4 = 'Catalog'
    5 = 'RdsWorker'
    6 = 'Vdi'
    7 = 'User'
}

$script:ConnectionFailureType = [PSCustomObject]@{
    0 = 'None'
    1 = 'ClientConnectionFailure'
    2 = 'MachineFailure'
    3 = 'NoCapacityAvailable'
    4 = 'NoLicensesAvailable'
    5 = 'Configuration'
}

$script:ConnectionState = [PSCustomObject]@{
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

$script:DeliveryType = [PSCustomObject]@{
    0 = 'DesktopsOnly'
    1 = 'AppsOnly'
    2 = 'DesktopsAndApps'
}

$script:MachineDeregistration = [PSCustomObject]@{
    0    = 'AgentShutdown'
    1    = 'AgentSuspended'
    2    = 'AgentRequested'
    100  = 'IncompatibleVersion'
    101  = 'AgentAddressResolutionFailed'
    102  = 'AgentNotContactable'
    103  = 'AgentWrongActiveDirectoryOU'
    104  = 'EmptyRegistrationRequest'
    105  = 'MissingRegistrationCapabilities'
    106  = 'MissingAgentVersion'
    108  = 'NotLicensedForFeature'
    109  = 'UnsupportedCredentialSecurityVersion'
    110  = 'InvalidRegistrationRequest'
    111  = 'SingleMultiSessionMismatch'
    112  = 'FunctionalLevelTooLowForCatalog'
    113  = 'FunctionalLevelTooLowForDesktopGroup'
    114  = 'OSNotCompatibleWithDdc'
    115  = 'VMNotCompatibleWithDdc'
    200  = 'PowerOff'
    201  = 'DesktopRestart'
    202  = 'DesktopRemoved'
    203  = 'AgentRejectedSettingsUpdate'
    204  = 'SendSettingsFailure'
    205  = 'SessionAuditFailure'
    206  = 'SessionPrepareFailure'
    207  = 'ContactLost'
    208  = 'SettingsCreationFailure'
    300  = 'UnknownError'
    301  = 'BrokerRegistrationLimitReached'
    400  = 'None'
    401  = 'HypervisorReportedFailure'
    402  = 'HypervisorRateLimitExceeded'
    1000 = 'HardRegistrationPending'
    1001 = 'SoftRegistered'
    1002 = 'Unknown'
}

$script:DesktopKind = [PSCustomObject]@{
    0 = 'Private'
    1 = 'Shared'
}

$script:DesktopType = [PSCustomObject]@{
    0 = 'None'
    1 = 'Vdi'
    2 = 'RemotePc'
    3 = 'Rds'
    4 = 'Unknown'
}

$script:FailureCategory = [PSCustomObject]@{
    0 = 'Unknown'
    1 = 'Connection'
    2 = 'Machine'
}

$script:LifecycleState = [PSCustomObject]@{
    0 = 'Active'
    1 = 'Deleted'
    2 = 'RequiresResolution'
    3 = 'Stub'
}

$script:LogonBreakdownType = [PSCustomObject]@{
    0 = 'None'
    1 = 'UsersLastSession'
    2 = 'UsersSessionAverage'
    3 = 'DesktopGroupAverage'
}

$script:LogOnStep = [PSCustomObject]@{
    0 = 'Total'
    1 = 'Brokering'
    2 = 'VMStart'
    3 = 'Hdx'
    4 = 'Authentication'
    5 = 'Gpos'
    6 = 'LogOnScripts'
    7 = 'ProfileLoad'
    8 = 'Interactive'
}

$script:MachineFaultStateCode = [PSCustomObject]@{
    0 = 'Unknown'
    1 = 'None'
    2 = 'FailedToStart'
    3 = 'StuckOnBoot'
    4 = 'Unregistered'
    5 = 'MaxCapacity'
    6 = 'VirtualMachineNotFound'
}

$script:MachineRole = [PSCustomObject]@{
    0 = 'Vda'
    1 = 'Ddc'
    2 = 'Both'
}

$script:PowerActionReasonCode = [PSCustomObject]@{
    0 = 'Unknown'
    1 = 'Reset'
    2 = 'Pvd'
    3 = 'Schedule'
    4 = 'Launch'
    5 = 'Admin'
    6 = 'Untaint'
    7 = 'Policy'
    8 = 'IdlePool'
}

$script:PowerActionTypeCode = [PSCustomObject]@{
    0 = 'Unknown'
    1 = 'PowerOn'
    2 = 'PowerOff'
    3 = 'Shutdown'
    4 = 'Reset'
    5 = 'Restart'
    6 = 'Suspend'
    7 = 'Resume'
}

$script:ProvisioningType = [PSCustomObject]@{
    0 = 'Unknown'
    1 = 'MCS'
    2 = 'PVS'
    3 = 'Manual'
}

$script:PowerStateCode = [PSCustomObject]@{
    0  = 'Unknown'
    1  = 'Unavailable'
    2  = 'Off'
    3  = 'On'
    4  = 'Suspended'
    5  = 'TurningOn'
    6  = 'TurningOff'
    7  = 'Suspending'
    8  = 'Resuming'
    9  = 'Unmanaged'
    10 = 'NotSupported'
    11 = 'VirtualMachineNotFound'
}

$script:PersistentUserChangesType = [PSCustomObject]@{
    0 = 'Unknown'
    1 = 'Discard'
    2 = 'OnLocal'
    3 = 'OnPvd'
}
# =========================
# RegistrationState
# =========================
$script:RegistrationState = [PSCustomObject]@{
    0 = 'Unknown'
    1 = 'Registered'
    2 = 'Unregistered'
}

# =========================
# SessionType
# =========================
$script:SessionType = [PSCustomObject]@{
    0 = 'Desktop'
    1 = 'Application'
}

# =========================
# SessionSupportCode
# =========================
$script:SessionSupportCode = [PSCustomObject]@{
    0 = 'Unknown'
    1 = 'SingleSession'
    2 = 'MultiSession'
}

# =========================
# CostType
# =========================
$script:CostType = [PSCustomObject]@{
    0 = 'Unknown'
    1 = 'AssumedCost'
    2 = 'ConfiguredCostFromStudio'
    3 = 'AzureRetailAPI'
    4 = 'CostFromHostService'
    5 = 'ActualCost'
}

# =========================
# CurrencyType
# =========================
$script:CurrencyType = [PSCustomObject]@{
    0 = 'Unknown'
    1 = 'USD'
    2 = 'EUR'
    3 = 'CAD'
    4 = 'CNY'
    5 = 'BRL'
    6 = 'NZD'
    7 = 'GBP'
    8 = 'JPY'
    9 = 'KRW'
}

# =========================
# CostSavingsSummaryGranularity
# =========================
$script:CostSavingsSummaryGranularity = [PSCustomObject]@{
    0 = 'Hour'
    1 = 'Day'
    2 = 'Month'
    3 = 'DayLevelInMinutes'
}

# =========================
# HypervisorType
# =========================
$script:HypervisorType = [PSCustomObject]@{
    0 = 'None'
    1 = 'Unknown'
    2 = 'Azure'
    3 = 'AWS'
    4 = 'GCP'
    5 = 'XenServer'
    6 = 'HyperV'
    7 = 'AHV'
    8 = 'VSphere'
}

# =========================
# WorkspaceType
# =========================
$script:WorkspaceType = [PSCustomObject]@{
    0 = 'Unknown'
    1 = 'Windows'
    2 = 'Mac'
    3 = 'Linux'
    4 = 'HTML5'
    5 = 'Chrome'
}
#endregion
#endregion
 
#region Public Functions
#region Connect-CTXAPI.ps1
######## Function 1 of 19 ##################
# Function:         Connect-CTXAPI
# Module:           CTXCloudApi
# ModuleVersion:    0.1.33
# Author:           Pierre Smit
# Company:          Private
# CreatedOn:        11/26/2024 11:41:06 AM
# ModifiedOn:       2/18/2026 12:33:17 PM
# Synopsis:         Connects to Citrix Cloud and creates required API headers.
#############################################
 
<#
.SYNOPSIS
Connects to Citrix Cloud and creates required API headers.

.DESCRIPTION
Authenticates against Citrix Cloud using `Client_Id` and `Client_Secret`, resolves the CVAD `Citrix-InstanceId`, and constructs headers for subsequent CTXCloudApi requests. Returns a `CTXAPIHeaderObject` containing `CustomerName`, `TokenExpireAt` (about 1 hour), `CTXAPI` (ids), and `headers`.

.PARAMETER Customer_Id
Citrix Customer ID (GUID) from the Citrix Cloud console.

.PARAMETER Client_Id
OAuth Client ID created under Citrix Cloud API access.

.PARAMETER Client_Secret
OAuth Client Secret for the above Client ID.

.PARAMETER Customer_Name
Display name used in reports/filenames to identify this connection.

.EXAMPLE
$splat = @{
	Customer_Id = "xxx"
	Client_Id = "xxx-xxx-xxx-xxx"
	Client_Secret = "yyyyyy=="
	Customer_Name = 'HomeLab'
}
$APIHeader = Connect-CTXAPI @splat

.EXAMPLE
Connect-CTXAPI -Customer_Id "xxx" -Client_Id "xxx-xxx" -Client_Secret "yyyyyy==" -Customer_Name "Prod"
Creates and returns a `CTXAPIHeaderObject`. Store it in a variable (e.g., `$APIHeader`) and pass to other cmdlets.

#>

function Connect-CTXAPI {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Connect-CTXAPI')]
    param(
        [Parameter(Mandatory)]
        [string]$Customer_Id,
        [Parameter(Mandatory)]
        [string]$Client_Id,
        [Parameter(Mandatory)]
        [string]$Client_Secret,
        [Parameter(Mandatory)]
        [string]$Customer_Name
    )

    $body = @{
        grant_type    = 'client_credentials'
        client_id     = $Client_Id
        client_secret = $Client_Secret
    }

    $headers = @{
        Authorization       = "CwsAuth Bearer=$((Invoke-RestMethod -Method Post -Uri 'https://api.cloud.com/cctrustoauth2/root/tokens/clients' -Body $body).access_token)"
        'Citrix-CustomerId' = $Customer_Id
        Accept              = 'application/json'
    }
    $headers.Add('Citrix-InstanceId', (Invoke-RestMethod 'https://api.cloud.com/cvadapis/me' -Headers $headers).customers.sites.id)
    $headers.Add('User-Agent', 'Powershell-Citrix-Monitor')
    $headers.Add('Accept-Encoding', 'gzip')
    $headers.Add('Content-Type', 'application/json')

    $CTXApi = @()
    $CTXApi = [PSCustomObject]@{
        Customer_Id   = $Customer_Id
        Client_Id     = $Client_Id
        Client_Secret = $Client_Secret
    }

    $myObject = [PSCustomObject]@{
        PSTypeName    = 'CTXAPIHeaderObject'
        CustomerName  = $Customer_Name
        TokenExpireAt = Get-Date (Get-Date).AddHours(1)
        CTXAPI        = $CTXApi
        headers       = $headers
    }
    $myObject
} #end Function
 
Export-ModuleMember -Function Connect-CTXAPI
#endregion
 
#region Get-CTXAPI_Application.ps1
######## Function 2 of 19 ##################
# Function:         Get-CTXAPI_Application
# Module:           CTXCloudApi
# ModuleVersion:    0.1.33
# Author:           Pierre Smit
# Company:          Private
# CreatedOn:        11/26/2024 11:40:56 AM
# ModifiedOn:       2/22/2026 2:50:04 PM
# Synopsis:         Returns details about published applications (handles pagination).
#############################################
 
<#
.SYNOPSIS
Returns details about published applications (handles pagination).

.DESCRIPTION
Returns details about published applications from Citrix Cloud CVAD.

.PARAMETER APIHeader
Header object created by Connect-CTXAPI; contains authentication and request headers.

.EXAMPLE
Get-CTXAPI_Application -APIHeader $APIHeader | Select-Object Name, Enabled, NumAssociatedDeliveryGroups
Lists application names, enabled state, and associated delivery group count.

.EXAMPLE
Get-CTXAPI_Application -APIHeader $APIHeader | Where-Object Enabled | Select-Object Name
Shows only enabled applications.

.INPUTS
None. Parameters are not accepted from the pipeline.

.OUTPUTS
PSCustomObject[]
Array of application objects returned from the CVAD Manage API.

.LINK
https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Application
#>

function Get-CTXAPI_Application {
	[Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Application')]
	[Alias('Get-CTXAPI_Applications')]
	[OutputType([psobject[]])]
	param(
		[Parameter(Mandatory = $true)]
		[ValidateNotNullorEmpty()]
		[PSTypeName('CTXAPIHeaderObject')]$APIHeader)


	$requestUri = 'https://api.cloud.com/cvad/manage/Applications?limit=1000'
	$data = Get-CTXAPIDatapages -APIHeader $APIHeader -uri $requestUri
	return $data

} #end Function
 
Export-ModuleMember -Function Get-CTXAPI_Application
#endregion
 
#region Get-CTXAPI_CloudService.ps1
######## Function 3 of 19 ##################
# Function:         Get-CTXAPI_CloudService
# Module:           CTXCloudApi
# ModuleVersion:    0.1.33
# Author:           Pierre Smit
# Company:          Private
# CreatedOn:        11/26/2024 11:41:40 AM
# ModifiedOn:       2/18/2026 1:44:53 PM
# Synopsis:         Returns details about cloud services and subscription.
#############################################
 
<#
.SYNOPSIS
Returns details about cloud services and subscription.

.DESCRIPTION
Returns details about Citrix Cloud services and subscription state from the `serviceStates` endpoint.

.PARAMETER APIHeader
Header object created by Connect-CTXAPI; contains authentication and request headers.

.EXAMPLE
Get-CTXAPI_CloudService -APIHeader $APIHeader | Select-Object serviceName, state, lastUpdated
Lists each service name, its current state, and the last update time.

.EXAMPLE
Get-CTXAPI_CloudService -APIHeader $APIHeader | Where-Object { $_.state -ne 'Enabled' }
Shows services that are not currently enabled.

.INPUTS
None. Parameters are not accepted from the pipeline.

.OUTPUTS
PSCustomObject[]
Array of service state objects returned from the Core Workspaces API.

.LINK
https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_CloudService

#>

function Get-CTXAPI_CloudService {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_CloudService')]
    [Alias('Get-CTXAPI_CloudServices')]
    [OutputType([psobject[]])]
    param(
        [Parameter(Mandatory = $true)]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader)

    (Invoke-RestMethod -Uri "https://core.citrixworkspacesapi.net/$($ApiHeader.headers.'Citrix-CustomerId')/serviceStates" -Headers $ApiHeader.headers).items

} #end Function
 
Export-ModuleMember -Function Get-CTXAPI_CloudService
#endregion
 
#region Get-CTXAPI_ConfigLog.ps1
######## Function 4 of 19 ##################
# Function:         Get-CTXAPI_ConfigLog
# Module:           CTXCloudApi
# ModuleVersion:    0.1.33
# Author:           Pierre Smit
# Company:          Private
# CreatedOn:        11/26/2024 11:41:14 AM
# ModifiedOn:       2/18/2026 11:22:22 AM
# Synopsis:         Returns high-level configuration changes in the last X days.
#############################################
 
<#
.SYNOPSIS
Returns high-level configuration changes in the last X days.

.DESCRIPTION
Returns high-level configuration changes over the past X days from the Config Log Operations endpoint.

.PARAMETER Days
Number of days to report on (e.g., 7, 15, 30).

.PARAMETER APIHeader
Header object created by Connect-CTXAPI; contains authentication and request headers.

.EXAMPLE
Get-CTXAPI_ConfigLog -APIHeader $APIHeader -Days 15 | Select-Object TimeStamp, ObjectType, OperationType, User
Shows recent configuration operations with key fields for the past 15 days.

.EXAMPLE
Get-CTXAPI_ConfigLog -APIHeader $APIHeader -Days 7 | Where-Object { $_.ObjectType -eq 'DeliveryGroup' }
Filters operations related to Delivery Groups in the last 7 days.

.INPUTS
None. Parameters are not accepted from the pipeline.

.OUTPUTS
System.Object[]
Array of configuration operation objects returned from the CVAD Manage API.

.LINK
https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_ConfigLog

#>

function Get-CTXAPI_ConfigLog {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_ConfigLog')]
    param(
        [Parameter(Mandatory = $true)]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader,
        [Parameter(Mandatory = $true)]
        [string]$Days)

        

    (Invoke-RestMethod -Uri "https://api.cloud.com/cvad/manage/ConfigLog/Operations?days=$days" -Headers $APIHeader.headers).items

} #end Function
 
Export-ModuleMember -Function Get-CTXAPI_ConfigLog
#endregion
 
#region Get-CTXAPI_DeliveryGroup.ps1
######## Function 5 of 19 ##################
# Function:         Get-CTXAPI_DeliveryGroup
# Module:           CTXCloudApi
# ModuleVersion:    0.1.33
# Author:           Pierre Smit
# Company:          Private
# CreatedOn:        11/26/2024 11:40:59 AM
# ModifiedOn:       2/22/2026 1:20:26 PM
# Synopsis:         Returns details about Delivery Groups (handles pagination).
#############################################
 
<#
.SYNOPSIS
Returns details about Delivery Groups (handles pagination).

.DESCRIPTION
Returns details about Delivery Groups from Citrix Cloud CVAD.

.PARAMETER APIHeader
Header object created by Connect-CTXAPI; contains authentication and request headers.

.EXAMPLE
Get-CTXAPI_DeliveryGroup -APIHeader $APIHeader | Select-Object Name, TotalMachines, InMaintenanceMode
Lists group name, total machines, and maintenance status.

.EXAMPLE
Get-CTXAPI_DeliveryGroup -APIHeader $APIHeader | Where-Object { $_.IsBroken }
Shows delivery groups marked as broken.

.INPUTS
None. Parameters are not accepted from the pipeline.

.OUTPUTS
PSCustomObject[]
Array of delivery group objects returned from the CVAD Manage API.

.LINK
https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_DeliveryGroup

#>

function Get-CTXAPI_DeliveryGroup {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_DeliveryGroup')]
    [Alias('Get-CTXAPI_DeliveryGroups')]
    [OutputType([psobject[]])]
    param(
        [Parameter(Mandatory = $true)]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader
    )


    
    $requestUri = 'https://api.cloud.com/cvad/manage/DeliveryGroups?limit=1000'
    $data = Get-CTXAPIDatapages -APIHeader $APIHeader -uri $requestUri
    return $data
} #end Function
 
Export-ModuleMember -Function Get-CTXAPI_DeliveryGroup
#endregion
 
#region Get-CTXAPI_Hypervisor.ps1
######## Function 6 of 19 ##################
# Function:         Get-CTXAPI_Hypervisor
# Module:           CTXCloudApi
# ModuleVersion:    0.1.33
# Author:           Pierre Smit
# Company:          Private
# CreatedOn:        11/26/2024 11:41:11 AM
# ModifiedOn:       2/22/2026 1:20:55 PM
# Synopsis:         Returns details about hosting (hypervisor) connections (handles pagination).
#############################################
 
<#
.SYNOPSIS
Returns details about hosting (hypervisor) connections (handles pagination).

.DESCRIPTION
Returns details about hosting (hypervisor) connections from Citrix Cloud CVAD.

.PARAMETER APIHeader
Header object created by Connect-CTXAPI; contains authentication and request headers.

.EXAMPLE
Get-CTXAPI_Hypervisor -APIHeader $APIHeader | Select-Object Name, HostingType, Enabled
Lists hypervisor name, hosting type, and enabled state.

.EXAMPLE
Get-CTXAPI_Hypervisor -APIHeader $APIHeader | Where-Object { $_.IsBroken }
Shows hypervisors marked as broken.

.INPUTS
None. Parameters are not accepted from the pipeline.

.OUTPUTS
PSCustomObject[]
Array of hypervisor objects returned from the CVAD Manage API.

.LINK
https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Hypervisor

#>

function Get-CTXAPI_Hypervisor {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Hypervisor')]
    [Alias('Get-CTXAPI_Hypervisors')]
    [OutputType([psobject[]])]
    param(
        [Parameter(Mandatory = $true)]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader
    )

    $requestUri = 'https://api.cloud.com/cvad/manage/hypervisors?limit=1000'
    $data = Get-CTXAPIDatapages -APIHeader $APIHeader -uri $requestUri
    return $data
} #end Function
 
Export-ModuleMember -Function Get-CTXAPI_Hypervisor
#endregion
 
#region Get-CTXAPI_LowLevelOperation.ps1
######## Function 7 of 19 ##################
# Function:         Get-CTXAPI_LowLevelOperation
# Module:           CTXCloudApi
# ModuleVersion:    0.1.33
# Author:           Pierre Smit
# Company:          Private
# CreatedOn:        11/26/2024 11:40:53 AM
# ModifiedOn:       2/18/2026 10:39:53 AM
# Synopsis:         Returns details about low-level configuration changes (more detailed).
#############################################
 
<#
.SYNOPSIS
Returns details about low-level configuration changes (more detailed).

.DESCRIPTION
Returns details about low-level configuration changes for a specific operation ID from Config Log.

.PARAMETER APIHeader
Header object created by Connect-CTXAPI; contains authentication and request headers.

.PARAMETER HighLevelID
Unique id for a config change (from Get-CTXAPI_ConfigLog).

.EXAMPLE
$ConfigLog = Get-CTXAPI_ConfigLog -APIHeader $APIHeader -Days 7
$LowLevelOperations = Get-CTXAPI_LowLevelOperation -APIHeader $APIHeader -HighLevelID $ConfigLog[0].id
Retrieves low-level operations for the first high-level operation in the past 7 days.

.EXAMPLE
Get-CTXAPI_LowLevelOperation -APIHeader $APIHeader -HighLevelID "<operation-id>" | Select-Object OperationType, Property, OldValue, NewValue
Shows key fields for each low-level change.

.INPUTS
None. Parameters are not accepted from the pipeline.

.OUTPUTS
System.Object[]
Array of low-level operation objects returned from the CVAD Manage API.

.LINK
https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_LowLevelOperation

#>

function Get-CTXAPI_LowLevelOperation {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_LowLevelOperation')]
    [Alias('Get-CTXAPI_LowLevelOperations')]
    [OutputType([System.Object[]])]
    param(
        [Parameter(Mandatory = $true)]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$HighLevelID)

    (Invoke-RestMethod -Uri "https://api.cloud.com/cvad/manage/ConfigLog/Operations/$($HighLevelID)/LowLevelOperations" -Method get -Headers $APIHeader.headers).items


}
 
Export-ModuleMember -Function Get-CTXAPI_LowLevelOperation
#endregion
 
#region Get-CTXAPI_Machine.ps1
######## Function 8 of 19 ##################
# Function:         Get-CTXAPI_Machine
# Module:           CTXCloudApi
# ModuleVersion:    0.1.33
# Author:           Pierre Smit
# Company:          Private
# CreatedOn:        11/26/2024 11:40:38 AM
# ModifiedOn:       2/22/2026 1:32:26 PM
# Synopsis:         Returns details about VDA machines (handles pagination).
#############################################
 
<#
.SYNOPSIS
Returns details about VDA machines (handles pagination).

.DESCRIPTION
Returns details about VDA machines from Citrix Cloud CVAD.

.PARAMETER APIHeader
Header object created by Connect-CTXAPI; contains authentication and request headers.



.EXAMPLE
$machines = Get-CTXAPI_Machine -APIHeader $APIHeader
Retrieves all machines and stores them for reuse.

.EXAMPLE
Get-CTXAPI_Machine -APIHeader $APIHeader | Select-Object DnsName, IPAddress, OSType, RegistrationState
Lists key machine fields for quick inspection.

.INPUTS
None. Parameters are not accepted from the pipeline.

.OUTPUTS
PSCustomObject[]
Array of machine objects returned from the CVAD Manage API.

.LINK
https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Machine

#>

function Get-CTXAPI_Machine {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Machine')]
    [Alias('Get-CTXAPI_Machines')]
    [OutputType([psobject[]])]
    param(
        [Parameter(Mandatory = $true)]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader,
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('DNSName', 'Id')]
        [string[]]$Name
    )

    if ($PSBoundParameters.ContainsKey('Name')) {
        [System.Collections.generic.List[PSObject]]$MachineObject = @()
        $name | ForEach-Object {
            $NamerequestUri = [string]::Format('https://api.cloud.com/cvad/manage/Machines/{0}', $_)
            try {
                Write-Verbose "Retrieving machine details for: $_"
                $Nameresponse = Invoke-RestMethod -Uri $NamerequestUri -Method GET -Headers $APIHeader.headers
                $MachineObject.Add($Nameresponse)
            } catch {
                Write-Warning "Failed to retrieve machine details for: $_."
            }            
        }
        return $MachineObject
    } else {
        Write-Verbose 'No Name filter applied; retrieving all machines.'
    
        $requestUri = 'https://api.cloud.com/cvad/manage/Machines?limit=1000'
        $data = Get-CTXAPIDatapages -APIHeader $apiHeader -uri $requestUri
        return $data

    }
} #end Function
 
Export-ModuleMember -Function Get-CTXAPI_Machine
#endregion
 
#region Get-CTXAPI_MachineCatalog.ps1
######## Function 9 of 19 ##################
# Function:         Get-CTXAPI_MachineCatalog
# Module:           CTXCloudApi
# ModuleVersion:    0.1.33
# Author:           Pierre Smit
# Company:          Private
# CreatedOn:        11/26/2024 11:40:43 AM
# ModifiedOn:       2/22/2026 1:21:20 PM
# Synopsis:         Returns details about Machine Catalogs (handles pagination).
#############################################
 
<#
.SYNOPSIS
Returns details about Machine Catalogs (handles pagination).

.DESCRIPTION
Returns details about Machine Catalogs from Citrix Cloud CVAD.

.PARAMETER APIHeader
Header object created by Connect-CTXAPI; contains authentication and request headers.

.EXAMPLE
$MachineCatalogs = Get-CTXAPI_MachineCatalog -APIHeader $APIHeader
Retrieves all machine catalogs and stores them for reuse.

.EXAMPLE
Get-CTXAPI_MachineCatalog -APIHeader $APIHeader | Select-Object Name, SessionSupport, TotalCount, IsPowerManaged
Lists key catalog fields including session support, total machines, and power management.

.INPUTS
None. Parameters are not accepted from the pipeline.

.OUTPUTS
PSCustomObject[]
Array of machine catalog objects returned from the CVAD Manage API.

.LINK
https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_MachineCatalog

#>

function Get-CTXAPI_MachineCatalog {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_MachineCatalog')]
    [Alias('Get-CTXAPI_MachineCatalogs')]
    [OutputType([psobject[]])]
    param(
        [Parameter(Mandatory = $true)]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader	)


    $requestUri = 'https://api.cloud.com/cvad/manage/MachineCatalogs?limit=1000'
    $data = Get-CTXAPIDatapages -APIHeader $APIHeader -uri $requestUri
    return $data
} #end Function
 
Export-ModuleMember -Function Get-CTXAPI_MachineCatalog
#endregion
 
#region Get-CTXAPI_MonitorData.ps1
######## Function 10 of 19 ##################
# Function:         Get-CTXAPI_MonitorData
# Module:           CTXCloudApi
# ModuleVersion:    0.1.33
# Author:           Pierre Smit
# Company:          Private
# CreatedOn:        11/26/2024 11:41:30 AM
# ModifiedOn:       2/25/2026 8:55:31 AM
# Synopsis:         Collect Monitoring OData for other reports.
#############################################
 
<#
.SYNOPSIS
Collect Monitoring OData for other reports.

.DESCRIPTION
Collects Citrix Monitor OData entities for a specified time window and returns a composite object used by reporting cmdlets.

.PARAMETER APIHeader
Header object created by Connect-CTXAPI; contains authentication and request headers.

.PARAMETER LastHours
Relative time window in hours (e.g., 24, 48). When specified, BeginDate is now and EndDate is now minus LastHours.

.PARAMETER BeginDate
Start of the time window when specifying an explicit range.

.PARAMETER EndDate
End of the time window when specifying an explicit range.

.PARAMETER MonitorDetails
One or more OData entity names to include. Default is All.

.EXAMPLE
$MonitorData = Get-CTXAPI_MonitorData -APIHeader $APIHeader -LastHours 24
Collects the last 24 hours of Monitor OData and returns a CTXMonitorData object.

.EXAMPLE
Get-CTXAPI_MonitorData -APIHeader $APIHeader -BeginDate (Get-Date).AddDays(-2) -EndDate (Get-Date).AddDays(-1) -MonitorDetails Connections,Session
Collects data for a specific date range and includes only Connections and Session entities.

.EXAMPLE
Get-CTXAPI_MonitorData -APIHeader $APIHeader -LastHours 48 | Select-Object -ExpandProperty Connections
Expands and lists connection records for the past 48 hours.

.INPUTS
None

.OUTPUTS
System.Object (PSTypeName: CTXMonitorData)
Composite PSCustomObject containing Monitor OData entities used by reporting cmdlets.

.LINK
https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_MonitorData
#>

function Get-CTXAPI_MonitorData {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_MonitorData')]
    param(
        [Parameter(Mandatory = $true)]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $false, ParameterSetName = 'hours')]
        [int]$LastHours,
        [Parameter(Mandatory = $false, ParameterSetName = 'specific')]
        [datetime]$BeginDate,
        [Parameter(Mandatory = $false, ParameterSetName = 'specific')]
        [datetime]$EndDate,
        [ValidateSet('ApplicationActivitySummaries', 
            'ApplicationActivitySummaries',
            'ApplicationInstances',
            'Applications',
            'Catalogs',
            'ConnectionFailureLogs',
            'ConnectionFailureCategories',
            'Connections',
            'DesktopGroups',
            'DesktopOSDesktopSummaries',
            'FailureLogSummaries',
            'Hypervisors',
            'LogOnMetrics',
            'LogOnSummaries',
            'MachineCosts',
            'MachineCostSavingsSummaries',
            'MachineFailureLogs',
            'MachineMetric',
            'Machines',
            'ResourceUtilization',
            'ResourceUtilizationSummary',
            'ServerOSDesktopSummaries',
            'Session',
            'SessionActivitySummaries',
            'SessionAutoReconnects',
            'SessionMetrics',
            'SessionMetricsLatest',
            'Users',
            'All')]
        [string[]]$MonitorDetails = 'All'
    )
    
    Write-Verbose "[$(Get-Date -Format HH:mm:ss) BEGIN] Starting $($myinvocation.mycommand)"
    if ($PSCmdlet.ParameterSetName -eq 'hours' -and $null -ne $LastHours) {
        $BeginDate = Get-Date
        $EndDate = (Get-Date).AddHours(-$LastHours)
    } elseif ($PSCmdlet.ParameterSetName -eq 'specific') {
        if ($null -eq $BeginDate) { throw 'BeginDate is required when LastHours is not specified' }
        if ($null -eq $EndDate) { throw 'EndDate is required when LastHours is not specified' }
    } else {
        throw 'Specify either -LastHours or both -BeginDate and -EndDate.'
    }

    $BeginDateStr = $BeginDate.ToString('yyyy-MM-ddTHH:mm:ss.ffffZ')
    $EndDateStr = $EndDate.ToString('yyyy-MM-ddTHH:mm:ss.ffffZ')

    # Initialize all potential datasets to avoid strict-mode errors when not selected
    $ApplicationActivitySummaries = $null
    $ApplicationInstances = $null
    $Applications = $null
    $Catalogs = $null
    $ConnectionFailureLogs = $null
    $ConnectionFailureCategories = $null
    $Connections = $null
    $DesktopGroups = $null
    $DesktopOSDesktopSummaries = $null
    $FailureLogSummaries = $null
    $Hypervisors = $null
    $LogOnMetrics = $null
    $LogOnSummaries = $null
    $MachineCosts = $null
    $MachineCostSavingsSummaries = $null
    $MachineFailureLogs = $null
    $MachineMetric = $null
    $Machines = $null
    $ResourceUtilization = $null
    $ResourceUtilizationSummary = $null
    $ServerOSDesktopSummaries = $null
    $SessionActivitySummaries = $null
    $SessionAutoReconnects = $null
    $Sessions = $null
    $SessionMetrics = $null
    $SessionMetricsLatest = $null
    $Users = $null
    
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'ApplicationActivitySummaries')) { $ApplicationActivitySummaries = Export-Odata -URI ('https://api.cloud.com/monitorodata/ApplicationActivitySummaries?$filter=(Granularity eq 60 and SummaryDate ge ' + $EndDateStr + ' and SummaryDate le ' + $BeginDateStr + ' )') -headers $APIHeader.headers }
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'ApplicationInstances')) { $ApplicationInstances = Export-Odata -URI ('https://api.cloud.com/monitorodata/ApplicationInstances?$filter=(ModifiedDate ge ' + $EndDateStr + ' and ModifiedDate le ' + $BeginDateStr + ' )') -headers $APIHeader.headers }
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'Applications')) {$Applications = Export-Odata -URI ('https://api.cloud.com/monitorodata/Applications') -headers $APIHeader.headers                                                                                                                                }
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'Catalogs')) {$Catalogs = Export-Odata -URI ('https://api.cloud.com/monitorodata/Catalogs') -headers $APIHeader.headers}
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'ConnectionFailureLogs')) {$ConnectionFailureLogs = Export-Odata -URI ('https://api.cloud.com/monitorodata/ConnectionFailureLogs?$filter=(ModifiedDate ge ' + $EndDateStr + ' and ModifiedDate le ' + $BeginDateStr + ' )') -headers $APIHeader.headers}
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'ConnectionFailureCategories')) {$ConnectionFailureCategories = Export-Odata -URI ('https://api.cloud.com/monitorodata/ConnectionFailureCategories') -headers $APIHeader.headers}
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'Connections')) {$Connections = Export-Odata -URI ('https://api.cloud.com/monitorodata/Connections?$filter=(ModifiedDate ge ' + $EndDateStr + ' and ModifiedDate le ' + $BeginDateStr + ' )') -headers $APIHeader.headers}
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'DesktopGroups')) {$DesktopGroups = Export-Odata -URI ('https://api.cloud.com/monitorodata/DesktopGroups') -headers $APIHeader.headers}
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'DesktopOSDesktopSummaries')) {$DesktopOSDesktopSummaries = Export-Odata -URI ('https://api.cloud.com/monitorodata/DesktopOSDesktopSummaries?$filter=(Granularity eq 60 and SummaryDate ge ' + $EndDateStr + ' and SummaryDate le ' + $BeginDateStr + ' )') -headers $APIHeader.headers}
    #TODO - create report on FailureLogSummaries
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'FailureLogSummaries')) {$FailureLogSummaries = Export-Odata -URI ('https://api.cloud.com/monitorodata/FailureLogSummaries?$filter=(Granularity eq 60 and SummaryDate ge ' + $EndDateStr + ' and SummaryDate le ' + $BeginDateStr + ' )') -headers $APIHeader.headers}
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'Hypervisors')) {$Hypervisors = Export-Odata -URI ('https://api.cloud.com/monitorodata/Hypervisors') -headers $APIHeader.headers}
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'LogOnMetrics')) {$LogOnMetrics = Export-Odata -URI ('https://api.cloud.com/monitorodata/LogOnMetrics?$filter=(UserInitStartDate ge ' + $EndDateStr + ' and UserInitStartDate le ' + $BeginDateStr + ' )') -headers $APIHeader.headers}
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'LogOnSummaries')) {$LogOnSummaries = Export-Odata -URI ('https://api.cloud.com/monitorodata/LogOnSummaries?$filter=(Granularity eq 60 and SummaryDate ge ' + $EndDateStr + ' and SummaryDate le ' + $BeginDateStr + ' )') -headers $APIHeader.headers}
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'MachineCosts')) {$MachineCosts = Export-Odata -URI ('https://api.cloud.com/monitorodata/MachineCosts') -headers $APIHeader.headers}
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'MachineCostSavingsSummaries')) {$MachineCostSavingsSummaries = Export-Odata -URI ('https://api.cloud.com/monitorodata/MachineCostSavingsSummaries?$filter=(SummaryDate ge ' + $EndDateStr + ' and SummaryDate le ' + $BeginDateStr + ' )') -headers $APIHeader.headers}
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'MachineFailureLogs')) {$MachineFailureLogs = Export-Odata -URI ('https://api.cloud.com/monitorodata/MachineFailureLogs?$filter=(ModifiedDate ge ' + $EndDateStr + ' and ModifiedDate le ' + $BeginDateStr + ' )') -headers $APIHeader.headers}
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'MachineMetric')) {$MachineMetric = Export-Odata -URI ('https://api.cloud.com/monitorodata/MachineMetric?$filter=(CollectedDate ge ' + $EndDateStr + ' and CollectedDate le ' + $BeginDateStr + ' )') -headers $APIHeader.headers}
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'Machines')) {$Machines = Export-Odata -URI ('https://api.cloud.com/monitorodata/Machines') -headers $APIHeader.headers}
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'ResourceUtilization')) {$ResourceUtilization = Export-Odata -URI ('https://api.cloud.com/monitorodata/ResourceUtilization?$filter=(ModifiedDate ge ' + $EndDateStr + ' and ModifiedDate le ' + $BeginDateStr + ' )') -headers $APIHeader.headers}
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'ResourceUtilizationSummary')) {$ResourceUtilizationSummary = Export-Odata -URI ('https://api.cloud.com/monitorodata/ResourceUtilizationSummary?$filter=(Granularity eq 60 and SummaryDate ge ' + $EndDateStr + ' and SummaryDate le ' + $BeginDateStr + ' )') -headers $APIHeader.headers}
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'ServerOSDesktopSummaries')) {$ServerOSDesktopSummaries = Export-Odata -URI ('https://api.cloud.com/monitorodata/ServerOSDesktopSummaries?$filter=(Granularity eq 60 and SummaryDate ge ' + $EndDateStr + ' and SummaryDate le ' + $BeginDateStr + ' )') -headers $APIHeader.headers}
    ##TODO - create a report on SessionActivitySummaries
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'SessionActivitySummaries')) {$SessionActivitySummaries = Export-Odata -URI ('https://api.cloud.com/monitorodata/SessionActivitySummaries?$filter=(Granularity eq 60 and SummaryDate ge ' + $EndDateStr + ' and SummaryDate le ' + $BeginDateStr + ' )') -headers $APIHeader.headers}
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'SessionAutoReconnects')) {$SessionAutoReconnects = Export-Odata -URI ('https://api.cloud.com/monitorodata/SessionAutoReconnects?$filter=(CreatedDate ge ' + $EndDateStr + ' and CreatedDate le ' + $BeginDateStr + ' )') -headers $APIHeader.headers}
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'Sessions')) {$Sessions = Export-Odata -URI ('https://api.cloud.com/monitorodata/Sessions?$filter=(ModifiedDate ge ' + $EndDateStr + ' and ModifiedDate le ' + $BeginDateStr + ' )') -headers $APIHeader.headers}
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'SessionMetrics')) {$SessionMetrics = Export-Odata -URI ('https://api.cloud.com/monitorodata/SessionMetrics?$filter=(CollectedDate ge ' + $EndDateStr + ' and CollectedDate le ' + $BeginDateStr + ' )') -headers $APIHeader.headers}
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'SessionMetricsLatest')) {$SessionMetricsLatest = Export-Odata -URI ('https://api.cloud.com/monitorodata/SessionMetricsLatest?$filter=(CreatedDate ge ' + $EndDateStr + ' and CreatedDate le ' + $BeginDateStr + ' )') -headers $APIHeader.headers -verbose}
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'Users')) {$Users = Export-Odata -URI ('https://api.cloud.com/monitorodata/Users') -headers $APIHeader.headers}

    Write-Verbose "[$(Get-Date -Format HH:mm:ss)] Building composite object with retrieved datasets..."
    $datasets = [pscustomobject]@{
        PSTypeName = 'CTXMonitorData'
    }
    if ($null -ne $ApplicationActivitySummaries) { $datasets | Add-Member -NotePropertyName 'ApplicationActivitySummaries' -NotePropertyValue $ApplicationActivitySummaries }
    if ($null -ne $ApplicationInstances) { $datasets | Add-Member -NotePropertyName 'ApplicationInstances' -NotePropertyValue $ApplicationInstances }
    if ($null -ne $Applications) { $datasets | Add-Member -NotePropertyName 'Applications' -NotePropertyValue $Applications }
    if ($null -ne $Catalogs) { $datasets | Add-Member -NotePropertyName 'Catalogs' -NotePropertyValue $Catalogs }
    if ($null -ne $ConnectionFailureLogs) { $datasets | Add-Member -NotePropertyName 'ConnectionFailureLogs' -NotePropertyValue $ConnectionFailureLogs }
    if ($null -ne $ConnectionFailureCategories) { $datasets | Add-Member -NotePropertyName 'ConnectionFailureCategories' -NotePropertyValue $ConnectionFailureCategories }
    if ($null -ne $Connections) { $datasets | Add-Member -NotePropertyName 'Connections' -NotePropertyValue $Connections }
    if ($null -ne $DesktopGroups) { $datasets | Add-Member -NotePropertyName 'DesktopGroups' -NotePropertyValue $DesktopGroups }
    if ($null -ne $DesktopOSDesktopSummaries) { $datasets | Add-Member -NotePropertyName 'DesktopOSDesktopSummaries' -NotePropertyValue $DesktopOSDesktopSummaries }
    if ($null -ne $FailureLogSummaries) { $datasets | Add-Member -NotePropertyName 'FailureLogSummaries' -NotePropertyValue $FailureLogSummaries }
    if ($null -ne $Hypervisors) { $datasets | Add-Member -NotePropertyName 'Hypervisors' -NotePropertyValue $Hypervisors }
    if ($null -ne $LogOnMetrics) { $datasets | Add-Member -NotePropertyName 'LogOnMetrics' -NotePropertyValue $LogOnMetrics }
    if ($null -ne $LogOnSummaries) { $datasets | Add-Member -NotePropertyName 'LogOnSummaries' -NotePropertyValue $LogOnSummaries }
    if ($null -ne $MachineCosts) { $datasets | Add-Member -NotePropertyName 'MachineCosts' -NotePropertyValue $MachineCosts }
    if ($null -ne $MachineCostSavingsSummaries) { $datasets | Add-Member -NotePropertyName 'MachineCostSavingsSummaries' -NotePropertyValue $MachineCostSavingsSummaries }
    if ($null -ne $MachineFailureLogs) { $datasets | Add-Member -NotePropertyName 'MachineFailureLogs' -NotePropertyValue $MachineFailureLogs }
    if ($null -ne $MachineMetric) { $datasets | Add-Member -NotePropertyName 'MachineMetric' -NotePropertyValue $MachineMetric }
    if ($null -ne $Machines) { $datasets | Add-Member -NotePropertyName 'Machines' -NotePropertyValue $Machines }
    if ($null -ne $ResourceUtilization) { $datasets | Add-Member -NotePropertyName 'ResourceUtilization' -NotePropertyValue $ResourceUtilization }
    if ($null -ne $ResourceUtilizationSummary) { $datasets | Add-Member -NotePropertyName 'ResourceUtilizationSummary' -NotePropertyValue $ResourceUtilizationSummary }
    if ($null -ne $ServerOSDesktopSummaries) { $datasets | Add-Member -NotePropertyName 'ServerOSDesktopSummaries' -NotePropertyValue $ServerOSDesktopSummaries }
    if ($null -ne $SessionActivitySummaries) { $datasets | Add-Member -NotePropertyName 'SessionActivitySummaries' -NotePropertyValue $SessionActivitySummaries }
    if ($null -ne $SessionAutoReconnects) { $datasets | Add-Member -NotePropertyName 'SessionAutoReconnects' -NotePropertyValue $SessionAutoReconnects }
    if ($null -ne $Sessions) { $datasets | Add-Member -NotePropertyName 'Sessions' -NotePropertyValue $Sessions }
    if ($null -ne $SessionMetrics) { $datasets | Add-Member -NotePropertyName 'SessionMetrics' -NotePropertyValue $SessionMetrics }
    if ($null -ne $SessionMetricsLatest) { $datasets | Add-Member -NotePropertyName 'SessionMetricsLatest' -NotePropertyValue $SessionMetricsLatest }
    if ($null -ne $Users) { $datasets | Add-Member -NotePropertyName 'Users' -NotePropertyValue $Users }

    return $datasets
} #end Function


#MachineCostSavingsSummaries  = Export-Odata -URI ('https://api.cloud.com/monitorodata/MachineCostSavingsSummaries?$apply=aggregate(TotalAmountSaved with sum as TotalAmountSavedSum)') -headers $APIHeader.headers
 
Export-ModuleMember -Function Get-CTXAPI_MonitorData
#endregion
 
#region Get-CTXAPI_ResourceLocation.ps1
######## Function 11 of 19 ##################
# Function:         Get-CTXAPI_ResourceLocation
# Module:           CTXCloudApi
# ModuleVersion:    0.1.33
# Author:           Pierre Smit
# Company:          Private
# CreatedOn:        11/26/2024 11:41:33 AM
# ModifiedOn:       2/18/2026 1:45:33 PM
# Synopsis:         Returns cloud Resource Locations.
#############################################
 
<#
.SYNOPSIS
Returns cloud Resource Locations.

.DESCRIPTION
Returns Citrix Cloud Resource Locations for the current customer.

.PARAMETER APIHeader
Header object created by Connect-CTXAPI; contains authentication and request headers.

.EXAMPLE
Get-CTXAPI_ResourceLocation -APIHeader $APIHeader
Lists all Resource Locations for the tenant.

.EXAMPLE
Get-CTXAPI_ResourceLocation -APIHeader $APIHeader | Select-Object name, description, id
Selects key fields from the returned items.

.INPUTS
None. Parameters are not accepted from the pipeline.

.OUTPUTS
PSCustomObject[]
Array of resource location objects returned from the Registry API.

.LINK
https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_ResourceLocation

#>

function Get-CTXAPI_ResourceLocation {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_ResourceLocation')]
    [Alias('Get-CTXAPI_ResourceLocations')]
    [OutputType([psobject[]])]
    param(
        [Parameter(Mandatory = $true)]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader)


    (Invoke-RestMethod -Uri "https://registry.citrixworkspacesapi.net/$($APIHeader.headers.'Citrix-CustomerId')/resourcelocations" -Headers $APIHeader.headers).items

} #end Function
 
Export-ModuleMember -Function Get-CTXAPI_ResourceLocation
#endregion
 
#region Get-CTXAPI_Session.ps1
######## Function 12 of 19 ##################
# Function:         Get-CTXAPI_Session
# Module:           CTXCloudApi
# ModuleVersion:    0.1.33
# Author:           Pierre Smit
# Company:          Private
# CreatedOn:        11/26/2024 11:41:28 AM
# ModifiedOn:       2/22/2026 1:21:52 PM
# Synopsis:         Returns details about current sessions (handles pagination).
#############################################
 
<#
.SYNOPSIS
Returns details about current sessions (handles pagination).

.DESCRIPTION
Returns details about current sessions from Citrix Cloud CVAD.

.PARAMETER APIHeader
Header object created by Connect-CTXAPI; contains authentication and request headers.

.EXAMPLE
Get-CTXAPI_Session -APIHeader $APIHeader
Retrieves and lists current session objects.

.EXAMPLE
Get-CTXAPI_Session -APIHeader $APIHeader | Select-Object UserName, DnsName, LogOnDuration, ConnectionState
Shows key fields for each session.

.INPUTS
None. Parameters are not accepted from the pipeline.

.OUTPUTS
PSCustomObject[]
Array of session objects returned from the CVAD Manage API.

.LINK
https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Session

#>

function Get-CTXAPI_Session {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Session')]
    [Alias('Get-CTXAPI_Sessions')]
    [OutputType([psobject[]])]
    param(
        [Parameter(Mandatory = $true)]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader
    )
    $requestUri = 'https://api.cloud.com/cvad/manage/Sessions?limit=1000'
    $data = Get-CTXAPIDatapages -APIHeader $APIHeader -uri $requestUri
    return $data
} #end Function
 
Export-ModuleMember -Function Get-CTXAPI_Session
#endregion
 
#region Get-CTXAPI_SiteDetail.ps1
######## Function 13 of 19 ##################
# Function:         Get-CTXAPI_SiteDetail
# Module:           CTXCloudApi
# ModuleVersion:    0.1.33
# Author:           Pierre Smit
# Company:          Private
# CreatedOn:        11/26/2024 11:40:39 AM
# ModifiedOn:       2/18/2026 1:45:56 PM
# Synopsis:         Returns details about your CVAD site.
#############################################
 
<#
.SYNOPSIS
Returns details about your CVAD site.

.DESCRIPTION
Returns details about your CVAD site (farm) from Citrix Cloud.

.PARAMETER APIHeader
Header object created by Connect-CTXAPI; contains authentication and request headers.

.EXAMPLE
Get-CTXAPI_SiteDetail -APIHeader $APIHeader
Returns the site details for the current `Citrix-InstanceId`.

.EXAMPLE
Get-CTXAPI_SiteDetail -APIHeader $APIHeader | Select-Object Name, FunctionalLevel, LicensingMode
Selects key fields from the site object.

.INPUTS
None. Parameters are not accepted from the pipeline.

.OUTPUTS
PSCustomObject
Site detail object returned from the CVAD Manage API.

.LINK
https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_SiteDetail

#>

function Get-CTXAPI_SiteDetail {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_SiteDetail')]
    [Alias('Get-CTXAPI_SiteDetails')]
    [OutputType([psobject])]
    param(
        [Parameter(Mandatory = $true)]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader	)

    Invoke-RestMethod -Uri "https://api.cloud.com/cvad/manage/Sites/$($APIHeader.headers.'Citrix-InstanceId')" -Method get -Headers $APIHeader.headers



} #end Function
 
Export-ModuleMember -Function Get-CTXAPI_SiteDetail
#endregion
 
#region Get-CTXAPI_VDAUptime.ps1
######## Function 14 of 19 ##################
# Function:         Get-CTXAPI_VDAUptime
# Module:           CTXCloudApi
# ModuleVersion:    0.1.33
# Author:           Pierre Smit
# Company:          Private
# CreatedOn:        11/26/2024 11:40:45 AM
# ModifiedOn:       2/23/2026 7:33:57 AM
# Synopsis:         
Get-CTXAPI_VDAUptime [-APIHeader] <CTXAPIHeaderObject> [[-Export] <string>] [[-ReportPath] <DirectoryInfo>] [<CommonParameters>]

#############################################
 
<#
.SYNOPSIS
Calculate VDA uptime and export or return results.

.DESCRIPTION
Calculates VDA machine uptime based on registration/deregistration timestamps.

.PARAMETER APIHeader
Header object created by Connect-CTXAPI; contains authentication and request headers.

.PARAMETER Export
Destination/output for the report. Supported values: Host, Excel, HTML. Default: Host.

.PARAMETER ReportPath
Destination folder for the exported report.

.EXAMPLE
Get-CTXAPI_VDAUptime -APIHeader $APIHeader -Export Excel -ReportPath C:\temp\
Exports an Excel workbook (VDAUptime-<yyyy.MM.dd-HH.mm>.xlsx) with uptime details.

.EXAMPLE
Get-CTXAPI_VDAUptime -APIHeader $APIHeader -Export HTML -ReportPath C:\Temp
Generates an HTML report titled "Citrix Uptime".

.EXAMPLE
Get-CTXAPI_VDAUptime -APIHeader $APIHeader | Select-Object DnsName, Days, OnlineSince, SummaryState
Returns objects to the host and selects common fields for quick inspection.

.INPUTS
None. Parameters are not accepted from the pipeline.

.OUTPUTS
psobject[]
When Export is Host: array of uptime objects; when Export is Excel/HTML: no output objects and files are written to ReportPath.

.LINK
https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_VDAUptime

#>


function Get-CTXAPI_VDAUptime {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_VDAUptime')]
    param(
        [Parameter(Mandatory = $true)]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader,
        [Parameter(Mandatory = $false)]
        [ValidateSet('Host', 'Excel', 'HTML')]
        [string]$Export = 'Host',
        [Parameter(Mandatory = $false)]
        [ValidateScript( { (Test-Path $_) })]
        [System.IO.DirectoryInfo]$ReportPath = $env:temp)

    Write-Verbose "Starting Get-CTXAPI_VDAUptime with Export: $Export and ReportPath: $ReportPath"
    try {
        [System.Collections.generic.List[PSObject]]$complist = @()
        Write-Verbose 'Retrieving machines from Get-CTXAPI_Machine'
        $machines = Get-CTXAPI_Machine -APIHeader $APIHeader
        Write-Verbose ('Retrieved {0} machines.' -f $machines.Count)

        foreach ($machine in $machines) {
            try {
                Write-Verbose "Processing machine: $($machine.DnsName)"
                # Safely read and convert the last deregistration/registration time
                if ($machine.PSObject.Properties['LastDeregistrationTime'] -and -not [string]::IsNullOrWhiteSpace($machine.LastDeregistrationTime)) {
                    $lastBootTime = [Datetime]$machine.LastDeregistrationTime
                    Write-Verbose "Using LastDeregistrationTime: $lastBootTime"
                } elseif ($machine.PSObject.Properties['LastRegistrationTime'] -and -not [string]::IsNullOrWhiteSpace($machine.LastRegistrationTime)) {
                    $lastBootTime = [Datetime]$machine.LastRegistrationTime
                    Write-Verbose "Using LastRegistrationTime: $lastBootTime"
                } else {
                    $lastBootTime = $null
                    Write-Verbose 'No valid boot time found.'
                }

                # Compute uptime only when we have a valid start time
                if ($null -ne $lastBootTime) {
                    $Uptime = New-TimeSpan -Start $lastBootTime -End (Get-Date)
                    Write-Verbose "Calculated uptime: $($Uptime.Days) days."
                } else {
                    $Uptime = $null
                }
            } catch { Write-Warning "Error: `n`tMessage:$($_.Exception.Message)" } 

            $tmp = [PSCustomObject]@{
                DnsName           = $machine.DnsName
                AgentVersion      = $machine.AgentVersion
                MachineCatalog    = if ($machine.MachineCatalog -and $machine.MachineCatalog.PSObject.Properties['Name']) { $machine.MachineCatalog.Name } else { $null }
                DeliveryGroup     = if ($machine.DeliveryGroup -and $machine.DeliveryGroup.PSObject.Properties['Name']) { $machine.DeliveryGroup.Name } else { $null }
                InMaintenanceMode = $machine.InMaintenanceMode
                IPAddress         = $machine.IPAddress
                OSType            = $machine.OSType
                ProvisioningType  = $machine.ProvisioningType
                SummaryState      = $machine.SummaryState
                FaultState        = $machine.FaultState
                Days              = if ($null -ne $Uptime) { $Uptime.Days } else { $null }
                OnlineSince       = if ($null -eq $lastBootTime) { $null } else { $lastBootTime }
            }
            Write-Verbose ('Uptime object: {0}' -f ($tmp | ConvertTo-Json -Compress))
            $complist.Add($tmp)
        }
    } catch { Write-Warning "Date calculation failed. $($_.Exception.Message)" }

    Write-Verbose ('Total uptime objects: {0}' -f $complist.Count)
    if ($Export -eq 'Excel') { 
        $ExcelOptions = @{
            Path             = $ReportPath + '\VDAUptime-' + (Get-Date -Format yyyy.MM.dd-HH.mm) + '.xlsx'
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
        $complist | Export-Excel -Title VDAUptime -WorksheetName VDAUptime @ExcelOptions
    }
    if ($Export -eq 'HTML') {
        Write-Verbose 'Exporting to HTML view.'
        $complist | Out-HtmlView -DisablePaging -Title 'Citrix Uptime' -HideFooter -FixedHeader
    }
    if ($Export -eq 'Host') {
        Write-Verbose 'Returning uptime objects to host.'
        $complist
    }
} #end Function


 
Export-ModuleMember -Function Get-CTXAPI_VDAUptime
#endregion
 
#region Get-CTXAPI_Zone.ps1
######## Function 15 of 19 ##################
# Function:         Get-CTXAPI_Zone
# Module:           CTXCloudApi
# ModuleVersion:    0.1.33
# Author:           Pierre Smit
# Company:          Private
# CreatedOn:        11/26/2024 11:40:48 AM
# ModifiedOn:       2/22/2026 1:22:32 PM
# Synopsis:         Returns Zone details (handles pagination).
#############################################
 
<#
.SYNOPSIS
Returns Zone details (handles pagination).

.DESCRIPTION
Returns Zone details from Citrix Cloud CVAD.

.PARAMETER APIHeader
Header object created by Connect-CTXAPI; contains authentication and request headers.

.EXAMPLE
 Get-CTXAPI_Zone -APIHeader $APIHeader
Lists all zones for the tenant.

.EXAMPLE
Get-CTXAPI_Zone -APIHeader $APIHeader | Select-Object Name, Enabled, Description
Shows key fields for each zone.

.INPUTS
None. Parameters are not accepted from the pipeline.

.OUTPUTS
psobject[]
Array of zone objects returned from the CVAD Manage API.

.LINK
https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Zone

#>

function Get-CTXAPI_Zone {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Zone')]
    [Alias('Get-CTXAPI_Zones')]
    [OutputType([psobject[]])]
    param(
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader
    )

    $requestUri = 'https://api.cloud.com/cvad/manage/Zones?limit=1000'
    $data = Get-CTXAPIDatapages -APIHeader $APIHeader -uri $requestUri
    return $data
} #end Function
 
Export-ModuleMember -Function Get-CTXAPI_Zone
#endregion
 
#region New-CTXAPI_Machine.ps1
######## Function 16 of 19 ##################
# Function:         New-CTXAPI_Machine
# Module:           CTXCloudApi
# ModuleVersion:    0.1.33
# Author:           Pierre Smit
# Company:          Private
# CreatedOn:        2/19/2026 12:01:45 PM
# ModifiedOn:       2/22/2026 2:00:02 PM
# Synopsis:         Creates and adds new machines to a Citrix Cloud Delivery Group.
#############################################
 
<#
.SYNOPSIS
Creates and adds new machines to a Citrix Cloud Delivery Group.

.DESCRIPTION
This function provisions one or more new machines in a specified Machine Catalog and adds them to a specified Delivery Group in Citrix Cloud using the CTXCloudApi module. The function supports verbose output for detailed process tracking.

.PARAMETER APIHeader
The authentication header object returned by Connect-CTXAPI, required for all API calls.

.PARAMETER MachineCatalogName
The name of the Machine Catalog where new machines will be created.

.PARAMETER DeliveryGroupName
The name of the Delivery Group to which the new machines will be added.

.PARAMETER AmountOfMachines
The number of machines to create and add to the Delivery Group.

.EXAMPLE
New-CTXAPI_Machine -APIHeader $header -MachineCatalogName "Win10-Catalog" -DeliveryGroupName "Win10-Users" -AmountOfMachines 2 -Verbose

Creates 2 new machines in the "Win10-Catalog" Machine Catalog and adds them to the "Win10-Users" Delivery Group, showing verbose output.

.NOTES

.LINK
https://smitpi.github.io/CTXCloudApi/New-CTXAPI_Machine
#>
function New-CTXAPI_Machine {
	[Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/New-CTXAPI_Machine', SupportsShouldProcess = $true, SupportsPaging = $false, ConfirmImpact = 'None')]
	[OutputType([System.Object[]])]

	param(
		[Parameter(Mandatory = $true)]
		[PSTypeName('CTXAPIHeaderObject')]$APIHeader,
		[Parameter(Mandatory = $true)]
		[string]$MachineCatalogName,
		[Parameter(Mandatory = $true)]
		[string]$DeliveryGroupName,
		[Parameter(Mandatory = $true)]
		[int]$AmountOfMachines
	)

	Write-Verbose "Retrieving Machine Catalog ID for: $MachineCatalogName"
	$catid = Get-CTXAPI_MachineCatalog -APIHeader $APIHeader | Where-Object Name -EQ $MachineCatalogName
	Write-Verbose "Machine Catalog ID: $($catid.id)"
	$requestUri = [string]::Format('https://api.cloud.com/cvad/manage/MachineCatalogs/{0}/Machines?async=true', $catid.id)

	Write-Verbose 'Building request body for machine creation.'
	$body = [pscustomobject]@{
		MachineName                 = $null
		MachineAccountCreationRules = $catid.ProvisioningScheme.MachineAccountCreationRules
	} | ConvertTo-Json -Depth 10

	for ($i = 1; $i -le $AmountOfMachines; $i++) {
		Write-Verbose "Starting creation of machine $i of $AmountOfMachines."
		try {
			Write-Verbose "Invoking REST method to create machine. URI: $requestUri"
			Invoke-RestMethod -Uri $requestUri -Method POST -Headers $APIHeader.headers -Body $body
			Start-Sleep -Seconds 5
			$Jobrequest = [string]::Format('https://api.cloud.com/cvad/manage/Jobs')
			Write-Verbose "Checking job status at: $Jobrequest"
			$jobresponse = Invoke-RestMethod -Uri $Jobrequest -Method get -Headers $APIHeader.headers
			$topreponce = ($jobresponse.Items | Sort-Object -Property CreationTime -Descending)[0]
			Write-Verbose "Job state: $($topreponce.status). Waiting for completion... Number $i"
			while ($topreponce.status -eq 'InProgress') {
				Write-Verbose "Job state: $($topreponce.status). Waiting for completion... Number $i"
				Start-Sleep -Seconds 5
				$Jobrequest = [string]::Format('https://api.cloud.com/cvad/manage/Jobs/{0}', $topreponce.id)
				$topreponce = Invoke-RestMethod -Uri $Jobrequest -Method get -Headers $APIHeader.headers
			}
			Write-Verbose 'Successfully created machine.'
		} catch {
			Write-Error "Failed to create machine: Error: $_"
		}
	}
	Write-Verbose "Retrieving Delivery Group: $DeliveryGroupName"
	$DeliveryGroup = Get-CTXAPI_DeliveryGroup -APIHeader $APIHeader | Where-Object Name -EQ $DeliveryGroupName
	Write-Verbose 'Retrieving all machines.'
	
	$mac = Get-CTXAPI_Machine -APIHeader $APIHeader
	$newmachines = $mac | Where-Object {($_.MachineCatalog.id -eq $catid.id) -and ($null -eq $_.DeliveryGroup)}

	Write-Verbose ('Found {0} new machines to add to Delivery Group.' -f ($newmachines | Measure-Object | Select-Object -ExpandProperty Count))
	[System.Collections.generic.List[PSObject]]$ResultObject = @()
	if ($newmachines) {
		$newmachines | ForEach-Object {
			Write-Verbose "Assigning machine $($_.Name) to Delivery Group $($DeliveryGroup.Name)"
			$deliveryobject = [pscustomobject]@{
				MachineCatalog        = $catid.FullName
				AssignMachinesToUsers = @(
					@{
						Machine = $_.Name
					}
				)
			} | ConvertTo-Json -Depth 10
			$deliveryrequestUri = [string]::Format('https://api.cloud.com/cvad/manage/DeliveryGroups/{0}/Machines', $DeliveryGroup.id)
			Write-Verbose "Invoking REST method to add machine to Delivery Group. URI: $deliveryrequestUri"
			$invoke = Invoke-RestMethod -Uri $deliveryrequestUri -Method POST -Headers $APIHeader.headers -Body $deliveryobject
			$ResultObject.Add($invoke)
		}
	} else {
		Write-Verbose 'No new machines found to add to Delivery Group.'
	}
	Write-Verbose 'Returning result object.'
	$ResultObject

} #end Function
 
Export-ModuleMember -Function New-CTXAPI_Machine
#endregion
 
#region New-CTXAPI_Report.ps1
######## Function 17 of 19 ##################
# Function:         New-CTXAPI_Report
# Module:           CTXCloudApi
# ModuleVersion:    0.1.33
# Author:           Pierre Smit
# Company:          Private
# CreatedOn:        2/26/2026 10:38:39 AM
# ModifiedOn:       2/26/2026 10:41:39 AM
# Synopsis:         Generate Citrix Cloud monitoring reports in multiple formats (Host, Excel, HTML).
#############################################
 

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
				$FailureId = $script:SessionFailureCode.([int]$session.FailureId)
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
						FailureId                  = Check-Variable -VariableName $FailureId
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
				$MonDataMachine = $monitordata.machines | Where-Object { $_.id -like $log.MachineId }
				$MachinesFiltered = $machines | Where-Object {$_.Name -like $MonDataMachine.Name }

				$DnsName = $MonDataMachine.DnsName
				$AssociatedUserNames = $MonDataMachine.AssociatedUserNames
				$OSType = $MonDataMachine.OSType
				$IsAssigned = $MonDataMachine.IsAssigned
				$FailureStartDate = $log.FailureStartDate
				$FailureEndDate = $log.FailureEndDate
				$FaultState = $MachineFaultStateCode.([int]$log.FaultState)
				$LastDeregistrationReason = $script:MachineDeregistration.([int]$MachinesFiltered.LastDeregisteredCode)
				$LastDeregisteredDate = $MonDataMachine.LastDeregisteredDate
				$LastPowerActionCompletedDate = $MonDataMachine.LastPowerActionCompletedDate
				$LastPowerActionFailureReason = $script:MachineDeregistration.([int]$MonDataMachine.LastPowerActionFailureReason)
				$CurrentFaultState = $script:MachineFaultStateCode.([int]$MachinesFiltered.FaultState)
				$IsInMaintenanceMode = $MachinesFiltered.IsInMaintenanceMode
				$RegistrationState = $script:RegistrationState.([int]$MachinesFiltered.CurrentRegistrationState)

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
				
				$FilterConnect = $ColGroup | Where-Object { $_.Name -like $session.SessionKey } 
				[System.Collections.generic.List[PSObject]]$Connections = @()
				if ($FilterConnect) {
					$FilterConnect.Group | ForEach-Object { $Connections.Add($_) }
					Write-Verbose "[$(Get-Date -Format HH:mm:ss)] [Connections] $($FilterConnect.Count) connections found for session $($session.SessionKey)"
					$ConnectionState = $script:ConnectionState.([int]$session.ConnectionState)
					$IsReconnect = $Connections[-1].IsReconnect
					$AuthenticationDuration = ($Connections.AuthenticationDuration | Measure-Object -Sum).Sum
					$BrokeringDuration = ($Connections.BrokeringDuration | Measure-Object -Sum).Sum
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
					$IcaLatency = [math]::Round(($SessionMetrics.icaLatency | Measure-Object -Average).Average)	
					$IcaRttMS = [math]::Round(($SessionMetrics.icaRttMS | Measure-Object -Average).Average)
					Write-Verbose "[$(Get-Date -Format HH:mm:ss)] [Metrics] $($FilterMetrics.Count) metrics found for session $($session.SessionKey)"
				} else {
					Write-Verbose "[$(Get-Date -Format HH:mm:ss)] [Metrics] No metrics found for session $($session.SessionKey)"
					$IcaLatency = $null
					$IcaRttMS = $null
				}
				$MachineName = if ($machine) { $machine.Name } else { $null }
				$User = if ($user) { $user.Upn } else { $null }

				$LogOnDuration = $session.LogOnDuration
				$ClientLogOnDuration = $session.ClientLogOnDuration

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
						$Hour = $CollectDate.ToString('HH:00')
						$DesktopGroupName = $DesktopGroup.Name
						$TotalHourLogins = $Perhour.TotalCount
						$AvgBrokeringDuration = Calc-Avg -Duration $Perhour.BrokeringDuration -Count $Perhour.TotalCount
						$avgVMPowerOnDuration = Calc-Avg -Duration $Perhour.VMPowerOnDuration -Count $Perhour.TotalCount
						$avgVMRegistrationDuration = Calc-Avg -Duration $Perhour.VMRegistrationDuration -Count $Perhour.TotalCount
						$avgAuthenticationDuration = Calc-Avg -Duration $Perhour.AuthenticationDuration -Count $Perhour.TotalCount
						$avgGpoDuration = Calc-Avg -Duration $Perhour.GpoDuration -Count $Perhour.TotalCount
						$avgLogOnScriptsDuration = Calc-Avg -Duration $Perhour.LogOnScriptsDuration -Count $Perhour.TotalCount
						$avgInteractiveDuration = Calc-Avg -Duration $Perhour.InteractiveDuration -Count $Perhour.TotalCount
						$avgProfileLoadDuration = Calc-Avg -Duration $Perhour.ProfileLoadDuration -Count $Perhour.TotalCount
						$avgClientLogOnDuration = Calc-Avg -Duration $Perhour.ClientLogOnDuration -Count $Perhour.TotalCount
				
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
				$TotalDuration = [math]::Round(($login.Group | Measure-Object -Property TotalDuration -Sum).Sum)
				$TotalCount = ($login.Group | Measure-Object -Property TotalCount -Sum).Sum
				$BrokeringDuration = [math]::Round(($login.Group | Measure-Object -Property BrokeringDuration -Sum).Sum)
				$VMPowerOnDuration = [math]::Round(($login.Group | Measure-Object -Property VMPowerOnDuration -Sum).Sum)
				$VMRegistrationDuration = [math]::Round(($login.Group | Measure-Object -Property VMRegistrationDuration -Sum).Sum)
				$AuthenticationDuration = [math]::Round(($login.Group | Measure-Object -Property AuthenticationDuration -Sum).Sum)
				$GpoDuration = [math]::Round(($login.Group | Measure-Object -Property GpoDuration -Sum).Sum)
				$InteractiveDuration = [math]::Round(($login.Group | Measure-Object -Property InteractiveDuration -Sum).Sum)
				$ProfileLoadDuration = [math]::Round(($login.Group | Measure-Object -Property ProfileLoadDuration -Sum).Sum)
				$ClientLogOnDuration = [math]::Round(($login.Group | Measure-Object -Property ClientLogOnDuration -Sum).Sum)
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
 
Export-ModuleMember -Function New-CTXAPI_Report
#endregion
 
#region Set-CTXAPI_MachinePowerState.ps1
######## Function 18 of 19 ##################
# Function:         Set-CTXAPI_MachinePowerState
# Module:           CTXCloudApi
# ModuleVersion:    0.1.33
# Author:           Pierre Smit
# Company:          Private
# CreatedOn:        2/23/2026 9:03:26 AM
# ModifiedOn:       2/23/2026 9:05:42 AM
# Synopsis:         Starts, shuts down, restarts, or logs off Citrix machines via CTX API.
#############################################
 
<#
.SYNOPSIS
Starts, shuts down, restarts, or logs off Citrix machines via CTX API.

.DESCRIPTION
This function allows you to remotely control the power state of Citrix machines using the CTX API. You can start, shut down, restart, or log off one or more machines by specifying their name, DNS name, or ID.

.PARAMETER APIHeader
The CTX API authentication header object (type CTXAPIHeaderObject) required for API calls.

.PARAMETER Name
The name, DNS name, or ID of the Citrix Machine(s) to target. Accepts an array of strings.

.PARAMETER PowerAction
The desired power action to perform. Valid values: Start, Shutdown, Restart, Logoff.

.EXAMPLE
Set-CTXAPI_MachinePowerState -APIHeader $header -Name "CTX-Machine01" -PowerAction Start
Starts the specified Citrix Machine.

.EXAMPLE
Set-CTXAPI_MachinePowerState -APIHeader $header -Name "CTX-Machine01","CTX-Machine02" -PowerAction Shutdown
Shuts down multiple Citrix Machines.

.INPUTS


.OUTPUTS
System.Object[]. Returns the API response objects for each machine processed.

.NOTES

#>
function Set-CTXAPI_MachinePowerState {
	[Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Set-CTXAPI_MachinePowerState')]
	[OutputType([System.Object[]])]
	#region Parameter
	param(
		[Parameter(Position = 0, Mandatory)]
		[PSTypeName('CTXAPIHeaderObject')]$APIHeader,
		[Parameter(ValueFromPipeline,
			ValueFromPipelineByPropertyName,
			ValueFromRemainingArguments)]
		[Alias('DNSName', 'Id')]
		[string[]]$Name,
		[ValidateSet('Start', 'Shutdown', 'Restart', 'Logoff')]
		[string]$PowerAction
	)
	#endregion
	begin {
		Write-Verbose "[$(Get-Date -Format HH:mm:ss) BEGIN] Starting $($myinvocation.mycommand)"
		[System.Collections.generic.List[PSObject]]$Machines = @()
		[System.Collections.generic.List[PSObject]]$ResultObject = @()
		Write-Verbose "Retrieving machines matching: $Name"
		try {
			Get-CTXAPI_Machine -APIHeader $APIHeader | Where-Object {($_.name -in $Name) -or ($_.id -in $name) -or ($_.DNSname -in $name)} | ForEach-Object { $Machines.Add($_) }
			Write-Verbose ('Found {0} machines to process.' -f $Machines.Count)
		} catch {
			Write-Warning "Error retrieving machines - $_.Exception.Message"
		}        
		if ($PSBoundParameters.ContainsKey('PowerAction')) {
			Write-Verbose "Action specified: $PowerAction"
			switch ($PowerAction) {
				'Start' { $endpoint = 'start' }
				'Shutdown' { $endpoint = 'shutdown' }
				'Restart' { $endpoint = 'reboot' }
				'Logoff' { $endpoint = 'logoff' }
			}
			Write-Verbose "API endpoint resolved: $endpoint"
		} else {
			Write-Warning 'No action specified. Please provide an action using the -PowerAction parameter (Start, Shutdown, Restart, Logoff).'
		}
	} #End Begin
	process {
		foreach ($machine in $Machines) {
			Write-Verbose "Processing machine: $($machine.DnsName) (ID: $($machine.Id))"
			try {
				$baseuri = [string]::Format('https://api.cloud.com/cvad/manage/Machines/{0}/${1}', $($machine.Name), $endpoint)
				Write-Verbose "Calling API: $baseuri"
				try {
					$apiResult = Invoke-RestMethod -Uri $baseuri -Method POST -Headers $APIHeader.headers
					Write-Verbose "API call result: $($apiResult | ConvertTo-Json -Depth 3)"
					$ResultObject.Add($apiResult)
					Write-Verbose "Performed action '$PowerAction' on machine '$($machine.DnsName)' (ID: $($machine.Id))"
				} catch {
					Write-Warning "API call failed for machine '$($machine.DnsName)' - $_.Exception.Message"
				}
			} catch {
				Write-Warning "Error processing machine '$($machine.DnsName)' - $_.Exception.Message"
			}
		}
	}#Process
	end {
		Write-Verbose "[$(Get-Date -Format HH:mm:ss) END] Complete"
		return $ResultObject
	}#End End
} #end Function
 
Export-ModuleMember -Function Set-CTXAPI_MachinePowerState
#endregion
 
#region Test-CTXAPI_Header.ps1
######## Function 19 of 19 ##################
# Function:         Test-CTXAPI_Header
# Module:           CTXCloudApi
# ModuleVersion:    0.1.33
# Author:           Pierre Smit
# Company:          Private
# CreatedOn:        11/26/2024 11:41:08 AM
# ModifiedOn:       2/18/2026 10:40:08 AM
# Synopsis:         Checks that the connection is still valid, and the token hasn't expired.
#############################################
 
<#
.SYNOPSIS
Checks that the connection is still valid, and the token hasn't expired.

.DESCRIPTION
Checks that the connection is still valid, and the token hasn't expired.

.PARAMETER APIHeader
Use Connect-CTXAPI to create headers.

.PARAMETER AutoRenew
If the token has expired, it will connect and renew the variable.

.EXAMPLE
Test-CTXAPI_Header -APIHeader $APIHeader -AutoRenew

#>

function Test-CTXAPI_Header {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Test-CTXAPI_Header')]
    [Alias('Test-CTXAPI_Headers')]
    [OutputType([System.Boolean])]
    param(
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader,
        [switch]$AutoRenew = $false
    )

    $timeleft = [math]::Truncate(($APIHeader.TokenExpireAt - (Get-Date)).totalminutes)
    Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) [Processing] Time Left in min: $($timeleft)"
    if ($timeleft -lt 0) {
        Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) [Processing] Token Update Needed"
        if ($AutoRenew) {
            Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) [Processing] Updating Token"
            $APItmp = Connect-CTXAPI -Customer_Id $APIHeader.CTXAPI.Customer_Id -Client_Id $APIHeader.CTXAPI.Client_Id -Client_Secret $APIHeader.CTXAPI.Client_Secret -Customer_Name $APIHeader.CustomerName
            Get-Variable | Where-Object { $_.value -like '*TokenExpireAt=*' -and $_.Name -notlike 'APItmp' } | Set-Variable -Value $APItmp -Force -Scope global
            return $true
        } else { return $false }
    } else { return $true }


} #end Function
 
Export-ModuleMember -Function Test-CTXAPI_Header
#endregion
 
#endregion
 
