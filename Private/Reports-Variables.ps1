

$global:RegistrationState = [PSCustomObject]@{
	0 = 'Unknown'
	1 = 'Registered'
	2 = 'Unregistered'
}
$global:ConnectionState = [PSCustomObject]@{
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
$global:ConnectionFailureType = [PSCustomObject]@{
	0 = 'None'
	1 = 'ClientConnectionFailure'
	2 = 'MachineFailure'
	3 = 'NoCapacityAvailable'
	4 = 'NoLicensesAvailable'
	5 = 'Configuration'
}
$global:SessionFailureCode = [PSCustomObject]@{
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

#region Html Settings
$global:colour1 = '#061820'
$global:colour2 = '#FFD400'

$global:TableSettings = @{
	Style                        = 'cell-border'
	TextWhenNoData               = 'No Data to display here'
    Buttons                       = 'searchBuilder','pdfHtml5','excelHtml5'
	#AllProperties                = $true
	#AlphabetSearch               = $true
	AutoSize                     = $true
	#Compare                      = $true
	#DisableAutoWidthOptimization = $true
	#DisableInfo                  = $true
	#DisableNewLine               = $true
	#DisableOrdering              = $true
	#DisablePaging               = $true
	#DisableProcessing           = $true
	#DisableResponsiveTable      = $true
	DisableSearch               = $true
	#DisableSelect               = $true
	#DisableStateSave            = $true
	#EnableAutoFill              = $true
	#EnableColumnReorder         = $true
	#EnableKeys                  = $true
	#EnableRowReorder            = $true
	#EnableScroller              = $true
	#Filtering                   = $true
	#FixedFooter                 = $true
	FixedHeader                 = $true
	#HideButtons                 = $true
	HideFooter                  = $true
	#HideShowButton              = $true
	#HighlightDifferences        = $true
	#ImmediatelyShowHiddenDetails = $true
	#InvokeHTMLTags              = $true
	#OrderMulti                  = $true
	ScrollCollapse              = $true
	ScrollX                     = $true
	ScrollY                     = $true
	#SearchBuilder               = $true
	SearchHighlight             = $true
	#SearchPane                  = $true
	#SearchRegularExpression     = $true
	#Simplify                    = $true
	#SkipProperties              = $true
	#Transpose                   = $true
}

$global:SectionSettings = @{
	BackgroundColor       = 'grey'
	CanCollapse           = $true
	HeaderBackGroundColor = $colour1
	HeaderTextAlignment   = 'center'
	HeaderTextColor       = $colour2
	HeaderTextSize        = '10'
	BorderRadius          = '15px'
}

$global:TableSectionSettings = @{
	BackgroundColor       = 'white'
	CanCollapse           = $true
	HeaderBackGroundColor = $colour2
	HeaderTextAlignment   = 'center'
	HeaderTextColor       = $colour1
	HeaderTextSize        = '10'
}

#$Global:Logourl = 'https://ioco.tech/wp-content/uploads/2020/03/ioco-logo.png'
$Global:Logourl = 'https://c.na65.content.force.com/servlet/servlet.ImageServer?id=0150h000003yYnkAAE&oid=00DE0000000c48tMAA'
#endregion

