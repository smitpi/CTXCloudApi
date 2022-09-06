#region Private Functions
#region Export-Odata.ps1
########### Private Function ###############
# Source:           Export-Odata.ps1
# Module:           CTXCloudApi
# ModuleVersion:    0.1.26.6
# Company:          HTPCZA Tech
# CreatedOn:        2022/03/20 13:16:40
# ModifiedOn:       2022/09/03 19:15:36
############################################
    Function Export-Odata {
        [OutputType([System.Object[]])]
        param(
            [string]$URI,
            [Hashtable]$headers)

        [System.Collections.generic.List[PSObject]]$MonitorDataObject = @()
        $NextLink = $URI

        Write-Color -Text 'Fetching :', $URI.split('?')[0].split('\')[1] -Color Yellow, Cyan -ShowTime -DateTimeFormat HH:mm:ss -NoNewLine
        $APItimer.Restart()
        While (-not([string]::IsNullOrEmpty($NextLink))) {
            $request = Invoke-RestMethod -Method Get -Uri $NextLink -Headers $headers
            $request.Value | ForEach-Object { $MonitorDataObject.Add($_) }
            
            if (-not([string]::IsNullOrEmpty($request.'@odata.NextLink'))) {$NextLink = $request.'@odata.NextLink'}
            else {$NextLink = $null}
        }
        [String]$seconds = '[' + ($APItimer.elapsed.seconds).ToString() + 'sec]'
        Write-Color $seconds -Color Red
        return $MonitorDataObject


    } #end Function
#endregion
#region Reports-Colors.ps1
########### Private Function ###############
# Source:           Reports-Colors.ps1
# Module:           CTXCloudApi
# ModuleVersion:    0.1.26.6
# Company:          HTPCZA Tech
# CreatedOn:        2022/03/20 13:16:40
# ModifiedOn:       2022/06/24 23:28:21
############################################

if (Test-Path HKCU:\Software\CTXCloudApi) {

    $script:CTXAPI_Color1 = Get-ItemPropertyValue -Path HKCU:\Software\CTXCloudApi -Name Color1
    $script:CTXAPI_Color2 = Get-ItemPropertyValue -Path HKCU:\Software\CTXCloudApi -Name Color2
    $script:CTXAPI_LogoURL = Get-ItemPropertyValue -Path HKCU:\Software\CTXCloudApi -Name LogoURL

}
else {
        New-Item -Path HKCU:\Software\CTXCloudApi
        New-ItemProperty -Path HKCU:\Software\CTXCloudApi -Name Color1 -Value '#2b1200'
        New-ItemProperty -Path HKCU:\Software\CTXCloudApi -Name Color2 -Value '#f37000'
        New-ItemProperty -Path HKCU:\Software\CTXCloudApi -Name LogoURL -Value 'https://gist.githubusercontent.com/smitpi/ecdaae80dd79ad585e571b1ba16ce272/raw/6d0645968c7ba4553e7ab762c55270ebcc054f04/default-monochrome.png'

    $script:CTXAPI_Color1 = Get-ItemPropertyValue -Path HKCU:\Software\CTXCloudApi -Name Color1
    $script:CTXAPI_Color2 = Get-ItemPropertyValue -Path HKCU:\Software\CTXCloudApi -Name Color2
    $script:CTXAPI_LogoURL = Get-ItemPropertyValue -Path HKCU:\Software\CTXCloudApi -Name LogoURL
}


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
	HeaderTextSize        = '10'
	BorderRadius          = '15px'
}
$script:TableSectionSettings = @{
	BackgroundColor       = 'white'
	CanCollapse           = $true
	HeaderBackGroundColor = $CTXAPI_Color2
	HeaderTextAlignment   = 'center'
	HeaderTextColor       = $CTXAPI_Color1
	HeaderTextSize        = '10'
}
#endregion


#endregion
#region Reports-Variables.ps1
########### Private Function ###############
# Source:           Reports-Variables.ps1
# Module:           CTXCloudApi
# ModuleVersion:    0.1.26.6
# Company:          HTPCZA Tech
# CreatedOn:        2022/03/20 13:16:40
# ModifiedOn:       2022/05/03 21:55:20
############################################
# https://developer-docs.citrix.com/projects/monitor-service-odata-api/en/latest/api-reference/Monitor.Model/#enums-error-codes-and-descriptions

$script:RegistrationState = [PSCustomObject]@{
    0 = 'Unknown'
    1 = 'Registered'
    2 = 'Unregistered'
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
$script:ConnectionFailureType = [PSCustomObject]@{
    0 = 'None'
    1 = 'ClientConnectionFailure'
    2 = 'MachineFailure'
    3 = 'NoCapacityAvailable'
    4 = 'NoLicensesAvailable'
    5 = 'Configuration'
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
$script:MachineDeregistration = [PSCustomObject]@{
    0	='AgentShutdown'
    1	='AgentSuspended'
    100	='IncompatibleVersion'
    101	='AgentAddressResolutionFailed'
    102	='AgentNotContactable'
    103	='AgentWrongActiveDirectoryOU'
    104	='EmptyRegistrationRequest'
    105	='MissingRegistrationCapabilities'
    106	='MissingAgentVersion'
    107	='InconsistentRegistrationCapabilities'
    108	='NotLicensedForFeature'
    109	='UnsupportedCredentialSecurityversion'
    110	='InvalidRegistrationRequest'
    111	='SingleMultiSessionMismatch'
    112	='FunctionalLevelTooLowForCatalog'
    113	='FunctionalLevelTooLowForDesktopGroup'
    200	='PowerOff'
    203	='AgentRejectedSettingsUpdate'
    206	='SessionPrepareFailure'
    207	='ContactLost'
    301	='BrokerRegistrationLimitReached'
    208	='SettingsCreationFailure'
    204	='SendSettingsFailure'
    2	='AgentRequested'
    201	='DesktopRestart'
    202	='DesktopRemoved'
    205	='SessionAuditFailure'
    300	='UnknownError'
    302	='RegistrationStateMismatch'
}
$script:MachineFailureType = [PSCustomObject]@{
    4 = 'MaxCapacity'
    2 = 'StuckOnBoot'	
    1 = 'FailedToStart'
}
$script:ConnectionState = [PSCustomObject]@{
        0   =	'Unknown'
        1	=	'Connected'
        2	=	'Disconnected'
        3	=	'Terminated'
        4	=	'PreparingSession'
        5	=	'Active'
        6	=	'Reconnecting'
        7	=	'NonBrokeredSession'
        8	=	'Other'
        9	=	'Pending'
}
#endregion
#endregion
 
#region Public Functions
#region Add-CTXAPI_DefaultsToProfile.ps1
######## Function 1 of 25 ##################
# Function:         Add-CTXAPI_DefaultsToProfile
# Module:           CTXCloudApi
# ModuleVersion:    0.1.26.6
# Author:           Pierre Smit
# Company:          HTPCZA Tech
# CreatedOn:        2022/09/03 16:47:13
# ModifiedOn:       2022/09/03 17:00:30
# Synopsis:         This function will add connection settings to PSDefaultParameter and your profile.
#############################################
 
<#
.SYNOPSIS
This function will add connection settings to PSDefaultParameter and your profile.

.DESCRIPTION
This function will add connection settings to PSDefaultParameter and your profile.

.PARAMETER Customer_Id
From Citrix Cloud

.PARAMETER Client_Id
From Citrix Cloud

.PARAMETER Client_Secret
From Citrix Cloud

.PARAMETER Customer_Name
Name of your Company, or what you want to call your connection.

.PARAMETER RemoveConfig
Remove the config from your profile.

.EXAMPLE
$splat = @{
	Customer_Id = "xxx"
	Client_Id = "xxx-xxx-xxx-xxx"
	Client_Secret = "yyyyyy=="
	Customer_Name = 'HomeLab'
}
Add-CTXAPI_DefaultsToProfile @splat

#>
Function Add-CTXAPI_DefaultsToProfile {
	[Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Add-CTXAPI_DefaultsToProfile')]
	[OutputType([System.Object[]])]
	PARAM(
		[Parameter(Mandatory)]
		[string]$Customer_Id,
		[Parameter(Mandatory)]
		[string]$Client_Id,
		[Parameter(Mandatory)]
		[string]$Client_Secret,
		[Parameter(Mandatory)]
		[string]$Customer_Name,
		[switch]$RemoveConfig
	)
	try {
		$PSDefaultParameterValues.Add('*CTXAPI*:Customer_Id', "$($Customer_Id)")
		$PSDefaultParameterValues.Add('*CTXAPI*:Client_Id', "$($Client_Id)")
		$PSDefaultParameterValues.Add('*CTXAPI*:Client_Secret', "$($Client_Secret)")
		$PSDefaultParameterValues.Add('*CTXAPI*:Customer_Name', "$($Customer_Name)")
	} catch {Write-Warning "Error: `n`tMessage:$($_.Exception.Message)"}
	$ToAppend = @"

#region CTXAPI Defaults
`$PSDefaultParameterValues['*CTXAPI*:Customer_Id'] = "$($Customer_Id)"
`$PSDefaultParameterValues['*CTXAPI*:Client_Id'] = "$($Client_Id)"
`$PSDefaultParameterValues['*CTXAPI*:Client_Secret'] = "$($Client_Secret)"
`$PSDefaultParameterValues['*CTXAPI*:Customer_Name'] = "$($Customer_Name)"
#endregion CTXAPI

"@
	
	try {
		$CheckProfile = Get-Item $PROFILE -ErrorAction Stop
	} catch { $CheckProfile = New-Item $PROFILE -ItemType File -Force}
	
	$Files = Get-ChildItem -Path "$($CheckProfile.Directory)\*profile*"

	foreach ($file in $files) {	
		$tmp = Get-Content -Path $file.FullName | Where-Object { $_ -notlike '*CTXAPI*'}
		$tmp | Set-Content -Path $file.FullName -Force
		if (-not($RemoveConfig)) {Add-Content -Value $ToAppend -Path $file.FullName -Force -Encoding utf8 }
		Write-Host '[Updated]' -NoNewline -ForegroundColor Yellow; Write-Host ' Profile File:' -NoNewline -ForegroundColor Cyan; Write-Host " $($file.FullName)" -ForegroundColor Green
	}

} #end Function
 
Export-ModuleMember -Function Add-CTXAPI_DefaultsToProfile
#endregion
 
#region Connect-CTXAPI.ps1
######## Function 2 of 25 ##################
# Function:         Connect-CTXAPI
# Module:           CTXCloudApi
# ModuleVersion:    0.1.26.6
# Author:           Pierre Smit
# Company:          HTPCZA Tech
# CreatedOn:        2022/03/20 13:16:40
# ModifiedOn:       2022/09/03 16:45:20
# Synopsis:         Connect to the cloud and create needed api headers
#############################################
 
<#
.SYNOPSIS
Connect to the cloud and create needed api headers

.DESCRIPTION
Connect to the cloud and create needed api headers

.PARAMETER Customer_Id
From Citrix Cloud

.PARAMETER Client_Id
From Citrix Cloud

.PARAMETER Client_Secret
From Citrix Cloud

.PARAMETER Customer_Name
Name of your Company, or what you want to call your connection

.EXAMPLE
$splat = @{
	Customer_Id = "xxx"
	Client_Id = "xxx-xxx-xxx-xxx"
	Client_Secret = "yyyyyy=="
	Customer_Name = 'HomeLab'
}
$APIHeader = Connect-CTXAPI @splat

#>

Function Connect-CTXAPI {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Connect-CTXAPI')]
    PARAM(
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
        Authorization       = "CwsAuth Bearer=$((Invoke-RestMethod -Method Post -Uri 'https://api-us.cloud.com/cctrustoauth2/root/tokens/clients' -Body $body).access_token)"
        'Citrix-CustomerId' = $Customer_Id
        Accept              = 'application/json'
    }
    $headers.Add('Citrix-InstanceId', (Invoke-RestMethod 'https://api-us.cloud.com/cvadapis/me' -Headers $headers).customers.sites.id)

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
######## Function 3 of 25 ##################
# Function:         Get-CTXAPI_Application
# Module:           CTXCloudApi
# ModuleVersion:    0.1.26.6
# Author:           Pierre Smit
# Company:          HTPCZA Tech
# CreatedOn:        2022/03/20 13:16:40
# ModifiedOn:       2022/03/20 13:16:40
# Synopsis:         Return details about published apps
#############################################
 
<#
.SYNOPSIS
Return details about published apps

.DESCRIPTION
Return details about published apps

.PARAMETER APIHeader
Use Connect-CTXAPI to create headers

.EXAMPLE
Get-CTXAPI_Applications -APIHeader $APIHeader

#>

Function Get-CTXAPI_Application {
	[Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Applications')]
	[Alias('Get-CTXAPI_Applications')]
	[OutputType([System.Object[]])]
	PARAM(
		[Parameter(Mandatory = $true)]
		[PSTypeName('CTXAPIHeaderObject')]$APIHeader)

    (Invoke-RestMethod -Uri 'https://api.cloud.com/cvad/manage/Applications/' -Method get -Headers $APIHeader.headers).items | ForEach-Object {
		Invoke-RestMethod -Uri "https://api.cloud.com/cvad/manage/Applications/$($_.id)" -Method Get -Headers $APIHeader.headers
	}

} #end Function
 
Export-ModuleMember -Function Get-CTXAPI_Application
#endregion
 
#region Get-CTXAPI_CloudConnector.ps1
######## Function 4 of 25 ##################
# Function:         Get-CTXAPI_CloudConnector
# Module:           CTXCloudApi
# ModuleVersion:    0.1.26.6
# Author:           Pierre Smit
# Company:          HTPCZA Tech
# CreatedOn:        2022/03/20 13:16:40
# ModifiedOn:       2022/03/20 13:16:40
# Synopsis:         Details about current Cloud Connectors
#############################################
 
<#
.SYNOPSIS
Details about current Cloud Connectors

.DESCRIPTION
Details about current Cloud Connectors

.PARAMETER APIHeader
Use Connect-CTXAPI to create headers

.EXAMPLE
Get-CTXAPI_CloudConnector -APIHeader $APIHeader

#>

Function Get-CTXAPI_CloudConnector {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_CloudConnector')]
    [Alias('Get-CTXAPI_CloudConnectors')]
    [OutputType([System.Object[]])]
    PARAM(
        [Parameter(Mandatory = $true)]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader)

    (Invoke-RestMethod -Uri "https://agenthub.citrixworkspacesapi.net/$($APIHeader.headers.'Citrix-CustomerId')/EdgeServers" -Method get -Headers $APIHeader.headers).id | ForEach-Object {
        Invoke-RestMethod -Uri "https://agenthub.citrixworkspacesapi.net/$($APIHeader.headers.'Citrix-CustomerId')/EdgeServers/$($_)" -Method Get -Headers $APIHeader.headers
    }
} #end Function
 
Export-ModuleMember -Function Get-CTXAPI_CloudConnector
#endregion
 
#region Get-CTXAPI_CloudService.ps1
######## Function 5 of 25 ##################
# Function:         Get-CTXAPI_CloudService
# Module:           CTXCloudApi
# ModuleVersion:    0.1.26.6
# Author:           Pierre Smit
# Company:          HTPCZA Tech
# CreatedOn:        2022/03/20 13:16:40
# ModifiedOn:       2022/03/20 13:16:40
# Synopsis:         Return details about cloud services and subscription
#############################################
 
<#
.SYNOPSIS
Return details about cloud services and subscription

.DESCRIPTION
Return details about cloud services and subscription

.PARAMETER APIHeader
Use Connect-CTXAPI to create headers

.EXAMPLE
Get-CTXAPI_CloudService -APIHeader $APIHeader

#>

Function Get-CTXAPI_CloudService {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_CloudService')]
    [Alias('Get-CTXAPI_CloudServices')]
    [OutputType([System.Object[]])]
    PARAM(
        [Parameter(Mandatory = $true)]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader)

    (Invoke-RestMethod -Uri "https://core.citrixworkspacesapi.net/$($ApiHeader.headers.'Citrix-CustomerId')/serviceStates" -Headers $ApiHeader.headers).items

} #end Function
 
Export-ModuleMember -Function Get-CTXAPI_CloudService
#endregion
 
#region Get-CTXAPI_ConfigAudit.ps1
######## Function 6 of 25 ##################
# Function:         Get-CTXAPI_ConfigAudit
# Module:           CTXCloudApi
# ModuleVersion:    0.1.26.6
# Author:           Pierre Smit
# Company:          HTPCZA Tech
# CreatedOn:        2022/03/20 13:16:40
# ModifiedOn:       2022/06/25 00:00:45
# Synopsis:         Reports on system config.
#############################################
 
<#
.SYNOPSIS
Reports on system config.

.DESCRIPTION
Reports on machine Catalog, delivery groups and published desktops.

.PARAMETER APIHeader
Use Connect-CTXAPI to create headers.

.PARAMETER Export
In what format to export the reports.

.PARAMETER ReportPath
Destination folder for the exported report.

.EXAMPLE
Get-CTXAPI_ConfigAudit -APIHeader $APIHeader -Export Excel -ReportPath C:\Temp

#>

Function Get-CTXAPI_ConfigAudit {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_ConfigAudit')]
    PARAM(
        [Parameter(Mandatory = $true)]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader,
        [Parameter(Mandatory = $true)]
        [ValidateSet('Excel', 'HTML', 'Host')]
        [string]$Export,
        [Parameter(Mandatory = $false)]
        [ValidateScript( { (Test-Path $_) })]
        [string]$ReportPath = $env:temp
    )

    $catalogs = @()
    Get-CTXAPI_MachineCatalogs -APIHeader $APIHeader | ForEach-Object {
        $catalogs += [pscustomobject]@{
            Name                     = $_.Name
            OSType                   = $_.OSType
            AllocationType           = $_.AllocationType
            AssignedCount            = $_.AssignedCount
            AvailableAssignedCount   = $_.AvailableAssignedCount
            AvailableCount           = $_.AvailableCount
            AvailableUnassignedCount = $_.AvailableUnassignedCount
            IsPowerManaged           = $_.IsPowerManaged
            IsRemotePC               = $_.IsRemotePC
            MinimumFunctionalLevel   = $_.MinimumFunctionalLevel
            PersistChanges           = $_.PersistChanges
            ProvisioningType         = $_.ProvisioningType
            SessionSupport           = $_.SessionSupport
            TotalCount               = $_.TotalCount
            IsBroken                 = $_.IsBroken
            MasterImageName          = $_.ProvisioningScheme.MasterImage.name
            MasterImagePath          = $_.ProvisioningScheme.MasterImage.XDPath
        }
    }
    $deliverygroups = @()
    $groups = Get-CTXAPI_DeliveryGroups -APIHeader $APIHeader

    foreach ($grp in $groups) {
        $SimpleAccessPolicy = $grp.SimpleAccessPolicy.IncludedUsers | ForEach-Object { $_.samname }
        $deliverygroups += [pscustomobject]@{
            Name                      = $grp.Name
            MachinesInMaintenanceMode = $grp.MachinesInMaintenanceMode
            RegisteredMachines        = $grp.RegisteredMachines
            TotalMachines             = $grp.TotalMachines
            UnassignedMachines        = $grp.UnassignedMachines
            UserManagement            = $grp.UserManagement
            DeliveryType              = $grp.DeliveryType
            DesktopsAvailable         = $grp.DesktopsAvailable
            DesktopsUnregistered      = $grp.DesktopsUnregistered
            DesktopsFaulted           = $grp.DesktopsFaulted
            InMaintenanceMode         = $grp.InMaintenanceMode
            IsBroken                  = $grp.IsBroken
            MinimumFunctionalLevel    = $grp.MinimumFunctionalLevel
            SessionSupport            = $grp.SessionSupport
            TotalApplications         = $grp.TotalApplications
            TotalDesktops             = $grp.TotalDesktops
            IncludedUsers             = @(($SimpleAccessPolicy) | Out-String).Trim()
        }
    }

    $apps = @()
    $assgroups = @()
    $applications = Get-CTXAPI_Applications -APIHeader $APIHeader

    foreach ($application in $applications) {
        $IncludedUsers = $application.IncludedUsers | ForEach-Object { $_.samname }
        $application.AssociatedDeliveryGroupUuids | ForEach-Object {
            $tmp = $_
            $assgroups += $groups | Where-Object { $_.id -like $tmp } | ForEach-Object { $_.name } }
        $apps += [pscustomobject]@{
            Name                         = $application.Name
            Visible                      = $application.Visible
            CommandLineExecutable        = $application.InstalledAppProperties.CommandLineExecutable
            CommandLineArguments         = $application.InstalledAppProperties.CommandLineArguments
            Enabled                      = $application.Enabled
            NumAssociatedDeliveryGroups  = $application.NumAssociatedDeliveryGroups
            AssociatedDeliveryGroupUuids = @(($assgroups) | Out-String).Trim()
            IncludedUsers                = @(($IncludedUsers) | Out-String).Trim()
        }
    }

    $machines = @()
    Get-CTXAPI_Machines -APIHeader $APIHeader | ForEach-Object {
        $AssociatedUsers = $_.AssociatedUsers | ForEach-Object { $_.samname }
        $machines += [pscustomobject]@{
            DnsName               = $_.DnsName
            AgentVersion          = $_.AgentVersion
            AllocationType        = $_.AllocationType
            AssociatedUsers       = @(($AssociatedUsers) | Out-String).Trim()
            MachineCatalog        = $_.MachineCatalog.name
            DeliveryGroup         = $_.DeliveryGroup.name
            DeliveryType          = $_.DeliveryType
            InMaintenanceMode     = $_.InMaintenanceMode
            DrainingUntilShutdown = $_.DrainingUntilShutdown
            IPAddress             = $_.IPAddress
            IsAssigned            = $_.IsAssigned
            OSType                = $_.OSType
            PersistUserChanges    = $_.PersistUserChanges
            ProvisioningType      = $_.ProvisioningType
            RegistrationState     = $_.RegistrationState
            SummaryState          = $_.SummaryState

        }
    }

    if ($Export -eq 'Excel') {
        $ExcelOptions = @{
            Path             = $ReportPath + "\XD_Audit-$($APIHeader.CustomerName)-" + (Get-Date -Format yyyy.MM.dd-HH.mm) + '.xlsx'
            AutoSize         = $True
            AutoFilter       = $True
            TitleBold        = $True
            TitleSize        = '28'
            TitleFillPattern = 'LightTrellis'
            TableStyle       = 'Light20'
            FreezeTopRow     = $True
            FreezePane       = '3'
        }
        if ($catalogs) {$catalogs | Export-Excel -Title Catalogs -WorksheetName Catalogs @ExcelOptions}
        if ($deliverygroups){$deliverygroups | Export-Excel -Title DeliveryGroups -WorksheetName DeliveryGroups @ExcelOptions}
        if ($apps) {$apps | Export-Excel -Title "Published Apps" -WorksheetName apps @ExcelOptions}
        if ($machines) {$machines | Export-Excel -Title Machines -WorksheetName machines @ExcelOptions}
    }
    if ($Export -eq 'HTML') {

        [string]$HTMLReportname = $ReportPath + "\XD_Audit-$($APIHeader.CustomerName)-" + (Get-Date -Format yyyy.MM.dd-HH.mm) + '.html'

        New-HTML -TitleText "$($APIHeader.CustomerName) Config Audit" -FilePath $HTMLReportname -ShowHTML {
            New-HTMLLogo -RightLogoString $CTXAPI_LogoURL
            New-HTMLHeading -Heading h1 -HeadingText $HeadingText -Color Black
            New-HTMLSection @SectionSettings -Content {
                New-HTMLSection -HeaderText 'Machine Catalogs' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $catalogs }
            }
            New-HTMLSection @SectionSettings -Content {
                New-HTMLSection -HeaderText 'Delivery Groups' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $deliverygroups }
            }
            New-HTMLSection @SectionSettings -Content {
                New-HTMLSection -HeaderText 'Published Applications' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $apps }
            }
            New-HTMLSection @SectionSettings -Content {
                New-HTMLSection -HeaderText 'VDI Devices' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $machines }
            }
        }


    }
    if ($Export -eq 'Host') {
        Write-Color 'Machine Catalogs' -Color Cyan -LinesAfter 2 -StartTab 2
        $catalogs | Format-Table -AutoSize
        Write-Color 'Delivery Groups' -Color Cyan -LinesAfter 2 -StartTab 2
        $deliverygroups | Format-Table -AutoSize
        Write-Color 'Published Applications' -Color Cyan -LinesAfter 2 -StartTab 2
        $apps | Format-Table -AutoSize
        Write-Color 'VDI Devices' -Color Cyan -LinesAfter 2 -StartTab 2
        $machines | Format-Table -AutoSize


    }




} #end Function
 
Export-ModuleMember -Function Get-CTXAPI_ConfigAudit
#endregion
 
#region Get-CTXAPI_ConfigLog.ps1
######## Function 7 of 25 ##################
# Function:         Get-CTXAPI_ConfigLog
# Module:           CTXCloudApi
# ModuleVersion:    0.1.26.6
# Author:           Pierre Smit
# Company:          HTPCZA Tech
# CreatedOn:        2022/03/20 13:16:40
# ModifiedOn:       2022/03/20 13:16:40
# Synopsis:         Get high level configuration changes in the last x days.
#############################################
 
<#
.SYNOPSIS
Get high level configuration changes in the last x days.

.DESCRIPTION
Get high level configuration changes in the last x days.

.PARAMETER Days
Number of days to report on.

.PARAMETER APIHeader
Use Connect-CTXAPI to create headers.

.EXAMPLE
Get-CTXAPI_ConfigLog -APIHeader $APIHeader -Days 15

#>

Function Get-CTXAPI_ConfigLog {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_ConfigLog')]
    PARAM(
        [Parameter(Mandatory = $true)]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader,
        [Parameter(Mandatory = $true)]
        [string]$Days)


    (Invoke-RestMethod -Uri "https://api.cloud.com/cvad/manage/ConfigLog/Operations?days=$days" -Headers $APIHeader.headers).items

} #end Function
 
Export-ModuleMember -Function Get-CTXAPI_ConfigLog
#endregion
 
#region Get-CTXAPI_ConnectionReport.ps1
######## Function 8 of 25 ##################
# Function:         Get-CTXAPI_ConnectionReport
# Module:           CTXCloudApi
# ModuleVersion:    0.1.26.6
# Author:           Pierre Smit
# Company:          HTPCZA Tech
# CreatedOn:        2022/03/20 13:16:40
# ModifiedOn:       2022/06/24 22:49:22
# Synopsis:         Creates Connection report
#############################################
 
<#
.SYNOPSIS
Creates Connection report

.DESCRIPTION
Report on connections in the last x hours

.PARAMETER APIHeader
Use Connect-CTXAPI to create headers

.PARAMETER MonitorData
Use Get-CTXAPI_MonitorData to create OData

.PARAMETER region
You Cloud region

.PARAMETER hours
Duration of the report

.PARAMETER Export
In what format to export the reports.

.PARAMETER ReportPath
Destination folder for the exported report.

.EXAMPLE
Get-CTXAPI_ConnectionReport -MonitorData $MonitorData -Export HTML -ReportPath c:\temp

#>

Function Get-CTXAPI_ConnectionReport {
    [Cmdletbinding(DefaultParameterSetName = 'Fetch odata', HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_ConnectionReport')]
    PARAM(
        [Parameter(Mandatory = $true, ParameterSetName = 'Fetch odata')]
        [ValidateNotNullOrEmpty()]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader,
        [Parameter(Mandatory = $false, ParameterSetName = 'Got odata')]
        [PSTypeName('CTXMonitorData')]$MonitorData,
        [Parameter(Mandatory = $false, ParameterSetName = 'Fetch odata')]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('us', 'eu', 'ap-s')]
        [string]$region,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $false, ParameterSetName = 'Fetch odata')]
        [int]$hours = 24,
        [Parameter(Mandatory = $false)]
        [ValidateSet('Excel', 'HTML')]
        [string]$Export = 'Host',
        [Parameter(Mandatory = $false)]
        [ValidateScript( { (Test-Path $_) })]
        [string]$ReportPath = $env:temp
    )




    if ($Null -eq $MonitorData) { $mondata = Get-CTXAPI_MonitorData -APIHeader $APIHeader -region $region -hours $hours }
    else { $mondata = $MonitorData }

    $data = @()
    foreach ($connection in $mondata.Connections) {
        try {
            $OneSession = $mondata.session | Where-Object { $_.SessionKey -eq $connection.SessionKey }
            $user = $mondata.users | Where-Object { $_.id -like $OneSession.UserId }
            $mashine = $mondata.machines | Where-Object { $_.id -like $OneSession.MachineId }
            try {
                $avgrtt = 0
                $avgrtt = $mondata.SessionMetrics | Where-Object { $_.Sessionid -like $OneSession.SessionKey } | Measure-Object -Property IcaRttMS -Average
            }
            catch { Write-Warning "Not enough RTT data - $_.Exception.Message" }
        }
        catch { Write-Warning "Error processing - $_.Exception.Message" }
        $data += [PSCustomObject]@{
            Id                       = $connection.id
            FullName                 = $user.FullName
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
            EstablishmentDate        = $connection.EstablishmentDate
            LogOnStartDate           = $connection.LogOnStartDate
            LogOnEndDate             = $connection.LogOnEndDate
            AuthenticationDuration   = $connection.AuthenticationDuration
            LogOnDuration            = $OneSession.LogOnDuration
            DisconnectDate           = $connection.DisconnectDate
            EndDate                  = $OneSession.EndDate
            ExitCode                 = $SessionFailureCode.($OneSession.ExitCode)
            FailureDate              = $OneSession.FailureDate
            AVG_ICA_RTT              = [math]::Round($avgrtt.Average)
        }
    }

    if ($Export -eq 'Excel') { 
        $ExcelOptions = @{
            Path             = $ReportPath + '\Session_Audit-' + (Get-Date -Format yyyy.MM.dd-HH.mm) + '.xlsx'
            AutoSize         = $True
            AutoFilter       = $True
            TitleBold        = $True
            TitleSize        = '28'
            TitleFillPattern = 'LightTrellis'
            TableStyle       = 'Light20'
            FreezeTopRow     = $True
            FreezePane       = '3'
        }
        $data | Export-Excel -Title Sessions -WorksheetName Sessions @ExcelOptions
    }
    if ($Export -eq 'HTML') { $data | Out-HtmlView -DisablePaging -Title 'Citrix Sessions' -HideFooter -SearchHighlight -FixedHeader }
    if ($Export -eq 'Host') { $data }

} #end Function
 
Export-ModuleMember -Function Get-CTXAPI_ConnectionReport
#endregion
 
#region Get-CTXAPI_DeliveryGroup.ps1
######## Function 9 of 25 ##################
# Function:         Get-CTXAPI_DeliveryGroup
# Module:           CTXCloudApi
# ModuleVersion:    0.1.26.6
# Author:           Pierre Smit
# Company:          HTPCZA Tech
# CreatedOn:        2022/03/20 13:16:40
# ModifiedOn:       2022/03/20 13:16:40
# Synopsis:         Return details about Delivery Groups
#############################################
 
<#
.SYNOPSIS
Return details about Delivery Groups

.DESCRIPTION
Return details about Delivery Groups

.PARAMETER APIHeader
Use Connect-CTXAPI to create headers

.EXAMPLE
Get-CTXAPI_DeliveryGroup -APIHeader $APIHeader

#>

Function Get-CTXAPI_DeliveryGroup {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_DeliveryGroup')]
    [Alias('Get-CTXAPI_DeliveryGroups')]
    [OutputType([System.Object[]])]
    PARAM(
        [Parameter(Mandatory = $true)]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader
    )

    (Invoke-RestMethod -Uri 'https://api.cloud.com/cvad/manage/DeliveryGroups/' -Method get -Headers $APIHeader.headers).items | ForEach-Object {
        Invoke-RestMethod -Uri "https://api.cloud.com/cvad/manage/DeliveryGroups/$($_.id)" -Method Get -Headers $APIHeader.headers
    }

} #end Function
 
Export-ModuleMember -Function Get-CTXAPI_DeliveryGroup
#endregion
 
#region Get-CTXAPI_FailureReport.ps1
######## Function 10 of 25 ##################
# Function:         Get-CTXAPI_FailureReport
# Module:           CTXCloudApi
# ModuleVersion:    0.1.26.6
# Author:           Pierre Smit
# Company:          HTPCZA Tech
# CreatedOn:        2022/03/20 13:16:40
# ModifiedOn:       2022/09/03 17:22:03
# Synopsis:         Reports on failures in the last x hours.
#############################################
 
<#
.SYNOPSIS
Reports on failures in the last x hours.

.DESCRIPTION
Reports on machine or connection failures in the last x hours.

.PARAMETER APIHeader
Use Connect-CTXAPI to create headers.

.PARAMETER MonitorData
Use Get-CTXAPI_MonitorData to create OData.

.PARAMETER region
Your Cloud instance hosted region.

.PARAMETER hours
Amount of time to report on.

.PARAMETER FailureType
Type of failure to report on

.PARAMETER Export
In what format to export the reports.

.PARAMETER ReportPath
Destination folder for the exported report.

.EXAMPLE
Get-CTXAPI_FailureReport -MonitorData $MonitorData -FailureType Connection

#>

Function Get-CTXAPI_FailureReport {
    [Cmdletbinding(DefaultParameterSetName = 'Fetch odata', HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_FailureReport')]
    [Alias('Get-CTXAPI_FailureReports')]
    [OutputType([System.Object[]])]
    PARAM(
        [Parameter(Mandatory = $true, ParameterSetName = 'Fetch odata')]
        [ValidateNotNullOrEmpty()]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader,
        [Parameter(Mandatory = $false, ParameterSetName = 'Got odata')]
        [PSTypeName('CTXMonitorData')]$MonitorData,
        [Parameter(Mandatory = $false, ParameterSetName = 'Fetch odata')]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('us', 'eu', 'ap-s')]
        [string]$region,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $false, ParameterSetName = 'Fetch odata')]
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

    if ($Null -eq $MonitorData) { $mondata = Get-CTXAPI_MonitorData -APIHeader $APIHeader -region $region -hours $hours }
    else { $mondata = $MonitorData }

    [System.Collections.generic.List[PSObject]]$Data = @()
        
    if ($FailureType -eq 'Machine') {
        $machines = Get-CTXAPI_Machine -APIHeader $APIHeader
        foreach ($log in $mondata.MachineFailureLogs) {
            $MonDataMachine = $mondata.Machines | Where-Object { $_.id -eq $log.MachineId }
            $APIMachine = $machines | Where-Object { $_.dnsname -like $MonDataMachine.DnsName }
            $Data.Add([PSCustomObject]@{
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
            })

        }
    }
    if ($FailureType -eq 'Connection') {
        foreach ($log in $mondata.ConnectionFailureLogs) {
            $session = $mondata.Session | Where-Object { $_.SessionKey -eq $log.SessionKey }
            $user = $mondata.users | Where-Object { $_.id -like $Session.UserId }
            $mashine = $mondata.machines | Where-Object { $_.id -like $Session.MachineId }
            $Data.Add([PSCustomObject]@{
                UserName                   = $user.UserName
                FullName                   = $user.FullName
                DnsName                    = $mashine.DnsName
                IPAddress                  = $mashine.IPAddress
                CurrentRegistrationState   = $RegistrationState.($mashine.CurrentRegistrationState)
                FailureDate                = $log.FailureDate
                ConnectionFailureEnumValue	= $SessionFailureCode.($log.ConnectionFailureEnumValue)
            })
        }
    }



    if ($Export -eq 'Excel') { 
        $ExcelOptions = @{
            Path             = $ReportPath + '\Failure_Audit-' + (Get-Date -Format yyyy.MM.dd-HH.mm) + '.xlsx'
            AutoSize         = $True
            AutoFilter       = $True
            TitleBold        = $True
            TitleSize        = '28'
            TitleFillPattern = 'LightTrellis'
            TableStyle       = 'Light20'
            FreezeTopRow     = $True
            FreezePane       = '3'
        }
        $data | Export-Excel -Title Sessions -WorksheetName Sessions @ExcelOptions
    }
    if ($Export -eq 'HTML') { $data | Out-HtmlView -DisablePaging -Title 'Citrix Failures' -HideFooter -SearchHighlight -FixedHeader }
    if ($Export -eq 'Host') { $data }

} #end Function
 
Export-ModuleMember -Function Get-CTXAPI_FailureReport
#endregion
 
#region Get-CTXAPI_HealthCheck.ps1
######## Function 11 of 25 ##################
# Function:         Get-CTXAPI_HealthCheck
# Module:           CTXCloudApi
# ModuleVersion:    0.1.26.6
# Author:           Pierre Smit
# Company:          HTPCZA Tech
# CreatedOn:        2022/03/20 13:16:40
# ModifiedOn:       2022/09/06 16:35:21
# Synopsis:         Show useful information for daily health check
#############################################
 
<#
.SYNOPSIS
Show useful information for daily health check

.DESCRIPTION
Show useful information for daily health check

.PARAMETER APIHeader
Use Connect-CTXAPI to create headers

.PARAMETER region
Your Cloud instance hosted region.

.PARAMETER ReportPath
Destination folder for the exported report.

.EXAMPLE
Get-CTXAPI_HealthCheck -APIHeader $APIHeader -region eu -ReportPath C:\Temp

#>

Function Get-CTXAPI_HealthCheck {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_HealthCheck')]
    PARAM(
        [Parameter(Mandatory = $true)]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('us', 'eu', 'ap-s')]
        [string]$region,
        [ValidateScript( { (Test-Path $_) })]
        [string]$ReportPath = $env:temp
    )
    #######################
    #region Get data
    #######################

    Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) [Processing] Config Log"
    $configlog = Get-CTXAPI_ConfigLog -APIHeader $APIHeader -Days 7 | Group-Object -Property text | Select-Object count, name | Sort-Object -Property count -Descending | Select-Object -First 5

    Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) [Processing] Delivery Groups"
    $DeliveryGroups = Get-CTXAPI_DeliveryGroup -APIHeader $APIHeader | Select-Object Name, DeliveryType, DesktopsAvailable, DesktopsDisconnected, DesktopsFaulted, DesktopsNeverRegistered, DesktopsUnregistered, InMaintenanceMode, IsBroken, RegisteredMachines, SessionCount

    $MonitorData = Get-CTXAPI_MonitorData -APIHeader $APIHeader -region $region -hours 24

    Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) [Processing] Connection Report"
    $ConnectionReport = Get-CTXAPI_ConnectionReport -MonitorData $MonitorData
    $connectionRTT = $ConnectionReport | Sort-Object -Property AVG_ICA_RTT -Descending -Unique | Select-Object -First 5 FullName, ClientVersion, ClientAddress, AVG_ICA_RTT
    $connectionLogon = $ConnectionReport | Sort-Object -Property LogOnDuration -Descending -Unique | Select-Object -First 5 FullName, ClientVersion, ClientAddress, LogOnDuration

    Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) [Processing] Resource Utilization"
    $ResourceUtilization = Get-CTXAPI_ResourceUtilization -MonitorData $MonitorData

    Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) [Processing] Failure Report"
    $ConnectionFailureReport = Get-CTXAPI_FailureReport -MonitorData $MonitorData -FailureType Connection
    $MachineFailureReport = Get-CTXAPI_FailureReport -APIHeader $APIHeader -region $region -hours 24 -FailureType Machine | Select-Object Name, IP, OSType, FailureStartDate, FailureEndDate, FaultState


    Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) [Processing] Sessions"
    $vdauptime = Get-CTXAPI_VDAUptime -APIHeader $APIHeader
    $sessions = Get-CTXAPI_Session -APIHeader $APIHeader
    $sessioncount = [PSCustomObject]@{
        Connected           = ($sessions | Where-Object { $_.state -like 'active' }).count
        Disconnected        = ($sessions | Where-Object { $_.state -like 'Disconnected' }).count
        ConnectionFailure   = $ConnectionFailureReport.count
        MachineFailure      = $MachineFailureReport.count
        'VDA InMaintenance' = ($vdauptime | Where-Object { $_.InMaintenanceMode -like 'true' }).count
        'VDA AgentVersions' = ($vdauptime | Group-Object -Property AgentVersion).count
        'VDA NeedsReboot'   = ($vdauptime | Where-Object { $_.days -gt 7 }).count
    }

    Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) Cloud Connectors"
    $Locations = Get-CTXAPI_ResourceLocation -APIHeader $APIHeader
    $CConnector = Get-CTXAPI_CloudConnector -APIHeader $APIHeader | ForEach-Object {
        $loc = $_.location
        [PSCustomObject]@{
            fqdn            = $_.fqdn
            location        = ($Locations | Where-Object { $_.id -like $loc }).name
            status          = $_.status
            currentVersion  = $_.currentVersion
            versionState    = $_.versionState
            lastContactDate = (Get-Date ([datetime]$_.lastContactDate) -Format 'yyyy-MM-dd HH:mm')
            inMaintenance   = $_.inMaintenance
        }
    }

    Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) Cloud Site Tests"
    $testResult = Get-CTXAPI_Test -APIHeader $APIHeader -SiteTest -HypervisorsTest -DeliveryGroupsTest -MachineCatalogsTest
    $testReport = $testResult.Alldata | Where-Object { $_.Serverity -notlike $null } | Sort-Object -Property TestScope
    #endregion

    #######################
    #region Building HTML the report
    #######################

    Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) [Proccessing] Building HTML Page"
    [string]$HTMLReportname = $ReportPath + "\XD_HealthChecks-$($APIHeader.CustomerName)-" + (Get-Date -Format yyyy.MM.dd-HH.mm) + '.html'

    $HeadingText = $($APIHeader.CustomerName) + ' | Report | ' + (Get-Date -Format dd) + ' ' + (Get-Date -Format MMMM) + ',' + (Get-Date -Format yyyy) + ' ' + (Get-Date -Format HH:mm)

    New-HTML -TitleText "$CustomerId Report" -FilePath $HTMLReportname -ShowHTML {
        New-HTMLLogo -RightLogoString $CTXAPI_LogoURL
        New-HTMLHeading -Heading h1 -HeadingText $HeadingText -Color Black
        New-HTMLSection @SectionSettings -Content {
            New-HTMLSection -HeaderText 'Session States' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $sessioncount }
        }
        New-HTMLSection -HeaderText 'Summary' @SectionSettings -Content {
            if ($CConnector) { New-HTMLSection -HeaderText 'Cloud Connectors' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $CConnector }}
            if ($testResult.Summary) { New-HTMLSection -HeaderText 'Test Summary' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $testResult.Summary }}
        }
        New-HTMLSection -HeaderText 'Test Results' @SectionSettings -Content {
            if ($testResult.FatalError) {    New-HTMLSection -HeaderText 'Test Result: Fatal Errors' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $testResult.FatalError }}
            if ($testResult.Error) {    New-HTMLSection -HeaderText 'Test Result: Errors' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $testResult.Error }}
        }
        if ($testReport) {
            New-HTMLSection -HeaderText 'Test Result: Detailed' @SectionSettings -Content {
                New-HTMLSection @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $testReport }
            }
        }
        New-HTMLSection -HeaderText 'Top 5' @SectionSettings -Content {
            if ($connectionRTT) {New-HTMLSection -HeaderText 'Top 5 RTT Sessions' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $connectionRTT }}
            if ($connectionLogon) { New-HTMLSection -HeaderText 'Top 5 Logon Duration' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $connectionLogon }}
        }
        New-HTMLSection -HeaderText 'Failure Logs' @SectionSettings -Content {
            if ($ConnectionFailureReport) {New-HTMLSection -HeaderText 'Connection Failures' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $ConnectionFailureReport }}
            if ($MachineFailureReport) {New-HTMLSection -HeaderText 'Machine Failures' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $MachineFailureReport }}
        }
        if ($configlog) {
            New-HTMLSection -HeaderText 'Config Changes' @SectionSettings -Content {
                New-HTMLSection @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $configlog }
            }
        }
        if ($DeliveryGroups) {
            New-HTMLSection -HeaderText 'Delivery Groups' @SectionSettings -Content {
                New-HTMLSection @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $DeliveryGroups }
            }
        }
        if ($vdauptime) {
            New-HTMLSection -HeaderText 'VDI Uptimes' @SectionSettings -Content {
                New-HTMLSection @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $vdauptime }
            }
        }
        if ($ResourceUtilization) {
            New-HTMLSection -HeaderText 'Resource Utilization' @SectionSettings -Content {
                New-HTMLSection @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $ResourceUtilization }
            }
        }
    }
    #endregion
    trap {
        Write-Warning "Failed to generate report:$($_)"
        continue
    }

} #end Function
 
Export-ModuleMember -Function Get-CTXAPI_HealthCheck
#endregion
 
#region Get-CTXAPI_Hypervisor.ps1
######## Function 12 of 25 ##################
# Function:         Get-CTXAPI_Hypervisor
# Module:           CTXCloudApi
# ModuleVersion:    0.1.26.6
# Author:           Pierre Smit
# Company:          HTPCZA Tech
# CreatedOn:        2022/03/20 13:16:40
# ModifiedOn:       2022/03/20 13:16:40
# Synopsis:         Return details about hosting (hypervisor)
#############################################
 
<#
.SYNOPSIS
Return details about hosting (hypervisor)

.DESCRIPTION
Return details about hosting (hypervisor)

.PARAMETER APIHeader
Use Connect-CTXAPI to create headers

.EXAMPLE
Get-CTXAPI_Hypervisor -APIHeader $APIHeader

#>

Function Get-CTXAPI_Hypervisor {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Hypervisor')]
    [Alias('Get-CTXAPI_Hypervisors')]
    [OutputType([System.Object[]])]
    PARAM(
        [Parameter(Mandatory = $true)]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader
    )

    (Invoke-RestMethod -Uri 'https://api.cloud.com/cvad/manage/hypervisors/' -Method get -Headers $APIHeader.headers).items | ForEach-Object {
        Invoke-RestMethod -Uri "https://api.cloud.com/cvad/manage/hypervisors/$($_.id)" -Method Get -Headers $APIHeader.headers
    }


} #end Function
 
Export-ModuleMember -Function Get-CTXAPI_Hypervisor
#endregion
 
#region Get-CTXAPI_LowLevelOperation.ps1
######## Function 13 of 25 ##################
# Function:         Get-CTXAPI_LowLevelOperation
# Module:           CTXCloudApi
# ModuleVersion:    0.1.26.6
# Author:           Pierre Smit
# Company:          HTPCZA Tech
# CreatedOn:        2022/03/20 13:16:40
# ModifiedOn:       2022/03/20 13:16:40
# Synopsis:         Return details about low lever config change (More detailed)
#############################################
 
<#
.SYNOPSIS
Return details about low lever config change (More detailed)

.DESCRIPTION
Return details about low lever config change (More detailed)

.PARAMETER APIHeader
Use Connect-CTXAPI to create headers

.PARAMETER HighLevelID
Unique id for a config change. From the Get-CTXAPI_ConfigLog function.

.EXAMPLE
$ConfigLog = Get-CTXAPI_ConfigLog -APIHeader $APIHeader -Days 7
$LowLevelOperations = Get-CTXAPI_LowLevelOperation -APIHeader $APIHeader -HighLevelID $ConfigLog[0].id

#>

Function Get-CTXAPI_LowLevelOperation {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_LowLevelOperation')]
    [Alias('Get-CTXAPI_LowLevelOperations')]
    [OutputType([System.Object[]])]
    PARAM(
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
######## Function 14 of 25 ##################
# Function:         Get-CTXAPI_Machine
# Module:           CTXCloudApi
# ModuleVersion:    0.1.26.6
# Author:           Pierre Smit
# Company:          HTPCZA Tech
# CreatedOn:        2022/03/20 13:16:40
# ModifiedOn:       2022/03/20 13:16:40
# Synopsis:         Return details about vda machines
#############################################
 
<#
.SYNOPSIS
Return details about vda machines

.DESCRIPTION
Return details about vda machines

.PARAMETER APIHeader
Use Connect-CTXAPI to create headers

.PARAMETER GetPubDesktop
Get published desktop details

.EXAMPLE
$machines = Get-CTXAPI_Machine -APIHeader $APIHeader

#>

Function Get-CTXAPI_Machine {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Machine')]
    [Alias('Get-CTXAPI_Machines')]
    [OutputType([System.Object[]])]
    PARAM(
        [Parameter(Mandatory = $true)]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader,
        [switch]$GetPubDesktop = $false
    )

    (Invoke-RestMethod -Uri 'https://api.cloud.com/cvad/manage/Machines/' -Method get -Headers $APIHeader.headers).items | ForEach-Object {
        Invoke-RestMethod -Uri "https://api.cloud.com/cvad/manage/Machines/$($_.id)" -Method Get -Headers $APIHeader.headers
    }

    if ($GetPubDesktop) {
        (Invoke-RestMethod -Uri 'https://api.cloud.com/cvad/manage/Machines/' -Method get -Headers $APIHeader.headers).items | ForEach-Object {
            Invoke-RestMethod -Uri "https://api.cloud.com/cvad/manage/Machines/$($_.id)/Desktop" -Method Get -Headers $APIHeader.headers
        }
    }
} #end Function
 
Export-ModuleMember -Function Get-CTXAPI_Machine
#endregion
 
#region Get-CTXAPI_MachineCatalog.ps1
######## Function 15 of 25 ##################
# Function:         Get-CTXAPI_MachineCatalog
# Module:           CTXCloudApi
# ModuleVersion:    0.1.26.6
# Author:           Pierre Smit
# Company:          HTPCZA Tech
# CreatedOn:        2022/03/20 13:16:40
# ModifiedOn:       2022/06/24 22:53:06
# Synopsis:         Return details about machine Catalogs
#############################################
 
<#
.SYNOPSIS
Return details about machine Catalogs

.DESCRIPTION
Return details about machine Catalogs

.PARAMETER APIHeader
Use Connect-CTXAPI to create headers

.EXAMPLE
$MachineCatalogs = Get-CTXAPI_MachineCatalog -APIHeader $APIHeader

#>

Function Get-CTXAPI_MachineCatalog {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_MachineCatalog')]
    [Alias('Get-CTXAPI_MachineCatalogs')]
    [OutputType([System.Object[]])]
    PARAM(
        [Parameter(Mandatory = $true)]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader	)

    (Invoke-RestMethod -Uri 'https://api.cloud.com/cvad/manage/MachineCatalogs/' -Method get -Headers $APIHeader.headers).items | ForEach-Object {
        Invoke-RestMethod -Uri "https://api.cloud.com/cvad/manage/MachineCatalogs/$($_.id)" -Method Get -Headers $APIHeader.headers
    }

} #end Function
 
Export-ModuleMember -Function Get-CTXAPI_MachineCatalog
#endregion
 
#region Get-CTXAPI_MonitorData.ps1
######## Function 16 of 25 ##################
# Function:         Get-CTXAPI_MonitorData
# Module:           CTXCloudApi
# ModuleVersion:    0.1.26.6
# Author:           Pierre Smit
# Company:          HTPCZA Tech
# CreatedOn:        2022/03/20 13:16:40
# ModifiedOn:       2022/09/03 19:16:28
# Synopsis:         Collect Monitoring OData for other reports
#############################################
 
<#
.SYNOPSIS
Collect Monitoring OData for other reports

.DESCRIPTION
Collect Monitoring OData for other reports

.PARAMETER APIHeader
Use Connect-CTXAPI to create headers

.PARAMETER region
Your Cloud instance hosted region.

.PARAMETER hours
Amount of time to report on.

.EXAMPLE
$MonitorData = Get-CTXAPI_MonitorData -APIHeader $APIHeader -region eu -hours 24

#>

Function Get-CTXAPI_MonitorData {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_MonitorData')]
    PARAM(
        [Parameter(Mandatory = $true)]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('us', 'eu', 'ap-s')]
        [string]$region,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [int]$hours
    )

    $timer = [Diagnostics.Stopwatch]::StartNew();
    $APItimer = [Diagnostics.Stopwatch]::StartNew();

    $now = Get-Date -Format yyyy-MM-ddTHH:mm:ss.ffffZ
    $past = ((Get-Date).AddHours(-$hours)).ToString('yyyy-MM-ddTHH:mm:ss.ffffZ')

    $datereport = (Get-Date) - (Get-Date).AddHours(-$hours)

    Write-Color -Text 'Getting data for:' -Color Yellow -LinesBefore 1 -ShowTime
    Write-Color -Text 'Days: ', ([math]::Round($datereport.Totaldays)) -Color Yellow, Cyan -StartTab 4
    Write-Color -Text 'Hours: ', ([math]::Round($datereport.Totalhours)) -Color Yellow, Cyan -StartTab 4 -LinesAfter 2

    [pscustomobject]@{
        PSTypeName                   = 'CTXMonitorData'
        ApplicationActivitySummaries = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\ApplicationActivitySummaries?$filter=(Granularity eq 60 and ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )') -headers $APIHeader.headers
        ApplicationInstances         = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\ApplicationInstances?$filter=(ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )') -headers $APIHeader.headers
        Applications                 = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\Applications') -headers $APIHeader.headers
        Catalogs                     = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\Catalogs') -headers $APIHeader.headers
        ConnectionFailureLogs        = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\ConnectionFailureLogs?$filter=(ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )') -headers $APIHeader.headers
        Connections                  = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\Connections?$apply=filter(ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )') -headers $APIHeader.headers
        DesktopGroups                = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\DesktopGroups') -headers $APIHeader.headers
        DesktopOSDesktopSummaries    = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\DesktopOSDesktopSummaries?$filter=(Granularity eq 60 and ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )') -headers $APIHeader.headers
        FailureLogSummaries          = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\FailureLogSummaries?$filter=(ModifiedDate ge ' + $past + ' )') -headers $APIHeader.headers
        Hypervisors                  = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\Hypervisors') -headers $APIHeader.headers
        LogOnSummaries               = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\LogOnSummaries?$filter=(ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )') -headers $APIHeader.headers
        MachineFailureLogs           = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\MachineFailureLogs?$filter=(ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )') -headers $APIHeader.headers
        MachineMetric                = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\MachineMetric?$filter=(CollectedDate ge ' + $past + ' and CollectedDate le ' + $now + ' )') -headers $APIHeader.headers
        Machines                     = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\Machines') -headers $APIHeader.headers
        ServerOSDesktopSummaries     = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\ServerOSDesktopSummaries?$filter=(Granularity eq 60 and ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )') -headers $APIHeader.headers
        SessionActivitySummaries     = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\SessionActivitySummaries?$filter=(Granularity eq 60 and ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )') -headers $APIHeader.headers
        SessionAutoReconnects        = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\SessionAutoReconnects?$filter=(CreatedDate ge ' + $past + ' and CreatedDate le ' + $now + ' )') -headers $APIHeader.headers
        Session                      = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\Sessions?$apply=filter(ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )') -headers $APIHeader.headers
        Users                        = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\Users') -headers $APIHeader.headers
        #LoadIndexes                  = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\LoadIndexes?$filter=(ModifiedDate ge ' + $past + ' )') -headers $APIHeader.headers
        #LoadIndexSummaries           = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\LoadIndexSummaries?$filter=(ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )') -headers $APIHeader.headers
        LogOnMetrics                 = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\LogOnMetrics?$filter=(UserInitStartDate ge ' + $past + ' and UserInitStartDate le ' + $now + ' )') -headers $APIHeader.headers
        #Processes                    = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\Processes?$filter=(ProcessCreationDate ge ' + $past + ' and ProcessCreationDate le ' + $now + ' )') -headers $APIHeader.headers
        #ProcessUtilization           = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\ProcessUtilization?$filter=(CollectedDate ge ' + $past + ' and CollectedDate le ' + $now + ' )') -headers $APIHeader.headers
        ResourceUtilizationSummary   = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\ResourceUtilizationSummary?$filter=(ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )') -headers $APIHeader.headers
        ResourceUtilization          = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\ResourceUtilization?$filter=(ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )') -headers $APIHeader.headers
        SessionMetrics               = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\SessionMetrics?$apply=filter(CollectedDate ge ' + $past + ' and CollectedDate le ' + $now + ' )') -headers $APIHeader.headers
    }

    $timer.Stop()
    $APItimer.Stop()
} #end Function
 
Export-ModuleMember -Function Get-CTXAPI_MonitorData
#endregion
 
#region Get-CTXAPI_ResourceLocation.ps1
######## Function 17 of 25 ##################
# Function:         Get-CTXAPI_ResourceLocation
# Module:           CTXCloudApi
# ModuleVersion:    0.1.26.6
# Author:           Pierre Smit
# Company:          HTPCZA Tech
# CreatedOn:        2022/03/20 13:16:40
# ModifiedOn:       2022/03/20 13:16:40
# Synopsis:         Get cloud Resource Locations
#############################################
 
<#
.SYNOPSIS
Get cloud Resource Locations

.DESCRIPTION
Get cloud Resource Locations

.PARAMETER APIHeader
Use Connect-CTXAPI to create headers

.EXAMPLE
Get-CTXAPI_ResourceLocation -APIHeader $APIHeader

#>

Function Get-CTXAPI_ResourceLocation {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_ResourceLocation')]
    [Alias('Get-CTXAPI_ResourceLocations')]
    PARAM(
        [Parameter(Mandatory = $true)]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader)


    (Invoke-RestMethod -Uri "https://registry.citrixworkspacesapi.net/$($APIHeader.headers.'Citrix-CustomerId')/resourcelocations" -Headers $APIHeader.headers).items

} #end Function
 
Export-ModuleMember -Function Get-CTXAPI_ResourceLocation
#endregion
 
#region Get-CTXAPI_ResourceUtilization.ps1
######## Function 18 of 25 ##################
# Function:         Get-CTXAPI_ResourceUtilization
# Module:           CTXCloudApi
# ModuleVersion:    0.1.26.6
# Author:           Pierre Smit
# Company:          HTPCZA Tech
# CreatedOn:        2022/03/20 13:16:40
# ModifiedOn:       2022/06/24 23:17:13
# Synopsis:         Resource utilization in the last x hours
#############################################
 
<#
.SYNOPSIS
Resource utilization in the last x hours

.DESCRIPTION
Resource utilization in the last x hours

.PARAMETER APIHeader
Use Connect-CTXAPI to create headers

.PARAMETER MonitorData
Use Get-CTXAPI_MonitorData to create OData

.PARAMETER region
Your Cloud instance hosted region.

.PARAMETER hours
Amount of time to report on.

.PARAMETER Export
In what format to export the reports.

.PARAMETER ReportPath
Destination folder for the exported report.

.EXAMPLE
Get-CTXAPI_ResourceUtilization -MonitorData $MonitorData -Export excel -ReportPath C:\temp\

#>

Function Get-CTXAPI_ResourceUtilization {
    [Cmdletbinding(DefaultParameterSetName = 'Fetch odata', HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_ResourceUtilization')]
    PARAM(
        [Parameter(Mandatory = $true, ParameterSetName = 'Fetch odata')]
        [ValidateNotNullOrEmpty()]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader,
        [Parameter(Mandatory = $false, ParameterSetName = 'Got odata')]
        [PSTypeName('CTXMonitorData')]$MonitorData,
        [Parameter(Mandatory = $false, ParameterSetName = 'Fetch odata')]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('us', 'eu', 'ap-s')]
        [string]$region,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $false, ParameterSetName = 'Fetch odata')]
        [int]$hours = 24,
        [Parameter(Mandatory = $false)]
        [ValidateSet('Excel', 'HTML')]
        [string]$Export = 'Host',
        [Parameter(Mandatory = $false)]
        [ValidateScript( { (Test-Path $_) })]
        [string]$ReportPath = $env:temp
    )

    if ($Null -eq $MonitorData) { $monitor = Get-CTXAPI_MonitorData -APIHeader $APIHeader -region $region -hours $hours }
    else { $monitor = $MonitorData }


    $data = @()
    foreach ($Machines in ($monitor.Machines | Where-Object { $_.MachineRole -ne 1 })) {

        $ResourceUtilization = $monitor.ResourceUtilization | Where-Object { $_.MachineId -eq $Machines.Id }
        $catalog = $monitor.Catalogs | Where-Object { $_.id -eq $Machines.CatalogId } | ForEach-Object { $_.name }
        $desktopgroup = $monitor.DesktopGroups | Where-Object { $_.id -eq $Machines.DesktopGroupId } | ForEach-Object { $_.name }

        try {
            $AVGPercentCpu = [math]::Round(($ResourceUtilization | Measure-Object -Property PercentCpu -Average).Average)
            $AVGUsedMemory = [math]::Ceiling((($ResourceUtilization | Measure-Object -Property UsedMemory -Average).Average) / 1gb)
            $AVGSessionCount = ($ResourceUtilization | Measure-Object -Property SessionCount -Average).Average
            $AVGTotalMemory = [math]::Round($ResourceUtilization[0].TotalMemory / 1gb)

        } catch {Write-Warning "Error: `n`tMessage:$($_.Exception.Message)"}
        $data += [PSCustomObject]@{
            DnsName                  = $Machines.DnsName
            IsInMaintenanceMode      = $Machines.IsInMaintenanceMode
            AgentVersion             = $Machines.AgentVersion
            CurrentRegistrationState = $RegistrationState.($Machines.CurrentRegistrationState)
            OSType                   = $Machines.OSType
            Catalog                  = $catalog
            DesktopGroup             = $desktopgroup
            AVGPercentCpu            = $AVGPercentCpu
            AVGUsedMemory            = $AVGUsedMemory
            AVGTotalMemory           = $AVGTotalMemory
            AVGSessionCount          = $AVGSessionCount
        }
    }
    if ($Export -eq 'Excel') {
        $ExcelOptions = @{
            Path             = $ReportPath + '\Resources_Audit-' + (Get-Date -Format yyyy.MM.dd-HH.mm) + '.xlsx'
            AutoSize         = $True
            AutoFilter       = $True
            TitleBold        = $True
            TitleSize        = '28'
            TitleFillPattern = 'LightTrellis'
            TableStyle       = 'Light20'
            FreezeTopRow     = $True
            FreezePane       = '3'
        }
        $data | Export-Excel -Title 'Resource Audit' -WorksheetName Resources @ExcelOptions
     }
    if ($Export -eq 'HTML') { $data | Out-HtmlView -DisablePaging -Title 'Citrix Resources' -HideFooter -FixedHeader }
    if ($Export -eq 'Host') { $data }

} #end Function
 
Export-ModuleMember -Function Get-CTXAPI_ResourceUtilization
#endregion
 
#region Get-CTXAPI_Session.ps1
######## Function 19 of 25 ##################
# Function:         Get-CTXAPI_Session
# Module:           CTXCloudApi
# ModuleVersion:    0.1.26.6
# Author:           Pierre Smit
# Company:          HTPCZA Tech
# CreatedOn:        2022/03/20 13:16:40
# ModifiedOn:       2022/03/20 13:16:40
# Synopsis:         Return details about current sessions
#############################################
 
<#
.SYNOPSIS
Return details about current sessions

.DESCRIPTION
Return details about current sessions

.PARAMETER APIHeader
Use Connect-CTXAPI to create headers

.EXAMPLE
Get-CTXAPI_Session -APIHeader $APIHeader

#>

Function Get-CTXAPI_Session {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Session')]
    [Alias('Get-CTXAPI_Sessions')]
    [OutputType([System.Object[]])]
    PARAM(
        [Parameter(Mandatory = $true)]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader
    )

    (Invoke-RestMethod -Uri 'https://api.cloud.com/cvad/manage/Sessions/' -Method get -Headers $APIHeader.headers).items
} #end Function
 
Export-ModuleMember -Function Get-CTXAPI_Session
#endregion
 
#region Get-CTXAPI_SiteDetail.ps1
######## Function 20 of 25 ##################
# Function:         Get-CTXAPI_SiteDetail
# Module:           CTXCloudApi
# ModuleVersion:    0.1.26.6
# Author:           Pierre Smit
# Company:          HTPCZA Tech
# CreatedOn:        2022/03/20 13:16:40
# ModifiedOn:       2022/03/20 13:16:40
# Synopsis:         Return details about your farm / site
#############################################
 
<#
.SYNOPSIS
Return details about your farm / site

.DESCRIPTION
Return details about your farm / site

.PARAMETER APIHeader
Use Connect-CTXAPI to create headers

.EXAMPLE
Get-CTXAPI_SiteDetail -APIHeader $APIHeader

#>

Function Get-CTXAPI_SiteDetail {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_SiteDetail')]
    [Alias('Get-CTXAPI_SiteDetails')]
    [OutputType([System.Object[]])]
    PARAM(
        [Parameter(Mandatory = $true)]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader	)

    Invoke-RestMethod -Uri "https://api.cloud.com/cvad/manage/Sites/$($APIHeader.headers.'Citrix-InstanceId')" -Method get -Headers $APIHeader.headers



} #end Function
 
Export-ModuleMember -Function Get-CTXAPI_SiteDetail
#endregion
 
#region Get-CTXAPI_Test.ps1
######## Function 21 of 25 ##################
# Function:         Get-CTXAPI_Test
# Module:           CTXCloudApi
# ModuleVersion:    0.1.26.6
# Author:           Pierre Smit
# Company:          HTPCZA Tech
# CreatedOn:        2022/03/20 13:16:40
# ModifiedOn:       2022/06/24 23:21:36
# Synopsis:         Run Built in Citrix cloud tests
#############################################
 
<#
.SYNOPSIS
Run Built in Citrix cloud tests

.DESCRIPTION
Run Built in Citrix cloud tests

.PARAMETER APIHeader
Use Connect-CTXAPI to create headers

.PARAMETER SiteTest
Perform Site test

.PARAMETER HypervisorsTest
Perform the Hypervisors Test

.PARAMETER DeliveryGroupsTest
Perform the Delivery Groups Test

.PARAMETER MachineCatalogsTest
Perform the Machine Catalogs Test

.PARAMETER Export
In what format to export the reports.

.PARAMETER ReportPath
Destination folder for the exported report.

.EXAMPLE
Get-CTXAPI_Test -APIHeader $APIHeader -SiteTest -HypervisorsTest -DeliveryGroupsTest -MachineCatalogsTest -Export HTML -ReportPath C:\temp

#>

Function Get-CTXAPI_Test {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Test')]
    [Alias('Get-CTXAPI_Tests')]
    [OutputType([System.Collections.Hashtable])]
    PARAM(
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader,
        [switch]$SiteTest = $false,
        [switch]$HypervisorsTest = $false,
        [switch]$DeliveryGroupsTest = $false,
        [switch]$MachineCatalogsTest = $false,
        [Parameter(Mandatory = $false)]
        [ValidateSet('Excel', 'HTML')]
        [string]$Export = 'Host',
        [Parameter(Mandatory = $false)]
        [ValidateScript( { (Test-Path $_) })]
        [string]$ReportPath = $env:temp
    )

    [System.Collections.ArrayList]$data = @()
    [System.Collections.ArrayList]$Sum = @()
    if ($SiteTest) {
        try {
            Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) [Processing] Site Tests"
            try {
                Invoke-RestMethod "https://api.cloud.com/cvad/manage/Sites/$($APIHeader.headers.'Citrix-InstanceId')/`$test?async=true" -Headers $APIHeader.headers -Method Post -ContentType 'application/json'
            }
            catch { Write-Warning "Site Sum Test -- $($_.Exception.Message)" }
            try {
                $SiteTestResult = (Invoke-RestMethod "https://api.cloud.com/cvad/manage/Sites/$($APIHeader.headers.'Citrix-InstanceId')/TestReport" -Headers $APIHeader.headers).TestResults
            }
            catch { Write-Warning "Site Result Test -- $($_.Exception.Message)" }
            if ([bool]$SiteTestResult) { $data.AddRange($SiteTestResult) }
            Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) [Completed] Site Tests"
        }
        catch { Write-Warning $($_.Exception.Message) }
    }

    if ($HypervisorsTest) {
        try {
            Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) [Processing] Hypervisor Tests"
            $HypSum = Get-CTXAPI_Hypervisors -APIHeader $APIHeader | ForEach-Object {
                try {
                    Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) [Processing] $($_.name)"
                    Invoke-RestMethod "https://api.cloud.com/cvad/manage/hypervisors/$($_.id)/`$test" -Headers $APIHeader.headers -Method Post -ContentType 'application/json' | ForEach-Object { [PSCustomObject]@{
                            Test        = 'Hypervisor'
                            Name        = $_.Hypervisor.Name
                            NumPassed   = $_.NumPassed
                            NumWarnings = $_.NumWarnings
                            NumFailures = $_.NumFailures
                        }
                    }
                }
                catch { Write-Warning "Hypervisor Sum Test -- $($_.Exception.Message)" }
            }
            $HypResult = Get-CTXAPI_Hypervisors -APIHeader $APIHeader | ForEach-Object {
                try {
                    Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) [Processing] $($_.name)"
                (Invoke-RestMethod "https://api.cloud.com/cvad/manage/hypervisors/$($_.id)/TestReport" -Headers $APIHeader.headers).TestResults
                }
                catch { Write-Warning "Hypervisor Result Test -- $($_.Exception.Message)" }
            }
            if ([bool]$HypSum) { $sum.AddRange($HypSum) }
            if ([bool]$HypResult) { $data.AddRange($HypResult) }
            Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) [Completed] Hypervisor Tests"
        }
        catch { Write-Warning $($_.Exception.Message) }
    }

    if ($DeliveryGroupsTest) {
        try {
            Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) [Processing] DeliveryGroups Tests"
            $DeliverySum = Get-CTXAPI_DeliveryGroups -APIHeader $APIHeader | ForEach-Object {
                try {
                    Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) [Processing] $($_.name)"
                    Invoke-RestMethod "https://api.cloud.com/cvad/manage/DeliveryGroups/$($_.id)/`$test" -Headers $APIHeader.headers -Method Post -ContentType 'application/json' | ForEach-Object { [PSCustomObject]@{
                            Test        = 'DeliveryGroup'
                            Name        = $_.DeliveryGroup.Name
                            NumPassed   = $_.NumPassed
                            NumWarnings = $_.NumWarnings
                            NumFailures = $_.NumFailures
                        }
                    }
                }
                catch { Write-Warning "DeliveryGroups Sum Test -- $($_.Exception.Message)" }
            }
            $DeliveryResult = Get-CTXAPI_DeliveryGroups -APIHeader $APIHeader | ForEach-Object {
                try {
                    Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) [Processing] $($_.name)"
                (Invoke-RestMethod "https://api.cloud.com/cvad/manage/DeliveryGroups/$($_.id)/TestReport" -Headers $APIHeader.headers).TestResults
                }
                catch { Write-Warning "DeliveryGroups Result Test -- $($_.Exception.Message)" }
            }
            if ([bool]$DeliverySum) { $sum.AddRange($DeliverySum) }
            if ([bool]$DeliveryResult) { $data.AddRange($DeliveryResult) }
            Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) [Completed] DeliveryGroups Tests"
        }
        catch { Write-Warning $($_.Exception.Message) }
    }

    if ($MachineCatalogsTest) {
        try {
            Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) [Processing] MachineCatalogs Tests"
            $MachineCatalogsSum = Get-CTXAPI_MachineCatalogs -APIHeader $APIHeader | ForEach-Object {
                try {
                    Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) [Processing] $($_.name)"
                    Invoke-RestMethod "https://api.cloud.com/cvad/manage/MachineCatalogs/$($_.id)/`$test" -Headers $APIHeader.headers -Method Post -ContentType 'application/json' | ForEach-Object { [PSCustomObject]@{
                            Test        = 'MachineCatalog'
                            Name        = $_.MachineCatalog.Name
                            NumPassed   = $_.NumPassed
                            NumWarnings = $_.NumWarnings
                            NumFailures = $_.NumFailures
                        }
                    }
                }
                catch { Write-Warning "MachineCatalogs Sum Test -- $($_.Exception.Message)" }
            }
            $MachineCatalogsResult = Get-CTXAPI_MachineCatalogs -APIHeader $APIHeader | ForEach-Object {
                try {
                    Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) [Processing] $($_.name)"
                (Invoke-RestMethod "https://api.cloud.com/cvad/manage/MachineCatalogs/$($_.id)/TestReport" -Headers $APIHeader.headers).TestResults
                }
                catch { Write-Warning "MachineCatalogs Result Test -- $($_.Exception.Message)" }
            }
            if ([bool]$MachineCatalogsSum) { $sum.AddRange($MachineCatalogsSum) }
            if ([bool]$MachineCatalogsResult) { $data.AddRange($MachineCatalogsResult) }
            Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) [Completed] MachineCatalogs Tests"
        }
        catch { Write-Warning $($_.Exception.Message) }
    }

    $expandedddata = @()
    foreach ($top in $data) {
        foreach ($item in $top.TestComponents) {
            $expandedddata += [PSCustomObject]@{
                Test                 = $top.TestName
                TestDescription      = $top.TestDescription
                TestScope            = $top.TestScope
                TestServiceTarget    = $top.TestServiceTarget
                TestComponentStatus  = $top.TestComponentStatus
                FormattedTestEndTime = $top.FormattedTestEndTime
                TestComponentTarget  = $item.TestComponentTarget
                Explanation          = $item.ResultDetails[0].Explanation
                Serverity            = $item.ResultDetails[0].Serverity
                Action               = $item.ResultDetails[0].Action
            }
        }
    }
    $expandedddata = $expandedddata | Sort-Object -Unique -Property Test, TestComponentTarget

    $Alldata = @{
        FatalError = $expandedddata | Where-Object { $_.Serverity -like 'FatalError' } | Group-Object -Property TestServiceTarget | Select-Object Name, Count | Sort-Object count -Descending
        Error      = $expandedddata | Where-Object { $_.Serverity -like 'Error' } | Group-Object -Property TestServiceTarget | Select-Object Name, Count | Sort-Object count -Descending
        Alldata    = $expandedddata
        Summary    = $Sum
    }


    if ($Export -eq 'Excel') {
        $ExcelOptions = @{
            Path             = $ReportPath + '\Tests-' + (Get-Date -Format yyyy.MM.dd-HH.mm) + '.xlsx'
            AutoSize         = $True
            AutoFilter       = $True
            TitleBold        = $True
            TitleSize        = '28'
            TitleFillPattern = 'LightTrellis'
            TableStyle       = 'Light20'
            FreezeTopRow     = $True
            FreezePane       = '3'
        }
        $Alldata.FatalError | Export-Excel -Title FatalError -WorksheetName FatalError @ExcelOptions
        $Alldata.Error | Export-Excel -Title Errors -WorksheetName error @ExcelOptions
        $Alldata.Alldata | Export-Excel -Title Alldata -WorksheetName Alldata @ExcelOptions
    }
    if ($Export -eq 'HTML') {
        [string]$HTMLReportname = $ReportPath + '\Tests-' + (Get-Date -Format yyyy.MM.dd-HH.mm) + '.html'
        $HeadingText = $CustomerId + ' | Report | ' + (Get-Date -Format dd) + ' ' + (Get-Date -Format MMMM) + ',' + (Get-Date -Format yyyy) + ' ' + (Get-Date -Format HH:mm)
        New-HTML -TitleText "$CustomerId Report" -FilePath $HTMLReportname -ShowHTML {
            New-HTMLLogo -RightLogoString $CTXAPI_LogoURL
            New-HTMLHeading -Heading h1 -HeadingText $HeadingText -Color Black
            New-HTMLSection @SectionSettings -Content {
                New-HTMLSection -HeaderText 'Fatal Errors' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $Alldata.FatalError }
                New-HTMLSection -HeaderText 'Errors' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $Alldata.Error }
            }
            New-HTMLSection @SectionSettings -Content {
                New-HTMLSection -HeaderText 'Alldata' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $alldata.Alldata }
            }
        }
    }
    if ($Export -eq 'Host') { $Alldata }


} #end Function
 
Export-ModuleMember -Function Get-CTXAPI_Test
#endregion
 
#region Get-CTXAPI_VDAUptime.ps1
######## Function 22 of 25 ##################
# Function:         Get-CTXAPI_VDAUptime
# Module:           CTXCloudApi
# ModuleVersion:    0.1.26.6
# Author:           Pierre Smit
# Company:          HTPCZA Tech
# CreatedOn:        2022/03/20 13:16:40
# ModifiedOn:       2022/06/25 00:35:16
# Synopsis:         Uses Registration date to calculate uptime
#############################################
 
<#
.SYNOPSIS
Uses Registration date to calculate uptime

.DESCRIPTION
Uses Registration date to calculate uptime

.PARAMETER APIHeader
Use Connect-CTXAPI to create headers

.PARAMETER Export
In what format to export the reports.

.PARAMETER ReportPath
Destination folder for the exported report.

.EXAMPLE
Get-CTXAPI_VDAUptime -APIHeader $APIHeader -Export excel -ReportPath C:\temp\

#>

Function Get-CTXAPI_VDAUptime {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_VDAUptime')]
    PARAM(
        [Parameter(Mandatory = $true)]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader,
        [Parameter(Mandatory = $false)]
        [ValidateSet('Excel', 'HTML')]
        [string]$Export = 'Host',
        [Parameter(Mandatory = $false)]
        [ValidateScript( { (Test-Path $_) })]
        [string]$ReportPath = $env:temp)

    try {

    [System.Collections.ArrayList]$complist = @()
        $machines = Get-CTXAPI_Machine -APIHeader $APIHeader

        foreach ($machine in $machines) {
            try {
                
                $lastBootTime = [Datetime]$machine.LastDeregistrationTime

                $Uptime = (New-TimeSpan -Start $lastBootTime -End (Get-Date))
                $SelectProps =
                'Days',
                'Hours',
                'Minutes',
                @{
                    Name       = 'TotalHours'
                    Expression = { [math]::Round($Uptime.TotalHours) }
                },
                @{
                    Name       = 'OnlineSince'
                    Expression = { $LastBootTime }
                },
                @{
                    Name       = 'DayOfWeek'
                    Expression = { $LastBootTime.DayOfWeek }
                }
                $CompUptime = $Uptime | Select-Object $SelectProps
            } catch {Write-Warning "Error: `n`tMessage:$($_.Exception.Message)"} 
            
            [void]$complist.Add([PSCustomObject]@{
                DnsName           = $machine.DnsName
                AgentVersion      = $machine.AgentVersion
                MachineCatalog    = $machine.MachineCatalog.Name
                DeliveryGroup     = $machine.DeliveryGroup.Name
                InMaintenanceMode = $machine.InMaintenanceMode
                IPAddress         = $machine.IPAddress
                OSType            = $machine.OSType
                ProvisioningType  = $machine.ProvisioningType
                SummaryState      = $machine.SummaryState
                FaultState        = $machine.FaultState
                Days              = $CompUptime.Days
                TotalHours        = $CompUptime.TotalHours
                OnlineSince       = $CompUptime.OnlineSince
                DayOfWeek         = $CompUptime.DayOfWeek
                })
            }
    } catch { Write-Warning 'Date calculation failed' }

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
        $complist | Export-Excel -Title VDAUptime -WorksheetName VDAUptime @ExcelOptions
    }
    if ($Export -eq 'HTML') { $complist | Out-HtmlView -DisablePaging -Title 'Citrix Uptime' -HideFooter -FixedHeader }
    if ($Export -eq 'Host') { $complist }

} #end Function


 
Export-ModuleMember -Function Get-CTXAPI_VDAUptime
#endregion
 
#region Get-CTXAPI_Zone.ps1
######## Function 23 of 25 ##################
# Function:         Get-CTXAPI_Zone
# Module:           CTXCloudApi
# ModuleVersion:    0.1.26.6
# Author:           Pierre Smit
# Company:          HTPCZA Tech
# CreatedOn:        2022/03/20 13:16:40
# ModifiedOn:       2022/03/20 13:16:40
# Synopsis:         Get zone details
#############################################
 
<#
.SYNOPSIS
Get zone details

.DESCRIPTION
Get zone details

.PARAMETER APIHeader
Use Connect-CTXAPI to create headers

.EXAMPLE
 Get-CTXAPI_Zone -APIHeader $APIHeader

#>

Function Get-CTXAPI_Zone {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Zone')]
    [Alias('Get-CTXAPI_Zones')]
    [OutputType([System.Object[]])]
    PARAM(
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader
    )

    (Invoke-RestMethod -Uri 'https://api.cloud.com/cvad/manage/Zones/' -Method get -Headers $APIHeader.headers).items | ForEach-Object {
        Invoke-RestMethod -Uri "https://api.cloud.com/cvad/manage/Zones/$($_.id)" -Method Get -Headers $APIHeader.headers
    }
} #end Function
 
Export-ModuleMember -Function Get-CTXAPI_Zone
#endregion
 
#region Set-CTXAPI_ReportColour.ps1
######## Function 24 of 25 ##################
# Function:         Set-CTXAPI_ReportColour
# Module:           CTXCloudApi
# ModuleVersion:    0.1.26.6
# Author:           Pierre Smit
# Company:          HTPCZA Tech
# CreatedOn:        2022/03/20 13:16:40
# ModifiedOn:       2022/03/20 13:16:40
# Synopsis:         Set the colour and logo for HTML Reports
#############################################
 
<#
.SYNOPSIS
Set the colour and logo for HTML Reports

.DESCRIPTION
Set the colour and logo for HTML Reports. It updates the registry keys in HKCU:\Software\CTXCloudApi with the new details and display a test report.

.PARAMETER Color1
New Background Colour # code

.PARAMETER Color2
New foreground Colour # code

.PARAMETER LogoURL
URL to the new Logo

.EXAMPLE
Set-CTXAPI_ReportColour -Color1 '#d22c26' -Color2 '#2bb74e' -LogoURL 'https://gist.githubusercontent.com/default-monochrome.png'

#>
Function Set-CTXAPI_ReportColour {
	[Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Set-CTXAPI_ReportColour')]
	[Alias('Set-CTXAPI_ReportColours')]
	PARAM(
		[string]$Color1 = '#061820',
		[string]$Color2 = '#FFD400',
		[string]$LogoURL = 'https://c.na65.content.force.com/servlet/servlet.ImageServer?id=0150h000003yYnkAAE&oid=00DE0000000c48tMAA'
	)

	Remove-Variable -Name CTXAPI_Color1, CTXAPI_Color2, CTXAPI_LogoURL -Force -ErrorAction SilentlyContinue
	$script:TableSettings = $script:SectionSettings = $script:TableSectionSettings = @{}

	Set-ItemProperty -Path HKCU:\Software\CTXCloudApi -Name Color1 -Value $($Color1)
	Set-ItemProperty -Path HKCU:\Software\CTXCloudApi -Name Color2 -Value $($Color2)
	Set-ItemProperty -Path HKCU:\Software\CTXCloudApi -Name LogoURL -Value $($LogoURL)

	Start-Sleep 2

	$script:CTXAPI_Color1 = Get-ItemPropertyValue -Path HKCU:\Software\CTXCloudApi -Name Color1
	$script:CTXAPI_Color2 = Get-ItemPropertyValue -Path HKCU:\Software\CTXCloudApi -Name Color2
	$script:CTXAPI_LogoURL = Get-ItemPropertyValue -Path HKCU:\Software\CTXCloudApi -Name LogoURL

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
		HeaderTextSize        = '10'
		BorderRadius          = '15px'
	}
	$script:TableSectionSettings = @{
		BackgroundColor       = 'white'
		CanCollapse           = $true
		HeaderBackGroundColor = $CTXAPI_Color2
		HeaderTextAlignment   = 'center'
		HeaderTextColor       = $CTXAPI_Color1
		HeaderTextSize        = '10'
	}
	#endregion

	[string]$HTMLReportname = $env:TEMP + '\Test-color' + (Get-Date -Format yyyy.MM.dd-HH.mm) + '.html'

	$HeadingText = 'Test | Report | ' + (Get-Date -Format dd) + ' ' + (Get-Date -Format MMMM) + ',' + (Get-Date -Format yyyy) + ' ' + (Get-Date -Format HH:mm)

	New-HTML -TitleText 'Report' -FilePath $HTMLReportname -ShowHTML {
		New-HTMLLogo -RightLogoString $CTXAPI_LogoURL
		New-HTMLHeading -Heading h1 -HeadingText $HeadingText -Color Black
		New-HTMLSection @SectionSettings -HeaderText 'Test' -Content {
			New-HTMLSection -HeaderText 'Test2' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable (Get-Process | Select-Object -First 5) }
			New-HTMLSection -HeaderText 'Test3' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable (Get-Service | Select-Object -First 5) }
		}
	}

} #end Function
 
Export-ModuleMember -Function Set-CTXAPI_ReportColour
#endregion
 
#region Test-CTXAPI_Header.ps1
######## Function 25 of 25 ##################
# Function:         Test-CTXAPI_Header
# Module:           CTXCloudApi
# ModuleVersion:    0.1.26.6
# Author:           Pierre Smit
# Company:          HTPCZA Tech
# CreatedOn:        2022/03/20 13:16:40
# ModifiedOn:       2022/03/20 13:16:40
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

Function Test-CTXAPI_Header {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Test-CTXAPI_Header')]
    [Alias('Test-CTXAPI_Headers')]
    [OutputType([System.Boolean[]])]
    PARAM(
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
        }
        else { return $false }
    }
    else { return $true }


} #end Function
 
Export-ModuleMember -Function Test-CTXAPI_Header
#endregion
 
#endregion
 
