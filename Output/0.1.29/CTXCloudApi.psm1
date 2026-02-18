#region Private Functions
#region Export-Odata.ps1
########### Private Function ###############
# Source:           Export-Odata.ps1
# Module:           CTXCloudApi
# ModuleVersion:    0.1.29
# Company:          HTPCZA Tech
# CreatedOn:        11/26/2024 11:31:21 AM
# ModifiedOn:       2/18/2026 9:57:34 AM
############################################
function Export-Odata {
    [OutputType([System.Object[]])]
    param(
        [string]$URI,
        [Hashtable]$headers)



        
    [System.Collections.generic.List[PSObject]]$MonitorDataObject = @()
    $NextLink = $URI

    $uriObj = [Uri]($URI -replace '\\', '/')
    $resourceName = $uriObj.Segments[-1].TrimEnd('/')
    Write-Color -Text 'Fetching :', $resourceName -Color Yellow, Cyan -ShowTime -DateTimeFormat HH:mm:ss -NoNewLine
    $localTimer = [Diagnostics.Stopwatch]::StartNew()
    while (-not([string]::IsNullOrEmpty($NextLink))) {
        try {
            $request = Invoke-RestMethod -Method Get -Uri $NextLink -Headers $headers -ErrorAction Stop
        }
        catch {
            Write-Color -Text ' ERROR ', $_.Exception.Message -Color Red, Yellow -ShowTime -DateTimeFormat HH:mm:ss
            break
        }

        if ($null -eq $request) { break }

        # Detect OData error payloads and stop paging
        $errorProp = $null
        if ($request -is [object] -and $null -ne $request.PSObject) {
            $errorProp = $request.PSObject.Properties['error']
        }
        if ($null -ne $errorProp) {
            $msg = $errorProp.Value.PSObject.Properties['message']
            Write-Color -Text ' OData error: ', ($msg.Value) -Color Red, Yellow -ShowTime -DateTimeFormat HH:mm:ss
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
        if ($null -ne $nextLinkProp -and -not [string]::IsNullOrEmpty($nextLinkProp.Value)) { $NextLink = $nextLinkProp.Value }
        else { $NextLink = $null }
    }
    [String]$seconds = '[' + ([math]::Round($localTimer.Elapsed.TotalSeconds)).ToString() + ' sec]'
    Write-Color $seconds -Color Red
    return $MonitorDataObject

}
#endregion
#region Reports-Variables.ps1
########### Private Function ###############
# Source:           Reports-Variables.ps1
# Module:           CTXCloudApi
# ModuleVersion:    0.1.29
# Company:          HTPCZA Tech
# CreatedOn:        11/26/2024 11:31:29 AM
# ModifiedOn:       2/13/2026 6:12:21 PM
############################################
# https://developer-docs.citrix.com/en-us/monitor-service-odata-api/monitor-service-enums
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
    0   = 'AgentShutdown'
    1   = 'AgentSuspended'
    100	= 'IncompatibleVersion'
    101	= 'AgentAddressResolutionFailed'
    102	= 'AgentNotContactable'
    103	= 'AgentWrongActiveDirectoryOU'
    104	= 'EmptyRegistrationRequest'
    105	= 'MissingRegistrationCapabilities'
    106	= 'MissingAgentVersion'
    107	= 'InconsistentRegistrationCapabilities'
    108	= 'NotLicensedForFeature'
    109	= 'UnsupportedCredentialSecurityversion'
    110	= 'InvalidRegistrationRequest'
    111	= 'SingleMultiSessionMismatch'
    112	= 'FunctionalLevelTooLowForCatalog'
    113	= 'FunctionalLevelTooLowForDesktopGroup'
    200	= 'PowerOff'
    203	= 'AgentRejectedSettingsUpdate'
    206	= 'SessionPrepareFailure'
    207	= 'ContactLost'
    301	= 'BrokerRegistrationLimitReached'
    208	= 'SettingsCreationFailure'
    204	= 'SendSettingsFailure'
    2   = 'AgentRequested'
    201	= 'DesktopRestart'
    202	= 'DesktopRemoved'
    205	= 'SessionAuditFailure'
    300	= 'UnknownError'
    302	= 'RegistrationStateMismatch'
}
$script:MachineFailureType = [PSCustomObject]@{
    4 = 'MaxCapacity'
    2 = 'StuckOnBoot'	
    1 = 'FailedToStart'
}
$script:ConnectionState = [PSCustomObject]@{
    0 =	'Unknown'
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
$script:MachineFaultStateCode = [PSCustomObject]@{
    0 =	'Unknown'
    1	=	'None'
    2	=	'FailedToStart'
    3	=	'StuckOnBoot'
    4	=	'Unregistered'
    5	=	'MaxCapacity'
    6	=	'VirtualMachineNotFound'
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
#endregion
#endregion
 
#region Public Functions
#region Connect-CTXAPI.ps1
######## Function 1 of 20 ##################
# Function:         Connect-CTXAPI
# Module:           CTXCloudApi
# ModuleVersion:    0.1.29
# Author:           Pierre Smit
# Company:          HTPCZA Tech
# CreatedOn:        11/26/2024 11:41:06 AM
# ModifiedOn:       2/18/2026 10:39:37 AM
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

.INPUTS
None. Parameters are not accepted from the pipeline.

.OUTPUTS
CTXAPIHeaderObject. Contains authentication headers and context for CTXCloudApi cmdlets.

.LINK
https://smitpi.github.io/CTXCloudApi/Connect-CTXAPI

.NOTES
The access token typically expires in ~1 hour. Re-run Connect-CTXAPI to refresh headers when needed.

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
######## Function 2 of 20 ##################
# Function:         Get-CTXAPI_Application
# Module:           CTXCloudApi
# ModuleVersion:    0.1.29
# Author:           Pierre Smit
# Company:          HTPCZA Tech
# CreatedOn:        11/26/2024 11:40:56 AM
# ModifiedOn:       2/18/2026 10:39:39 AM
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
System.Object[]
Array of application objects returned from the CVAD Manage API.

.LINK
https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Application

#>

function Get-CTXAPI_Application {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Application')]
    [Alias('Get-CTXAPI_Applications')]
    [OutputType([System.Object[]])]
    param(
        [Parameter(Mandatory = $true)]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader)


    $requestUri = 'https://api-eu.cloud.com/cvad/manage/Applications?limit=1000'
    $response = Invoke-RestMethod -Uri $requestUri -Method GET -Headers $APIHeader.headers

    # Safely get initial continuation token if present
    if ($response.PSObject.Properties['ContinuationToken']) {
        $ContinuationToken = $response.ContinuationToken
    }
    else {
        $ContinuationToken = $null
    }

    while (-not [string]::IsNullOrEmpty($ContinuationToken)) {
        $requestUriContinue = $requestUri + '&continuationtoken=' + $ContinuationToken
        $responsePage = Invoke-RestMethod -Uri $requestUriContinue -Method GET -Headers $APIHeader.headers

        # Merge items from the next page when available
        if ($responsePage.PSObject.Properties['Items']) {
            $response.Items += $responsePage.Items
        }

        # Safely read continuation token for the next page
        if ($responsePage.PSObject.Properties['ContinuationToken'] -and -not [string]::IsNullOrEmpty($responsePage.ContinuationToken)) {
            $ContinuationToken = $responsePage.ContinuationToken
        }
        else {
            $ContinuationToken = $null
        }
    }
    $response.items

} #end Function
 
Export-ModuleMember -Function Get-CTXAPI_Application
#endregion
 
#region Get-CTXAPI_CloudService.ps1
######## Function 3 of 20 ##################
# Function:         Get-CTXAPI_CloudService
# Module:           CTXCloudApi
# ModuleVersion:    0.1.29
# Author:           Pierre Smit
# Company:          HTPCZA Tech
# CreatedOn:        11/26/2024 11:41:40 AM
# ModifiedOn:       2/18/2026 10:39:41 AM
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
System.Object[]
Array of service state objects returned from the Core Workspaces API.

.LINK
https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_CloudService

#>

function Get-CTXAPI_CloudService {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_CloudService')]
    [Alias('Get-CTXAPI_CloudServices')]
    [OutputType([System.Object[]])]
    param(
        [Parameter(Mandatory = $true)]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader)

    (Invoke-RestMethod -Uri "https://core.citrixworkspacesapi.net/$($ApiHeader.headers.'Citrix-CustomerId')/serviceStates" -Headers $ApiHeader.headers).items

} #end Function
 
Export-ModuleMember -Function Get-CTXAPI_CloudService
#endregion
 
#region Get-CTXAPI_ConfigAudit.ps1
######## Function 4 of 20 ##################
# Function:         Get-CTXAPI_ConfigAudit
# Module:           CTXCloudApi
# ModuleVersion:    0.1.29
# Author:           Pierre Smit
# Company:          HTPCZA Tech
# CreatedOn:        11/26/2024 11:40:50 AM
# ModifiedOn:       2/18/2026 10:39:43 AM
# Synopsis:         Reports on system config.
#############################################
 
<#
.SYNOPSIS
Reports on system config.

.DESCRIPTION
Reports on Machine Catalogs, Delivery Groups, Published Applications, and VDI Machines.
Collects audit data and either returns it to the host (default) or exports it to Excel/HTML.

.PARAMETER APIHeader
Header object created by Connect-CTXAPI; contains authentication and context.

.PARAMETER Export
Destination/output for the report. Supported values: Host, Excel, HTML. Default: Host.

.PARAMETER ReportPath
Destination folder for exported files when using Excel or HTML. Defaults to $env:Temp.

.EXAMPLE
Get-CTXAPI_ConfigAudit -APIHeader $APIHeader
Returns a PSCustomObject containing Machine_Catalogs, Delivery_Groups, Published_Apps, and VDI_Devices.

.EXAMPLE
Get-CTXAPI_ConfigAudit -APIHeader $APIHeader -Export Excel -ReportPath C:\Temp
Exports an Excel workbook (XD_Audit-<CustomerName>-<yyyy.MM.dd-HH.mm>.xlsx) with sheets for each dataset.

.EXAMPLE
Get-CTXAPI_ConfigAudit -APIHeader $APIHeader -Export HTML -ReportPath C:\Temp
Generates an HTML report (XD_Audit-<CustomerName>-<yyyy.MM.dd-HH.mm>.html) with tables and branding.

.INPUTS
None. Parameters are not accepted from the pipeline.

.OUTPUTS
When Export is Host: PSCustomObject with properties Machine_Catalogs, Delivery_Groups, Published_Apps, VDI_Devices.
When Export is Excel or HTML: No objects returned; files are written to ReportPath.

.LINK
https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_ConfigAudit

#>

function Get-CTXAPI_ConfigAudit {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_ConfigAudit')]
    param(
        [Parameter(Mandatory = $true)]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader,
        [Parameter(Mandatory = $false)]
        [ValidateSet('Excel', 'HTML', 'Host')]
        [string]$Export = 'Host',
        [Parameter(Mandatory = $false)]
        [ValidateScript( { (Test-Path $_) })]
        [string]$ReportPath = $env:temp
    )

    $catalogs = @()
    Get-CTXAPI_MachineCatalog -APIHeader $APIHeader | ForEach-Object {
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
    $groups = Get-CTXAPI_DeliveryGroup -APIHeader $APIHeader

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
    $applications = Get-CTXAPI_Application -APIHeader $APIHeader

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
    Get-CTXAPI_Machine -APIHeader $APIHeader | ForEach-Object {
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
        if ($catalogs) { $catalogs | Export-Excel -Title Catalogs -WorksheetName Catalogs @ExcelOptions }
        if ($deliverygroups) { $deliverygroups | Export-Excel -Title DeliveryGroups -WorksheetName DeliveryGroups @ExcelOptions }
        if ($apps) { $apps | Export-Excel -Title 'Published Apps' -WorksheetName apps @ExcelOptions }
        if ($machines) { $machines | Export-Excel -Title Machines -WorksheetName machines @ExcelOptions }
    }
    if ($Export -eq 'HTML') {

        [string]$HTMLReportname = $ReportPath + "\XD_Audit-$($APIHeader.CustomerName)-" + (Get-Date -Format yyyy.MM.dd-HH.mm) + '.html'

        New-HTML -TitleText "$($APIHeader.CustomerName) Config Audit" -FilePath $HTMLReportname -ShowHTML {
            New-HTMLLogo -RightLogoString $CTXAPI_LogoURL
            New-HTMLHeading -Heading h1 -HeadingText $HeadingText -Color Black
            if ($catalogs) {
                New-HTMLSection @SectionSettings -Content {
                    New-HTMLSection -HeaderText 'Machine Catalogs' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $catalogs }
                }
            }
            if ($deliverygroups) {
                New-HTMLSection @SectionSettings -Content {
                    New-HTMLSection -HeaderText 'Delivery Groups' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $deliverygroups }
                }
            }
            if ($apps) {
                New-HTMLSection @SectionSettings -Content {
                    New-HTMLSection -HeaderText 'Published Applications' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $apps }
                }
            }
            if ($machines) {
                New-HTMLSection @SectionSettings -Content {
                    New-HTMLSection -HeaderText 'VDI Devices' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $machines }
                }
            }
        }
    }
    if ($Export -eq 'Host') {
        [PSCustomObject]@{
            Machine_Catalogs = $catalogs
            Delivery_Groups  = $deliverygroups
            Published_Apps   = $apps
            VDI_Devices      = $machines
        }
    }
} #end Function
 
Export-ModuleMember -Function Get-CTXAPI_ConfigAudit
#endregion
 
#region Get-CTXAPI_ConfigLog.ps1
######## Function 5 of 20 ##################
# Function:         Get-CTXAPI_ConfigLog
# Module:           CTXCloudApi
# ModuleVersion:    0.1.29
# Author:           Pierre Smit
# Company:          HTPCZA Tech
# CreatedOn:        11/26/2024 11:41:14 AM
# ModifiedOn:       2/18/2026 10:39:44 AM
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
 
#region Get-CTXAPI_ConnectionReport.ps1
######## Function 6 of 20 ##################
# Function:         Get-CTXAPI_ConnectionReport
# Module:           CTXCloudApi
# ModuleVersion:    0.1.29
# Author:           Pierre Smit
# Company:          HTPCZA Tech
# CreatedOn:        11/26/2024 11:41:17 AM
# ModifiedOn:       2/18/2026 10:39:46 AM
# Synopsis:         Creates a connection report from CVAD Monitor data.
#############################################
 
<#
.SYNOPSIS
Creates a connection report from CVAD Monitor data.

.DESCRIPTION
Reports on user session connections for the last X hours.

.PARAMETER APIHeader
Header object created by Connect-CTXAPI; contains authentication and request headers (used to fetch Monitor OData).

.PARAMETER MonitorData
Pre-fetched CVAD Monitor OData created by Get-CTXAPI_MonitorData. If provided, the cmdlet will not fetch data.

.PARAMETER region
Deprecated. Not required.

.PARAMETER hours
Duration window (in hours) to fetch when retrieving Monitor OData. Default: 24.

.PARAMETER Export
Destination/output for the report. Supported values: Host, Excel, HTML. Default: Host.

.PARAMETER ReportPath
Destination folder for exported files when using Excel or HTML. Defaults to $env:Temp.

.EXAMPLE
Get-CTXAPI_ConnectionReport -MonitorData $MonitorData -Export HTML -ReportPath c:\temp
Generates an HTML report titled "Citrix Sessions" with the full dataset.

.EXAMPLE
Get-CTXAPI_ConnectionReport -APIHeader $APIHeader -hours 48 -Export Excel -ReportPath c:\temp
Fetches 48 hours of Monitor data and exports an Excel workbook (Session_Audit-<yyyy.MM.dd-HH.mm>.xlsx).

.EXAMPLE
Get-CTXAPI_ConnectionReport -APIHeader $APIHeader | Select-Object Upn, DnsName, EstablishmentDate, AVG_ICA_RTT
Returns objects to the host and selects common fields for quick inspection.

.INPUTS
None. Parameters are not accepted from the pipeline.

.OUTPUTS
System.Object[]
When Export is Host: array of connection report objects; when Export is Excel/HTML: no output objects and files are written to ReportPath.

.LINK
https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_ConnectionReport

#>

function Get-CTXAPI_ConnectionReport {
    [Cmdletbinding(DefaultParameterSetName = 'Fetch odata', HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_ConnectionReport')]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'Fetch odata')]
        [ValidateNotNullOrEmpty()]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader,
        [Parameter(Mandatory = $false, ParameterSetName = 'Got odata')]
        [PSTypeName('CTXMonitorData')]$MonitorData,
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




    if ($Null -eq $MonitorData) { $mondata = Get-CTXAPI_MonitorData -APIHeader $APIHeader -LastHours $hours }
    else { $mondata = $MonitorData }

    [System.Collections.generic.List[PSObject]]$data = @()
        

    foreach ($connection in $mondata.Connections) {
        Write-Verbose "[$(Get-Date -Format HH:mm:ss) PROCESS] $($mondata.Connections.IndexOf($connection) + 1) of $($mondata.Connections.Count)"
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
        $data.Add([PSCustomObject]@{
                Id                       = $connection.id
                # FullName                 = if ($user.FullName -eq $null) { $user.FullName } else { $user.upn }
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
                AVG_ICA_RTT              = if ($null -eq $avgrtt) { 0 } else { [math]::Round($avgrtt.Average) }
            }) #PSList
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
######## Function 7 of 20 ##################
# Function:         Get-CTXAPI_DeliveryGroup
# Module:           CTXCloudApi
# ModuleVersion:    0.1.29
# Author:           Pierre Smit
# Company:          HTPCZA Tech
# CreatedOn:        11/26/2024 11:40:59 AM
# ModifiedOn:       2/18/2026 10:39:48 AM
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
System.Object[]
Array of delivery group objects returned from the CVAD Manage API.

.LINK
https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_DeliveryGroup

#>

function Get-CTXAPI_DeliveryGroup {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_DeliveryGroup')]
    [Alias('Get-CTXAPI_DeliveryGroups')]
    [OutputType([System.Object[]])]
    param(
        [Parameter(Mandatory = $true)]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader
    )


    
    $requestUri = 'https://api-eu.cloud.com/cvad/manage/DeliveryGroups?limit=1000'
    $response = Invoke-RestMethod -Uri $requestUri -Method GET -Headers $APIHeader.headers

    # Safely get initial continuation token if present
    if ($response.PSObject.Properties['ContinuationToken']) {
        $ContinuationToken = $response.ContinuationToken
    }
    else {
        $ContinuationToken = $null
    }

    while (-not [string]::IsNullOrEmpty($ContinuationToken)) {
        $requestUriContinue = $requestUri + '&continuationtoken=' + $ContinuationToken
        $responsePage = Invoke-RestMethod -Uri $requestUriContinue -Method GET -Headers $APIHeader.headers

        # Merge items from the next page when available
        if ($responsePage.PSObject.Properties['Items']) {
            $response.Items += $responsePage.Items
        }

        # Safely read continuation token for the next page
        if ($responsePage.PSObject.Properties['ContinuationToken'] -and -not [string]::IsNullOrEmpty($responsePage.ContinuationToken)) {
            $ContinuationToken = $responsePage.ContinuationToken
        }
        else {
            $ContinuationToken = $null
        }
    }
    $response.items

} #end Function
 
Export-ModuleMember -Function Get-CTXAPI_DeliveryGroup
#endregion
 
#region Get-CTXAPI_FailureReport.ps1
######## Function 8 of 20 ##################
# Function:         Get-CTXAPI_FailureReport
# Module:           CTXCloudApi
# ModuleVersion:    0.1.29
# Author:           Pierre Smit
# Company:          HTPCZA Tech
# CreatedOn:        11/26/2024 11:41:25 AM
# ModifiedOn:       2/18/2026 10:39:50 AM
# Synopsis:         Reports on connection or machine failures in the last X hours.
#############################################
 
<#
.SYNOPSIS
Reports on connection or machine failures in the last X hours.

.DESCRIPTION
Reports on machine or connection failures in the last X hours using Monitor OData.

.PARAMETER APIHeader
Header object created by Connect-CTXAPI; contains authentication and request headers.

.PARAMETER MonitorData
Pre-fetched CVAD Monitor OData created by Get-CTXAPI_MonitorData. If provided, the cmdlet will not fetch data.

.PARAMETER hours
Duration window (in hours) to fetch when retrieving Monitor OData. Default: 24.

.PARAMETER FailureType
Type of failure to report on. Supported values: Connection, Machine.

.PARAMETER Export
Destination/output for the report. Supported values: Host, Excel, HTML. Default: Host.

.PARAMETER ReportPath
Destination folder for exported files when using Excel or HTML. Defaults to $env:Temp.

.EXAMPLE
Get-CTXAPI_FailureReport -MonitorData $MonitorData -FailureType Connection
Returns connection failures to the host.

.EXAMPLE
Get-CTXAPI_FailureReport -APIHeader $APIHeader -FailureType Machine -hours 48 -Export Excel -ReportPath C:\Temp
Exports machine failures for the last 48 hours to an Excel workbook.

.EXAMPLE
Get-CTXAPI_FailureReport -APIHeader $APIHeader -FailureType Connection | Select-Object User, DnsName, FailureDate, PowerState
Shows common fields for connection failures.

.INPUTS
None. Parameters are not accepted from the pipeline.

.OUTPUTS
System.Object[]
When Export is Host: array of failure report objects; when Export is Excel/HTML: no output objects and files are written to ReportPath.

.LINK
https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_FailureReport

#>

function Get-CTXAPI_FailureReport {
    [Cmdletbinding(DefaultParameterSetName = 'Fetch odata', HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_FailureReport')]
    [Alias('Get-CTXAPI_FailureReports')]
    [OutputType([System.Object[]])]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader,
        [Parameter(Mandatory = $false, ParameterSetName = 'Got odata')]
        [PSTypeName('CTXMonitorData')]$MonitorData,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $false)]
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

    if ($Null -eq $MonitorData) { $mondata = Get-CTXAPI_MonitorData -APIHeader $APIHeader -LastHours $hours }
    else { $mondata = $MonitorData }

    [System.Collections.generic.List[PSObject]]$Data = @()
        
    if ($FailureType -eq 'Machine') {
        Write-Verbose "[$(Get-Date -Format HH:mm:ss) PROCESS] ""Fetching machine data from API"
        $machines = Get-CTXAPI_Machine -APIHeader $APIHeader
        foreach ($log in $mondata.MachineFailureLogs) {
            $MonDataMachine = $mondata.machines | Where-Object { $_.id -like $log.MachineId }
            $MachinesFiltered = $machines | Where-Object { $_.Name -like $MonDataMachine.Name }
            $Data.Add([PSCustomObject]@{
                    Name                     = $MonDataMachine.DnsName
                    AssociatedUserUPNs       = $MonDataMachine.AssociatedUserUPNs
                    OSType                   = $MonDataMachine.OSType
                    FailureStartDate         = $log.FailureStartDate
                    FailureEndDate           = $log.FailureEndDate
                    FaultState               = $MachineFaultStateCode.($log.FaultState)
                    LastDeregistrationReason = $MachinesFiltered.LastDeregistrationReason 
                    LastDeregistrationTime   = $MachinesFiltered.LastDeregistrationTime
                    LastConnectionFailure    = $MachinesFiltered.LastConnectionFailure
                    LastErrorReason          = $MachinesFiltered.LastErrorReason
                    CurrentFaultState        = $MachinesFiltered.FaultState
                    InMaintenanceMode        = $MachinesFiltered.InMaintenanceMode
                    MaintenanceModeReason    = $MachinesFiltered.MaintenanceModeReason
                    RegistrationState        = $MachinesFiltered.RegistrationState
                })

        }
    }
    if ($FailureType -eq 'Connection') {
        foreach ($log in $mondata.ConnectionFailureLogs) {
            $session = $mondata.Session | Where-Object { $_.SessionKey -eq $log.SessionKey }
            $user = $mondata.users | Where-Object { $_.id -like $Session.UserId }
            $mashine = $mondata.machines | Where-Object { $_.id -like $Session.MachineId }
            $Data.Add([PSCustomObject]@{
                    User                       = $user.Upn
                    DnsName                    = $mashine.DnsName
                    CurrentRegistrationState   = $RegistrationState.($mashine.CurrentRegistrationState)
                    FailureDate                = $log.FailureDate
                    ConnectionFailureEnumValue	= $SessionFailureCode.($log.ConnectionFailureEnumValue)
                    IsInMaintenanceMode        = $log.IsInMaintenanceMode
                    PowerState                 = $PowerStateCode.($log.PowerState)
                    RegistrationState          = $RegistrationState.($log.RegistrationState)

                })
        }
    }



    if ($Export -eq 'Excel') { 
        $ExcelOptions = @{
            Path             = $ReportPath + "\$($FailureType)_Failure_Report_" + (Get-Date -Format yyyy.MM.dd-HH.mm) + '.xlsx'
            AutoSize         = $True
            AutoFilter       = $True
            TitleBold        = $True
            TitleSize        = '28'
            TitleFillPattern = 'LightTrellis'
            TableStyle       = 'Light20'
            FreezeTopRow     = $True
            FreezePane       = '3'
        }
        $data | Export-Excel -Title "$($FailureType) Failure" -WorksheetName "$($FailureType) Failure" @ExcelOptions
    }
    if ($Export -eq 'HTML') { $data | Out-HtmlView -DisablePaging -Title 'Citrix Failures' -HideFooter -SearchHighlight -FixedHeader }
    if ($Export -eq 'Host') { $data }

} #end Function
 
Export-ModuleMember -Function Get-CTXAPI_FailureReport
#endregion
 
#region Get-CTXAPI_Hypervisor.ps1
######## Function 9 of 20 ##################
# Function:         Get-CTXAPI_Hypervisor
# Module:           CTXCloudApi
# ModuleVersion:    0.1.29
# Author:           Pierre Smit
# Company:          HTPCZA Tech
# CreatedOn:        11/26/2024 11:41:11 AM
# ModifiedOn:       2/18/2026 10:39:51 AM
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
System.Object[]
Array of hypervisor objects returned from the CVAD Manage API.

.LINK
https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Hypervisor

#>

function Get-CTXAPI_Hypervisor {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Hypervisor')]
    [Alias('Get-CTXAPI_Hypervisors')]
    [OutputType([System.Object[]])]
    param(
        [Parameter(Mandatory = $true)]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader
    )

    $requestUri = 'https://api-eu.cloud.com/cvad/manage/hypervisors?limit=1000'
    $response = Invoke-RestMethod -Uri $requestUri -Method GET -Headers $APIHeader.headers

    # Safely get initial continuation token if present
    if ($response.PSObject.Properties['ContinuationToken']) {
        $ContinuationToken = $response.ContinuationToken
    }
    else {
        $ContinuationToken = $null
    }

    while (-not [string]::IsNullOrEmpty($ContinuationToken)) {
        $requestUriContinue = $requestUri + '&continuationtoken=' + $ContinuationToken
        $responsePage = Invoke-RestMethod -Uri $requestUriContinue -Method GET -Headers $APIHeader.headers

        # Merge items from the next page when available
        if ($responsePage.PSObject.Properties['Items']) {
            $response.Items += $responsePage.Items
        }

        # Safely read continuation token for the next page
        if ($responsePage.PSObject.Properties['ContinuationToken'] -and -not [string]::IsNullOrEmpty($responsePage.ContinuationToken)) {
            $ContinuationToken = $responsePage.ContinuationToken
        }
        else {
            $ContinuationToken = $null
        }
    }
    $response.items


} #end Function
 
Export-ModuleMember -Function Get-CTXAPI_Hypervisor
#endregion
 
#region Get-CTXAPI_LowLevelOperation.ps1
######## Function 10 of 20 ##################
# Function:         Get-CTXAPI_LowLevelOperation
# Module:           CTXCloudApi
# ModuleVersion:    0.1.29
# Author:           Pierre Smit
# Company:          HTPCZA Tech
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
######## Function 11 of 20 ##################
# Function:         Get-CTXAPI_Machine
# Module:           CTXCloudApi
# ModuleVersion:    0.1.29
# Author:           Pierre Smit
# Company:          HTPCZA Tech
# CreatedOn:        11/26/2024 11:40:38 AM
# ModifiedOn:       2/18/2026 10:39:55 AM
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
System.Object[]
Array of machine objects returned from the CVAD Manage API.

.LINK
https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Machine

#>

function Get-CTXAPI_Machine {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Machine')]
    [Alias('Get-CTXAPI_Machines')]
    param(
        [Parameter(Mandatory = $true)]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader
    )

    $requestUri = 'https://api-eu.cloud.com/cvad/manage/Machines?limit=1000'
    $response = Invoke-RestMethod -Uri $requestUri -Method GET -Headers $APIHeader.headers

    # Safely get initial continuation token if present
    if ($response.PSObject.Properties['ContinuationToken']) {
        $ContinuationToken = $response.ContinuationToken
    }
    else {
        $ContinuationToken = $null
    }

    while (-not [string]::IsNullOrEmpty($ContinuationToken)) {
        $requestUriContinue = $requestUri + '&continuationtoken=' + $ContinuationToken
        $responsePage = Invoke-RestMethod -Uri $requestUriContinue -Method GET -Headers $APIHeader.headers

        # Merge items from the next page when available
        if ($responsePage.PSObject.Properties['Items']) {
            $response.Items += $responsePage.Items
        }

        # Safely read continuation token for the next page
        if ($responsePage.PSObject.Properties['ContinuationToken'] -and -not [string]::IsNullOrEmpty($responsePage.ContinuationToken)) {
            $ContinuationToken = $responsePage.ContinuationToken
        }
        else {
            $ContinuationToken = $null
        }
    }
    $response.items
} #end Function
 
Export-ModuleMember -Function Get-CTXAPI_Machine
#endregion
 
#region Get-CTXAPI_MachineCatalog.ps1
######## Function 12 of 20 ##################
# Function:         Get-CTXAPI_MachineCatalog
# Module:           CTXCloudApi
# ModuleVersion:    0.1.29
# Author:           Pierre Smit
# Company:          HTPCZA Tech
# CreatedOn:        11/26/2024 11:40:43 AM
# ModifiedOn:       2/18/2026 10:39:56 AM
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
System.Object[]
Array of machine catalog objects returned from the CVAD Manage API.

.LINK
https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_MachineCatalog

#>

function Get-CTXAPI_MachineCatalog {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_MachineCatalog')]
    [Alias('Get-CTXAPI_MachineCatalogs')]
    [OutputType([System.Object[]])]
    param(
        [Parameter(Mandatory = $true)]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader	)


    $requestUri = 'https://api-eu.cloud.com/cvad/manage/MachineCatalogs?limit=1000'
    $response = Invoke-RestMethod -Uri $requestUri -Method GET -Headers $APIHeader.headers

    # Safely get initial continuation token if present
    if ($response.PSObject.Properties['ContinuationToken']) {
        $ContinuationToken = $response.ContinuationToken
    }
    else {
        $ContinuationToken = $null
    }

    while (-not [string]::IsNullOrEmpty($ContinuationToken)) {
        $requestUriContinue = $requestUri + '&continuationtoken=' + $ContinuationToken
        $responsePage = Invoke-RestMethod -Uri $requestUriContinue -Method GET -Headers $APIHeader.headers

        # Merge items from the next page when available
        if ($responsePage.PSObject.Properties['Items']) {
            $response.Items += $responsePage.Items
        }

        # Safely read continuation token for the next page
        if ($responsePage.PSObject.Properties['ContinuationToken'] -and -not [string]::IsNullOrEmpty($responsePage.ContinuationToken)) {
            $ContinuationToken = $responsePage.ContinuationToken
        }
        else {
            $ContinuationToken = $null
        }
    }
    $response.items

} #end Function
 
Export-ModuleMember -Function Get-CTXAPI_MachineCatalog
#endregion
 
#region Get-CTXAPI_MonitorData.ps1
######## Function 13 of 20 ##################
# Function:         Get-CTXAPI_MonitorData
# Module:           CTXCloudApi
# ModuleVersion:    0.1.29
# Author:           Pierre Smit
# Company:          HTPCZA Tech
# CreatedOn:        11/26/2024 11:41:30 AM
# ModifiedOn:       2/18/2026 10:39:58 AM
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
            'ReconnectSummaries',
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
        
    $timer = [Diagnostics.Stopwatch]::StartNew();
    $APItimer = [Diagnostics.Stopwatch]::StartNew();

    if ($PSCmdlet.ParameterSetName -eq 'hours' -and $null -ne $LastHours) {
        $BeginDate = Get-Date
        $EndDate = (Get-Date).AddHours(-$LastHours)
    }
    elseif ($PSCmdlet.ParameterSetName -eq 'specific') {
        if ($null -eq $BeginDate) { throw 'BeginDate is required when LastHours is not specified' }
        if ($null -eq $EndDate) { throw 'EndDate is required when LastHours is not specified' }
    }
    else {
        throw 'Specify either -LastHours or both -BeginDate and -EndDate.'
    }

    $BeginDateStr = $BeginDate.ToString('yyyy-MM-ddTHH:mm:ss.ffffZ')
    $EndDateStr = $EndDate.ToString('yyyy-MM-ddTHH:mm:ss.ffffZ')

    $datereport = $BeginDate - $EndDate

    Write-Color -Text 'Getting data for:' -Color Yellow -LinesBefore 1 -ShowTime
    Write-Color -Text 'Days: ', ([math]::Round($datereport.Totaldays)) -Color Yellow, Cyan -StartTab 4
    Write-Color -Text 'Hours: ', ([math]::Round($datereport.Totalhours)) -Color Yellow, Cyan -StartTab 4 -LinesAfter 2
    
    # Initialize all potential datasets to avoid strict-mode errors when not selected
    $ApplicationActivitySummaries = $null
    $ApplicationInstances = $null
    $Applications = $null
    $Catalogs = $null
    $ConnectionFailureLogs = $null
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
    $ReconnectSummaries = $null
    $ResourceUtilization = $null
    $ResourceUtilizationSummary = $null
    $ServerOSDesktopSummaries = $null
    $SessionActivitySummaries = $null
    $SessionAutoReconnects = $null
    $Sessions = $null
    $SessionMetrics = $null
    $SessionMetricsLatest = $null
    $Users = $null
    
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'ApplicationActivitySummaries')) { $ApplicationActivitySummaries = Export-Odata -URI ('https://api.cloud.com/monitorodata/ApplicationActivitySummaries?$filter=(Granularity eq 60 and ModifiedDate ge ' + $EndDateStr + ' and ModifiedDate le ' + $BeginDateStr + ' )') -headers $APIHeader.headers }
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'ApplicationInstances')) { $ApplicationInstances = Export-Odata -URI ('https://api.cloud.com/monitorodata/ApplicationInstances?$filter=(ModifiedDate ge ' + $EndDateStr + ' and ModifiedDate le ' + $BeginDateStr + ' )') -headers $APIHeader.headers }
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'Applications')) { $Applications = Export-Odata -URI ('https://api.cloud.com/monitorodata/Applications') -headers $APIHeader.headers }
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'Catalogs')) { $Catalogs = Export-Odata -URI ('https://api.cloud.com/monitorodata/Catalogs') -headers $APIHeader.headers }
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'ConnectionFailureLogs')) { $ConnectionFailureLogs = Export-Odata -URI ('https://api.cloud.com/monitorodata/ConnectionFailureLogs?$filter=(ModifiedDate ge ' + $EndDateStr + ' and ModifiedDate le ' + $BeginDateStr + ' )') -headers $APIHeader.headers }
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'Connections')) { $Connections = Export-Odata -URI ('https://api.cloud.com/monitorodata/Connections?$filter=(ModifiedDate ge ' + $EndDateStr + ' and ModifiedDate le ' + $BeginDateStr + ' )') -headers $APIHeader.headers }
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'DesktopGroups')) { $DesktopGroups = Export-Odata -URI ('https://api.cloud.com/monitorodata/DesktopGroups') -headers $APIHeader.headers }
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'DesktopOSDesktopSummaries')) { $DesktopOSDesktopSummaries = Export-Odata -URI ('https://api.cloud.com/monitorodata/DesktopOSDesktopSummaries?$filter=(Granularity eq 60 and ModifiedDate ge ' + $EndDateStr + ' and ModifiedDate le ' + $BeginDateStr + ' )') -headers $APIHeader.headers }
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'FailureLogSummaries')) { $FailureLogSummaries = Export-Odata -URI ('https://api.cloud.com/monitorodata/FailureLogSummaries?$filter=(ModifiedDate ge ' + $EndDateStr + ' )') -headers $APIHeader.headers }
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'Hypervisors')) { $Hypervisors = Export-Odata -URI ('https://api.cloud.com/monitorodata/Hypervisors') -headers $APIHeader.headers }
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'LogOnMetrics')) { $LogOnMetrics = Export-Odata -URI ('https://api.cloud.com/monitorodata/LogOnMetrics?$filter=(UserInitStartDate ge ' + $EndDateStr + ' and UserInitStartDate le ' + $BeginDateStr + ' )') -headers $APIHeader.headers }
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'LogOnSummaries')) { $LogOnSummaries = Export-Odata -URI ('https://api.cloud.com/monitorodata/LogOnSummaries?$filter=(ModifiedDate ge ' + $EndDateStr + ' and ModifiedDate le ' + $BeginDateStr + ' )') -headers $APIHeader.headers }
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'MachineCosts')) { $MachineCosts = Export-Odata -URI ('https://api.cloud.com/monitorodata/MachineCosts') -headers $APIHeader.headers }
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'MachineCostSavingsSummaries')) { $MachineCostSavingsSummaries = Export-Odata -URI ('https://api.cloud.com/monitorodata/MachineCostSavingsSummaries') -headers $APIHeader.headers }
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'MachineFailureLogs')) { $MachineFailureLogs = Export-Odata -URI ('https://api.cloud.com/monitorodata/MachineFailureLogs?$filter=(ModifiedDate ge ' + $EndDateStr + ' and ModifiedDate le ' + $BeginDateStr + ' )') -headers $APIHeader.headers }
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'MachineMetric')) { $MachineMetric = Export-Odata -URI ('https://api.cloud.com/monitorodata/MachineMetric?$filter=(CollectedDate ge ' + $EndDateStr + ' and CollectedDate le ' + $BeginDateStr + ' )') -headers $APIHeader.headers }
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'Machines')) { $Machines = Export-Odata -URI ('https://api.cloud.com/monitorodata/Machines') -headers $APIHeader.headers }
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'ReconnectSummaries')) { $ReconnectSummaries = Export-Odata -URI ('https://api.cloud.com/monitorodata/ReconnectSummaries') -headers $APIHeader.headers }
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'ResourceUtilization')) { $ResourceUtilization = Export-Odata -URI ('https://api.cloud.com/monitorodata/ResourceUtilization?$filter=(ModifiedDate ge ' + $EndDateStr + ' and ModifiedDate le ' + $BeginDateStr + ' )') -headers $APIHeader.headers }
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'ResourceUtilizationSummary')) { $ResourceUtilizationSummary = Export-Odata -URI ('https://api.cloud.com/monitorodata/ResourceUtilizationSummary?$filter=(ModifiedDate ge ' + $EndDateStr + ' and ModifiedDate le ' + $BeginDateStr + ' )') -headers $APIHeader.headers }
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'ServerOSDesktopSummaries')) { $ServerOSDesktopSummaries = Export-Odata -URI ('https://api.cloud.com/monitorodata/ServerOSDesktopSummaries?$filter=(Granularity eq 60 and ModifiedDate ge ' + $EndDateStr + ' and ModifiedDate le ' + $BeginDateStr + ' )') -headers $APIHeader.headers }
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'SessionActivitySummaries')) { $SessionActivitySummaries = Export-Odata -URI ('https://api.cloud.com/monitorodata/SessionActivitySummaries?$filter=(Granularity eq 60 and ModifiedDate ge ' + $EndDateStr + ' and ModifiedDate le ' + $BeginDateStr + ' )') -headers $APIHeader.headers }
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'SessionAutoReconnects')) { $SessionAutoReconnects = Export-Odata -URI ('https://api.cloud.com/monitorodata/SessionAutoReconnects?$filter=(CreatedDate ge ' + $EndDateStr + ' and CreatedDate le ' + $BeginDateStr + ' )') -headers $APIHeader.headers }
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'Sessions')) { $Sessions = Export-Odata -URI ('https://api.cloud.com/monitorodata/Sessions?$filter=(ModifiedDate ge ' + $EndDateStr + ' and ModifiedDate le ' + $BeginDateStr + ' )') -headers $APIHeader.headers }
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'SessionMetrics')) { $SessionMetrics = Export-Odata -URI ('https://api.cloud.com/monitorodata/SessionMetrics?$filter=(CollectedDate ge ' + $EndDateStr + ' and CollectedDate le ' + $BeginDateStr + ' )') -headers $APIHeader.headers }
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'SessionMetricsLatest')) { $SessionMetricsLatest = Export-Odata -URI ('https://api.cloud.com/monitorodata/SessionMetricsLatest?$filter=(CreatedDate ge ' + $EndDateStr + ' and CreatedDate le ' + $BeginDateStr + ' )') -headers $APIHeader.headers -verbose }
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'Users')) { $Users = Export-Odata -URI ('https://api.cloud.com/monitorodata/Users') -headers $APIHeader.headers }

    $datasets = [pscustomobject]@{
        PSTypeName = 'CTXMonitorData'
    }
    if ($null -ne $ApplicationActivitySummaries) { $datasets | Add-Member -NotePropertyName 'ApplicationActivitySummaries' -NotePropertyValue $ApplicationActivitySummaries }
    if ($null -ne $ApplicationInstances) { $datasets | Add-Member -NotePropertyName 'ApplicationInstances' -NotePropertyValue $ApplicationInstances }
    if ($null -ne $Applications) { $datasets | Add-Member -NotePropertyName 'Applications' -NotePropertyValue $Applications }
    if ($null -ne $Catalogs) { $datasets | Add-Member -NotePropertyName 'Catalogs' -NotePropertyValue $Catalogs }
    if ($null -ne $ConnectionFailureLogs) { $datasets | Add-Member -NotePropertyName 'ConnectionFailureLogs' -NotePropertyValue $ConnectionFailureLogs }
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
    if ($null -ne $ReconnectSummaries) { $datasets | Add-Member -NotePropertyName 'ReconnectSummaries' -NotePropertyValue $ReconnectSummaries }
    if ($null -ne $ResourceUtilization) { $datasets | Add-Member -NotePropertyName 'ResourceUtilization' -NotePropertyValue $ResourceUtilization }
    if ($null -ne $ResourceUtilizationSummary) { $datasets | Add-Member -NotePropertyName 'ResourceUtilizationSummary' -NotePropertyValue $ResourceUtilizationSummary }
    if ($null -ne $ServerOSDesktopSummaries) { $datasets | Add-Member -NotePropertyName 'ServerOSDesktopSummaries' -NotePropertyValue $ServerOSDesktopSummaries }
    if ($null -ne $SessionActivitySummaries) { $datasets | Add-Member -NotePropertyName 'SessionActivitySummaries' -NotePropertyValue $SessionActivitySummaries }
    if ($null -ne $SessionAutoReconnects) { $datasets | Add-Member -NotePropertyName 'SessionAutoReconnects' -NotePropertyValue $SessionAutoReconnects }
    if ($null -ne $Sessions) { $datasets | Add-Member -NotePropertyName 'Sessions' -NotePropertyValue $Sessions }
    if ($null -ne $SessionMetrics) { $datasets | Add-Member -NotePropertyName 'SessionMetrics' -NotePropertyValue $SessionMetrics }
    if ($null -ne $SessionMetricsLatest) { $datasets | Add-Member -NotePropertyName 'SessionMetricsLatest' -NotePropertyValue $SessionMetricsLatest }
    if ($null -ne $Users) { $datasets | Add-Member -NotePropertyName 'Users' -NotePropertyValue $Users }

    $timer.Stop()
    $APItimer.Stop()
    return $datasets
} #end Function


#MachineCostSavingsSummaries  = Export-Odata -URI ('https://api.cloud.com/monitorodata/MachineCostSavingsSummaries?$apply=aggregate(TotalAmountSaved with sum as TotalAmountSavedSum)') -headers $APIHeader.headers
 
Export-ModuleMember -Function Get-CTXAPI_MonitorData
#endregion
 
#region Get-CTXAPI_ResourceLocation.ps1
######## Function 14 of 20 ##################
# Function:         Get-CTXAPI_ResourceLocation
# Module:           CTXCloudApi
# ModuleVersion:    0.1.29
# Author:           Pierre Smit
# Company:          HTPCZA Tech
# CreatedOn:        11/26/2024 11:41:33 AM
# ModifiedOn:       2/18/2026 10:40:00 AM
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
System.Object[]
Array of resource location objects returned from the Registry API.

.LINK
https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_ResourceLocation

#>

function Get-CTXAPI_ResourceLocation {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_ResourceLocation')]
    [Alias('Get-CTXAPI_ResourceLocations')]
    param(
        [Parameter(Mandatory = $true)]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader)


    (Invoke-RestMethod -Uri "https://registry.citrixworkspacesapi.net/$($APIHeader.headers.'Citrix-CustomerId')/resourcelocations" -Headers $APIHeader.headers).items

} #end Function
 
Export-ModuleMember -Function Get-CTXAPI_ResourceLocation
#endregion
 
#region Get-CTXAPI_ResourceUtilization.ps1
######## Function 15 of 20 ##################
# Function:         Get-CTXAPI_ResourceUtilization
# Module:           CTXCloudApi
# ModuleVersion:    0.1.29
# Author:           Pierre Smit
# Company:          HTPCZA Tech
# CreatedOn:        11/26/2024 11:41:03 AM
# ModifiedOn:       2/18/2026 10:40:01 AM
# Synopsis:         Resource utilization in the last X hours.
#############################################
 
<#
.SYNOPSIS
Resource utilization in the last X hours.

.DESCRIPTION
Reports on resource utilization for VDA machines over the past X hours.

.PARAMETER APIHeader
Header object created by Connect-CTXAPI; contains authentication and request headers (used to fetch Monitor OData).

.PARAMETER MonitorData
Pre-fetched CVAD Monitor OData created by Get-CTXAPI_MonitorData. If provided, the cmdlet will not fetch data.

.PARAMETER hours
Duration window (in hours) to fetch when retrieving Monitor OData. Default: 24.

.PARAMETER Export
Destination/output for the report. Supported values: Host, Excel, HTML. Default: Host.

.PARAMETER ReportPath
Destination folder for exported files when using Excel or HTML. Defaults to $env:Temp.

.EXAMPLE
Get-CTXAPI_ResourceUtilization -MonitorData $MonitorData -Export Excel -ReportPath C:\temp\
Exports an Excel workbook (Resources_Audit-<yyyy.MM.dd-HH.mm>.xlsx) with aggregated resource metrics.

.EXAMPLE
Get-CTXAPI_ResourceUtilization -APIHeader $APIHeader -hours 48 -Export HTML -ReportPath C:\temp
Generates an HTML report titled "Citrix Resources" for the last 48 hours.

.EXAMPLE
Get-CTXAPI_ResourceUtilization -APIHeader $APIHeader | Select-Object DnsName, AVGPercentCpu, AVGUsedMemory, AVGSessionCount
Returns objects to the host and selects common fields for quick inspection.

.INPUTS
None. Parameters are not accepted from the pipeline.

.OUTPUTS
System.Object[]
When Export is Host: array of resource utilization objects; when Export is Excel/HTML: no output objects and files are written to ReportPath.

.LINK
https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_ResourceUtilization

#>

function Get-CTXAPI_ResourceUtilization {
    [Cmdletbinding(DefaultParameterSetName = 'Fetch odata', HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_ResourceUtilization')]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'Fetch odata')]
        [ValidateNotNullOrEmpty()]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader,
        [Parameter(Mandatory = $false, ParameterSetName = 'Got odata')]
        [PSTypeName('CTXMonitorData')]$MonitorData,
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

    if ($Null -eq $MonitorData) { $monitor = Get-CTXAPI_MonitorData -APIHeader $APIHeader -LastHours $hours }
    else { $monitor = $MonitorData }
    
   

    [System.Collections.generic.List[PSObject]]$data = @()
    $InGroups = $monitor.ResourceUtilization | Group-Object -Property MachineId
    foreach ($machine in $InGroups) {
        $MachineDetails = $monitor.Machines | Where-Object { $_.id -like $machine.Name }
        $catalog = $monitor.Catalogs | Where-Object { $_.id -eq $MachineDetails.CatalogId } | ForEach-Object { $_.name }
        $desktopgroup = $monitor.DesktopGroups | Where-Object { $_.id -eq $MachineDetails.DesktopGroupId } | ForEach-Object { $_.name }
    
        try {
            $AVGPercentCpu = [math]::Round(($machine.Group | Measure-Object -Property PercentCpu -Average).Average)
            $AVGUsedMemory = [math]::Ceiling((($machine.Group | Measure-Object -Property UsedMemory -Average).Average) / 1gb)
            $AVGSessionCount = [math]::Ceiling(($machine.Group | Measure-Object -Property SessionCount -Average).Average)
            $AVGTotalMemory = [math]::Round($machine.Group[0].TotalMemory / 1gb)

        }
        catch { Write-Warning "Error: `n`tMessage:$($_.Exception.Message)" }
        $data.Add([PSCustomObject]@{
                DnsName                  = $MachineDetails.DnsName
                IsInMaintenanceMode      = $MachineDetails.IsInMaintenanceMode
                AgentVersion             = $MachineDetails.AgentVersion
                CurrentRegistrationState = $RegistrationState.($MachineDetails.CurrentRegistrationState)
                OSType                   = $MachineDetails.OSType
                Catalog                  = $catalog
                DesktopGroup             = $desktopgroup
                AVGPercentCpu            = $AVGPercentCpu
                AVGUsedMemory            = $AVGUsedMemory
                AVGTotalMemory           = $AVGTotalMemory
                AVGSessionCount          = $AVGSessionCount
            })
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
######## Function 16 of 20 ##################
# Function:         Get-CTXAPI_Session
# Module:           CTXCloudApi
# ModuleVersion:    0.1.29
# Author:           Pierre Smit
# Company:          HTPCZA Tech
# CreatedOn:        11/26/2024 11:41:28 AM
# ModifiedOn:       2/18/2026 10:40:03 AM
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
System.Object[]
Array of session objects returned from the CVAD Manage API.

.LINK
https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Session

#>

function Get-CTXAPI_Session {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Session')]
    [Alias('Get-CTXAPI_Sessions')]
    [OutputType([System.Object[]])]
    param(
        [Parameter(Mandatory = $true)]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader
    )
    $requestUri = 'https://api-eu.cloud.com/cvad/manage/Sessions?limit=1000'
    $response = Invoke-RestMethod -Uri $requestUri -Method GET -Headers $APIHeader.headers

    # Safely get initial continuation token if present
    if ($response.PSObject.Properties['ContinuationToken']) {
        $ContinuationToken = $response.ContinuationToken
    }
    else {
        $ContinuationToken = $null
    }

    while (-not [string]::IsNullOrEmpty($ContinuationToken)) {
        $requestUriContinue = $requestUri + '&continuationtoken=' + $ContinuationToken
        $responsePage = Invoke-RestMethod -Uri $requestUriContinue -Method GET -Headers $APIHeader.headers

        # Merge items from the next page when available
        if ($responsePage.PSObject.Properties['Items']) {
            $response.Items += $responsePage.Items
        }

        # Safely read continuation token for the next page
        if ($responsePage.PSObject.Properties['ContinuationToken'] -and -not [string]::IsNullOrEmpty($responsePage.ContinuationToken)) {
            $ContinuationToken = $responsePage.ContinuationToken
        }
        else {
            $ContinuationToken = $null
        }
    }
    $response.items
} #end Function
 
Export-ModuleMember -Function Get-CTXAPI_Session
#endregion
 
#region Get-CTXAPI_SiteDetail.ps1
######## Function 17 of 20 ##################
# Function:         Get-CTXAPI_SiteDetail
# Module:           CTXCloudApi
# ModuleVersion:    0.1.29
# Author:           Pierre Smit
# Company:          HTPCZA Tech
# CreatedOn:        11/26/2024 11:40:39 AM
# ModifiedOn:       2/18/2026 10:40:05 AM
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
System.Object
Site detail object returned from the CVAD Manage API.

.LINK
https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_SiteDetail

#>

function Get-CTXAPI_SiteDetail {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_SiteDetail')]
    [Alias('Get-CTXAPI_SiteDetails')]
    [OutputType([System.Object[]])]
    param(
        [Parameter(Mandatory = $true)]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader	)

    Invoke-RestMethod -Uri "https://api.cloud.com/cvad/manage/Sites/$($APIHeader.headers.'Citrix-InstanceId')" -Method get -Headers $APIHeader.headers



} #end Function
 
Export-ModuleMember -Function Get-CTXAPI_SiteDetail
#endregion
 
#region Get-CTXAPI_VDAUptime.ps1
######## Function 18 of 20 ##################
# Function:         Get-CTXAPI_VDAUptime
# Module:           CTXCloudApi
# ModuleVersion:    0.1.29
# Author:           Pierre Smit
# Company:          HTPCZA Tech
# CreatedOn:        11/26/2024 11:40:45 AM
# ModifiedOn:       2/18/2026 10:38:56 AM
# Synopsis:         Calculate VDA uptime and export or return results.
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
System.Object[]
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
        [string]$ReportPath = $env:temp)

    try {

        [System.Collections.generic.List[PSObject]]$complist = @()
        $machines = Get-CTXAPI_Machine -APIHeader $APIHeader

        foreach ($machine in $machines) {
            try {
                # Safely read and convert the last deregistration/registration time
                if ($machine.PSObject.Properties['LastDeregistrationTime'] -and -not [string]::IsNullOrWhiteSpace($machine.LastDeregistrationTime)) {
                    $lastBootTime = [Datetime]$machine.LastDeregistrationTime
                }
                elseif ($machine.PSObject.Properties['LastRegistrationTime'] -and -not [string]::IsNullOrWhiteSpace($machine.LastRegistrationTime)) {
                    # Fallback to LastRegistrationTime if available
                    $lastBootTime = [Datetime]$machine.LastRegistrationTime
                }
                else {
                    $lastBootTime = $null
                }

                # Compute uptime only when we have a valid start time
                if ($null -ne $lastBootTime) {
                    $Uptime = New-TimeSpan -Start $lastBootTime -End (Get-Date)
                }
                else {
                    $Uptime = $null
                }
            }
            catch { Write-Warning "Error: `n`tMessage:$($_.Exception.Message)" } 
            
            $complist.Add([PSCustomObject]@{
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
                    Days              = if ($null -ne $Uptime) { $Uptime.Days } else { $null }
                    OnlineSince       = if ($null -eq $lastBootTime) { $null } else { $lastBootTime }
                })
        }
    }
    catch { Write-Warning 'Date calculation failed' }
    ##TODO - fix error  Message:Cannot convert null to type "System.DateTime".
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
######## Function 19 of 20 ##################
# Function:         Get-CTXAPI_Zone
# Module:           CTXCloudApi
# ModuleVersion:    0.1.29
# Author:           Pierre Smit
# Company:          HTPCZA Tech
# CreatedOn:        11/26/2024 11:40:48 AM
# ModifiedOn:       2/18/2026 10:40:06 AM
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
System.Object[]
Array of zone objects returned from the CVAD Manage API.

.LINK
https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Zone

#>

function Get-CTXAPI_Zone {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Zone')]
    [Alias('Get-CTXAPI_Zones')]
    [OutputType([System.Object[]])]
    param(
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader
    )

    $requestUri = 'https://api-eu.cloud.com/cvad/manage/Zones?limit=1000'
    $response = Invoke-RestMethod -Uri $requestUri -Method GET -Headers $APIHeader.headers

    # Safely get initial continuation token if present
    if ($response.PSObject.Properties['ContinuationToken']) {
        $ContinuationToken = $response.ContinuationToken
    }
    else {
        $ContinuationToken = $null
    }

    while (-not [string]::IsNullOrEmpty($ContinuationToken)) {
        $requestUriContinue = $requestUri + '&continuationtoken=' + $ContinuationToken
        $responsePage = Invoke-RestMethod -Uri $requestUriContinue -Method GET -Headers $APIHeader.headers

        # Merge items from the next page when available
        if ($responsePage.PSObject.Properties['Items']) {
            $response.Items += $responsePage.Items
        }

        # Safely read continuation token for the next page
        if ($responsePage.PSObject.Properties['ContinuationToken'] -and -not [string]::IsNullOrEmpty($responsePage.ContinuationToken)) {
            $ContinuationToken = $responsePage.ContinuationToken
        }
        else {
            $ContinuationToken = $null
        }
    }
    $response.items
} #end Function
 
Export-ModuleMember -Function Get-CTXAPI_Zone
#endregion
 
#region Test-CTXAPI_Header.ps1
######## Function 20 of 20 ##################
# Function:         Test-CTXAPI_Header
# Module:           CTXCloudApi
# ModuleVersion:    0.1.29
# Author:           Pierre Smit
# Company:          HTPCZA Tech
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
        }
        else { return $false }
    }
    else { return $true }


} #end Function
 
Export-ModuleMember -Function Test-CTXAPI_Header
#endregion
 
#endregion
 
