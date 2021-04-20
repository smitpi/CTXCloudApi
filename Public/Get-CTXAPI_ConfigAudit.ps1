
<#PSScriptInfo

.VERSION 1.0.2

.GUID 5d786907-3d5c-431d-a8ad-eadbacf8bd5f

.AUTHOR Pierre Smit

.COMPANYNAME iOCO Tech

.COPYRIGHT

.TAGS Citrix

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Created [03/04/2021_10:50] Initital Script Creating
Updated [06/04/2021_09:03] Script Fle Info was updated
Updated [20/04/2021_10:42] Script Fle Info was updated

.PRIVATEDATA

#> 




<# 

.DESCRIPTION 
details about ctx objects 

#Requires Modules ImportExcel

#> 
Param()


Function Get-CTXAPI_ConfigAudit {
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
		[Parameter(Mandatory = $false, Position = 3)]
		[ValidateScript( { (Test-Path $_) })]
		[string]$ReportPath = $env:temp
	)


	$catalogs = @()
	Get-CTXAPI_MachineCatalogs -CustomerId $CustomerId -SiteId $siteid -ApiToken $apitoken | ForEach-Object {
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
	Get-CTXAPI_DeliveryGroups -CustomerId $CustomerId -SiteId $siteid -ApiToken $apitoken | ForEach-Object {
		$SimpleAccessPolicy = $_.SimpleAccessPolicy.IncludedUsers | ForEach-Object { $_.samname }
  $deliverygroups += [pscustomobject]@{
			Name                      = $_.Name
			MachinesInMaintenanceMode = $_.MachinesInMaintenanceMode
			RegisteredMachines        = $_.RegisteredMachines
			TotalMachines             = $_.TotalMachines
			UnassignedMachines        = $_.UnassignedMachines
			UserManagement            = $_.UserManagement
			DeliveryType              = $_.DeliveryType
			DesktopsAvailable         = $_.DesktopsAvailable
			DesktopsUnregistered      = $_.DesktopsUnregistered
			DesktopsFaulted           = $_.DesktopsFaulted
			InMaintenanceMode         = $_.InMaintenanceMode
			IsBroken                  = $_.IsBroken
			MinimumFunctionalLevel    = $_.MinimumFunctionalLevel
			SessionSupport            = $_.SessionSupport
			TotalApplications         = $_.TotalApplications
			TotalDesktops             = $_.TotalDesktops
			IncludedUsers             = @(($SimpleAccessPolicy) | Out-String).Trim()
  }
	}

	$apps = @()
	Get-CTXAPI_Applications -CustomerId $CustomerId -SiteId $siteid -ApiToken $apitoken | ForEach-Object {
		$IncludedUsers = $_.IncludedUsers | ForEach-Object { $_.samname }
  $apps += [pscustomobject]@{
			Name                         = $_.Name
			Visible                      = $_.Visible
			CommandLineExecutable        = $_.InstalledAppProperties.CommandLineExecutable
			CommandLineArguments         = $_.InstalledAppProperties.CommandLineArguments
			Enabled                      = $_.Enabled
			NumAssociatedDeliveryGroups  = $_.NumAssociatedDeliveryGroups
			AssociatedDeliveryGroupUuids = @(($_.AssociatedDeliveryGroupUuids) | Out-String).Trim()
			IncludedUsers                = @(($IncludedUsers) | Out-String).Trim()
  }
	}

	$machines = @()
	Get-CTXAPI_Machines -CustomerId $CustomerId -SiteId $siteid -ApiToken $apitoken | ForEach-Object {
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


	[string]$ExcelReportname = $ReportPath + '\XD_Audit-' + (Get-Date -Format yyyy.MM.dd-HH.mm) + '.xlsx'
	$catalogs | Export-Excel -Path $ExcelReportname -WorksheetName Catalogs -AutoSize -AutoFilter
	$deliverygroups | Export-Excel -Path $ExcelReportname -WorksheetName DeliveryGroups -AutoSize -AutoFilter
	$apps | Export-Excel -Path $ExcelReportname -WorksheetName apps -AutoSize -AutoFilter
	$machines | Export-Excel -Path $ExcelReportname -WorksheetName machines -AutoSize -AutoFilter -Show
} #end Function
