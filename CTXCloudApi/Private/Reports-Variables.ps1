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