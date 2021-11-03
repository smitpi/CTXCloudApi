
<#PSScriptInfo

.VERSION 1.1.2

.GUID 38c65711-1b10-4f0e-aa2a-c69d6fb4f8e4

.AUTHOR Pierre Smit

.COMPANYNAME iOCO Tech

.COPYRIGHT

.TAGS api ctx ps

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Created [06/10/2021_21:23] Initial Script Creating
Updated [07/10/2021_13:28] Script info updated for module
Updated [03/11/2021_19:17] Info Upate

.PRIVATEDATA

#> 





<#

.DESCRIPTION 
Reports on machine catalog, delivery groups and published desktops

#>


#.ExternalHelp CTXCloudApi-help.xml
Function Get-CTXAPI_ConfigAudit {
	<#
.SYNOPSIS
Reports on system config

.DESCRIPTION
Reports on machine catalog, delivery groups and published desktops

.PARAMETER APIHeader
Use Connect-CTXAPI to create headers

.PARAMETER Export
In what format to export

.PARAMETER ReportPath
Report destination

.EXAMPLE
Get-CTXAPI_ConfigAudit -APIHeader $APIHeader -Export Excel -ReportPath C:\Temp

#>
	[Cmdletbinding()]
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
		[string]$ExcelReportname = $ReportPath + "\XD_Audit-$($APIHeader.CustomerName)-" + (Get-Date -Format yyyy.MM.dd-HH.mm) + '.xlsx'
		$catalogs | Export-Excel -Path $ExcelReportname -WorksheetName Catalogs -AutoSize -AutoFilter
		$deliverygroups | Export-Excel -Path $ExcelReportname -WorksheetName DeliveryGroups -AutoSize -AutoFilter
		$apps | Export-Excel -Path $ExcelReportname -WorksheetName apps -AutoSize -AutoFilter
		$machines | Export-Excel -Path $ExcelReportname -WorksheetName machines -AutoSize -AutoFilter -Show
	}
	if ($Export -eq 'HTML') {

		[string]$HTMLReportname = $ReportPath + "\XD_Audit-$($APIHeader.CustomerName)-" + (Get-Date -Format yyyy.MM.dd-HH.mm) + '.html'

		New-HTML -TitleText "$($APIHeader.CustomerName) Config Audit" -FilePath $HTMLReportname -ShowHTML {
			New-HTMLLogo -RightLogoString $Logourl
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
