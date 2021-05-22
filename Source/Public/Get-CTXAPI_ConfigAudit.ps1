
<#PSScriptInfo

.VERSION 1.0.3

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
Updated [22/04/2021_11:42] Script Fle Info was updated

.PRIVATEDATA

#> 

#Requires -Module ImportExcel
#Requires -Module PSWriteHTML
#Requires -Module PSWriteColor




<# 

.DESCRIPTION 
Report on Citrix Configuration.

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
		[Parameter(Mandatory = $true, Position = 6)]
		[ValidateSet('Excel', 'HTML', 'Host')]
		[string]$Export,
		[Parameter(Mandatory = $false, Position = 7)]
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
	$groups = Get-CTXAPI_DeliveryGroups -CustomerId $CustomerId -SiteId $siteid -ApiToken $apitoken 
	
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
	$applications = Get-CTXAPI_Applications -CustomerId $CustomerId -SiteId $siteid -ApiToken $apitoken
	
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

	if ($Export -eq 'Excel') { 
		[string]$ExcelReportname = $ReportPath + "\XD_Audit-$CustomerId-" + (Get-Date -Format yyyy.MM.dd-HH.mm) + '.xlsx'
		$catalogs | Export-Excel -Path $ExcelReportname -WorksheetName Catalogs -AutoSize -AutoFilter
		$deliverygroups | Export-Excel -Path $ExcelReportname -WorksheetName DeliveryGroups -AutoSize -AutoFilter
		$apps | Export-Excel -Path $ExcelReportname -WorksheetName apps -AutoSize -AutoFilter
		$machines | Export-Excel -Path $ExcelReportname -WorksheetName machines -AutoSize -AutoFilter -Show 
	} 
	if ($Export -eq 'HTML') { 
		
		$TableSettings = @{
			#Style          = 'stripe'
			Style          = 'cell-border'
			HideFooter     = $true
			OrderMulti     = $true
			TextWhenNoData = 'No Data to display here'
		}

		$SectionSettings = @{
			BackgroundColor       = 'white'
			CanCollapse           = $true
			HeaderBackGroundColor = 'white'
			HeaderTextAlignment   = 'center'
			HeaderTextColor       = 'darkgrey'
		}

		$TableSectionSettings = @{
			BackgroundColor       = 'white'
			HeaderBackGroundColor = 'darkgrey'
			HeaderTextAlignment   = 'center'
			HeaderTextColor       = 'white'
		}
		[string]$HTMLReportname = $ReportPath + "\XD_Audit-$CustomerId-" + (Get-Date -Format yyyy.MM.dd-HH.mm) + '.html'

		New-HTML -TitleText "$CustomerId Config Audit" -FilePath $HTMLReportname -ShowHTML {
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
