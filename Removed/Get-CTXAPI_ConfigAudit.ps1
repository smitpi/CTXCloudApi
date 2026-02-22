
<#PSScriptInfo

.VERSION 1.1.8

.GUID 96684c79-3633-4bca-be1f-13d2152e9ef7

.AUTHOR Pierre Smit

.COMPANYNAME Private

.COPYRIGHT

.TAGS

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES


.PRIVATEDATA

#>

<# 

.DESCRIPTION 
 Reports on system config. 

#> 



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
    #TODO - fix this
    [System.Collections.generic.List[PSObject]]$catalogs = Get-CTXAPI_MachineCatalog -APIHeader $APIHeader 
        
    # Get-CTXAPI_MachineCatalog -APIHeader $APIHeader | ForEach-Object {
    #     $tmp = [pscustomobject]@{
    #         Name                     = $_.Name
    #         OSType                   = $_.OSType
    #         AllocationType           = $_.AllocationType
    #         AssignedCount            = $_.AssignedCount
    #         AvailableAssignedCount   = $_.AvailableAssignedCount
    #         AvailableCount           = $_.AvailableCount
    #         AvailableUnassignedCount = $_.AvailableUnassignedCount
    #         IsPowerManaged           = $_.IsPowerManaged
    #         IsRemotePC               = $_.IsRemotePC
    #         MinimumFunctionalLevel   = $_.MinimumFunctionalLevel
    #         PersistChanges           = $_.PersistChanges
    #         ProvisioningType         = $_.ProvisioningType
    #         SessionSupport           = $_.SessionSupport
    #         TotalCount               = $_.TotalCount
    #         IsBroken                 = $_.IsBroken
    #         MasterImageName          = $_.ProvisioningScheme.MasterImage.name
    #         MasterImagePath          = $_.ProvisioningScheme.MasterImage.XDPath
    #     }
    #     Write-Verbose $tmp
    #     $catalogs.Add($tmp)
    # }
    [System.Collections.generic.List[PSObject]]$deliverygroups = Get-CTXAPI_DeliveryGroup -APIHeader $APIHeader 
     
    #$groups = Get-CTXAPI_DeliveryGroup -APIHeader $APIHeader

    # foreach ($grp in $groups) {
    #     try {
    #         $SimpleAccessPolicy = $null
    #         if ($grp.SimpleAccessPolicy -and $grp.SimpleAccessPolicy.PSObject.Properties['IncludedUsers']) {
    #             $SimpleAccessPolicy = $grp.SimpleAccessPolicy.IncludedUsers | ForEach-Object { $_.samname }
    #             if ($null -eq $SimpleAccessPolicy) { $SimpleAccessPolicy = 'N/A' }
    #             else { $SimpleAccessPolicy = @(($SimpleAccessPolicy) | Out-String).Trim() }
    #         } else {
    #             $SimpleAccessPolicy = 'N/A'
    #         }
    #         $tmp2 = [pscustomobject]@{
    #             Name                   = if ($grp.PSObject.Properties['Name']) { $grp.Name } else { $null }
    #             UserManagement         = if ($grp.PSObject.Properties['UserManagement']) { $grp.UserManagement } else { $null }
    #             DeliveryType           = if ($grp.PSObject.Properties['DeliveryType']) { $grp.DeliveryType } else { $null }
    #             DesktopsAvailable      = if ($grp.PSObject.Properties['DesktopsAvailable']) { $grp.DesktopsAvailable } else { $null }
    #             DesktopsUnregistered   = if ($grp.PSObject.Properties['DesktopsUnregistered']) { $grp.DesktopsUnregistered } else { $null }
    #             DesktopsFaulted        = if ($grp.PSObject.Properties['DesktopsFaulted']) { $grp.DesktopsFaulted } else { $null }
    #             InMaintenanceMode      = if ($grp.PSObject.Properties['InMaintenanceMode']) { $grp.InMaintenanceMode } else { $null }
    #             IsBroken               = if ($grp.PSObject.Properties['IsBroken']) { $grp.IsBroken } else { $null }
    #             MinimumFunctionalLevel = if ($grp.PSObject.Properties['MinimumFunctionalLevel']) { $grp.MinimumFunctionalLevel } else { $null }
    #             SessionSupport         = if ($grp.PSObject.Properties['SessionSupport']) { $grp.SessionSupport } else { $null }
    #             TotalApplications      = if ($grp.PSObject.Properties['TotalApplications']) { $grp.TotalApplications } else { $null }
    #             TotalDesktops          = if ($grp.PSObject.Properties['TotalDesktops']) { $grp.TotalDesktops } else { $null }
    #             IncludedUsers          = $SimpleAccessPolicy
    #         }
    #         Write-Verbose $tmp2
    #         $deliverygroups.Add($tmp2)
    #     } catch {
    #         Write-Verbose $tmp2
    #         Write-Warning "Error processing delivery group $($grp.Name) - $_.Exception.Message"
    #     }
    # }

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
        if ($catalogs) {$catalogs | Export-Excel -Title Catalogs -WorksheetName Catalogs @ExcelOptions}
        if ($deliverygroups) {$deliverygroups | Export-Excel -Title DeliveryGroups -WorksheetName DeliveryGroups @ExcelOptions}
        if ($apps) {$apps | Export-Excel -Title 'Published Apps' -WorksheetName apps @ExcelOptions}
        if ($machines) {$machines | Export-Excel -Title Machines -WorksheetName machines @ExcelOptions}
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
