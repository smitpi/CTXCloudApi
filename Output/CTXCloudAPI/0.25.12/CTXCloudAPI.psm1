### --- PUBLIC FUNCTIONS --- ###
#Region - Add-CTXAPI_MachineToCatalog.ps1

<#PSScriptInfo

.VERSION 1.0.4

.GUID c910816d-788d-4e5f-b405-cb9f898bb106

.AUTHOR Pierre Smit

.COMPANYNAME iOCO Tech

.COPYRIGHT

.TAGS Citrix PowerShell

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Created [17/04/2021_09=58] Initital Script Creating
Updated [20/04/2021_10:42] Script Fle Info was updated
Updated [22/04/2021_11:42] Script Fle Info was updated
Updated [05/05/2021_00:03] error reporting
Updated [05/05/2021_14:33] 'Update Manifest'

.PRIVATEDATA

#> 









<# 

.DESCRIPTION 
Add manually installed machine to a catalog

#> 

Param()


Function Add-CTXAPI_MachineToCatalog {
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
		[string]$CatalogNameORID,
		[Parameter(Mandatory = $true, Position = 4)]
		[ValidateNotNullOrEmpty()]
		[string]$MachineName
	)
	try {
		if ($MachineName.split('\')[1] -like $null) { Write-Error 'MachineName needs to be in the format DOMAIN\Hostname'; halt }

		$headers = [System.Collections.Hashtable]@{
			Authorization       = "CwsAuth Bearer=$($ApiToken)"
			'Citrix-CustomerId' = $customerId
			Accept              = 'application/json'
		}


		$body = @{MachineName = $MachineName } 
		Invoke-WebRequest "https://api.cloud.com/cvadapis/$siteid/MachineCatalogs/$CatalogNameORID/machines" -Headers $headers -Method Post -Body ($body | ConvertTo-Json) -ContentType 'application/json' | Select-Object StatusCode,StatusDescription
	} catch { Write-Error "Failed to connect to api:$($_)" }

} #end Function
Export-ModuleMember -Function Add-CTXAPI_MachineToCatalog
#EndRegion - Add-CTXAPI_MachineToCatalog.ps1
#Region - Get-CTXAPI_Applications.ps1

<#PSScriptInfo

.VERSION 1.0.3

.GUID be2a50c0-7921-4bcb-a556-606bdf5f4ca7

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
Created [03/04/2021_01:17] Initital Script Creating
Updated [06/04/2021_09:03] Script Fle Info was updated
Updated [20/04/2021_10:42] Script Fle Info was updated
Updated [22/04/2021_11:42] Script Fle Info was updated

.PRIVATEDATA

#> 







<# 

.DESCRIPTION 
Get details on published applications

#> 

Param()


Function Get-CTXAPI_Applications {
	PARAM(
		[Parameter(Mandatory = $true, Position = 0)]
		[ValidateNotNullOrEmpty()]
		[string]$CustomerId,
		[Parameter(Mandatory = $true, Position = 1)]
		[ValidateNotNullOrEmpty()]
		[string]$SiteId,
		[Parameter(Mandatory = $true, Position = 2)]
		[ValidateNotNullOrEmpty()]
		[string]$ApiToken)

	$headers = [System.Collections.Hashtable]@{
		Authorization       = "CwsAuth Bearer=$($ApiToken)"
		'Citrix-CustomerId' = $customerId
		Accept              = 'application/json'
	}
	$apps = @()
	(((Invoke-WebRequest "https://api.cloud.com/cvadapis/$siteid/applications" -Headers $headers).Content | ConvertFrom-Json).items).name | ForEach-Object {
		$apps += ((Invoke-WebRequest "https://api.cloud.com/cvadapis/$siteid/applications/$_" -Headers $headers).Content | ConvertFrom-Json)
	}
	$apps



} #end Function
Export-ModuleMember -Function Get-CTXAPI_Applications
#EndRegion - Get-CTXAPI_Applications.ps1
#Region - Get-CTXAPI_CloudServices.ps1

<#PSScriptInfo

.VERSION 1.0.3

.GUID d169133e-621a-46b4-9782-0ab323ced022

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
Created [03/04/2021_01:33] Initital Script Creating
Updated [06/04/2021_09:03] Script Fle Info was updated
Updated [20/04/2021_10:42] Script Fle Info was updated
Updated [22/04/2021_11:42] Script Fle Info was updated

.PRIVATEDATA

#> 







<# 

.DESCRIPTION 
Get details on the cloud services.

#> 

Param()


Function Get-CTXAPI_CloudServices {
	PARAM(
		[Parameter(Mandatory = $true, Position = 0)]
		[ValidateNotNullOrEmpty()]
		[string]$CustomerId,
		[Parameter(Mandatory = $true, Position = 1)]
		[ValidateNotNullOrEmpty()]
		[string]$SiteId,
		[Parameter(Mandatory = $true, Position = 2)]
		[ValidateNotNullOrEmpty()]
		[string]$ApiToken)

	$headers = [System.Collections.Hashtable]@{
		Authorization       = "CwsAuth Bearer=$($ApiToken)"
		'Citrix-CustomerId' = $customerId
		Accept              = 'application/json'
	}

	((Invoke-WebRequest "https://core.citrixworkspacesapi.net/$customerId/serviceStates" -Headers $headers).Content | ConvertFrom-Json).items


} #end Function
Export-ModuleMember -Function Get-CTXAPI_CloudServices
#EndRegion - Get-CTXAPI_CloudServices.ps1
#Region - Get-CTXAPI_ConfigAudit.ps1

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
Export-ModuleMember -Function Get-CTXAPI_ConfigAudit
#EndRegion - Get-CTXAPI_ConfigAudit.ps1
#Region - Get-CTXAPI_ConfigLog.ps1

<#PSScriptInfo

.VERSION 1.0.3

.GUID 8e3eaddb-c8e2-4cd6-8a70-0fbea6245f4d

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
Created [03/04/2021_01:54] Initital Script Creating
Updated [06/04/2021_09:03] Script Fle Info was updated
Updated [20/04/2021_10:42] Script Fle Info was updated
Updated [22/04/2021_11:42] Script Fle Info was updated

.PRIVATEDATA

#> 







<# 

.DESCRIPTION 
Get high level configuration changes in the last x days

#> 

Param()


Function Get-CTXAPI_ConfigLog {
	PARAM(
		[Parameter(Mandatory = $true, Position = 0)]
		[ValidateNotNullOrEmpty()]
		[string]$CustomerId,
		[Parameter(Mandatory = $true, Position = 1)]
		[ValidateNotNullOrEmpty()]
		[string]$SiteId,
		[Parameter(Mandatory = $true, Position = 2)]
		[ValidateNotNullOrEmpty()]
		[string]$Days,
		[Parameter(Mandatory = $true, Position = 3)]
		[ValidateNotNullOrEmpty()]
		[string]$ApiToken)

	$headers = [System.Collections.Hashtable]@{
		Authorization       = "CwsAuth Bearer=$($ApiToken)"
		'Citrix-CustomerId' = $customerId
		Accept              = 'application/json'
	}


	((Invoke-WebRequest "https://api.cloud.com/cvadapis/$siteid/ConfigLog/Operations?days=$days" -Headers $headers).Content | ConvertFrom-Json).items





} #end Function
Export-ModuleMember -Function Get-CTXAPI_ConfigLog
#EndRegion - Get-CTXAPI_ConfigLog.ps1
#Region - Get-CTXAPI_ConnectionReport.ps1

<#PSScriptInfo

.VERSION 1.0.3

.GUID ccc3348a-02f0-4e82-91bf-d65549ca3533

.AUTHOR Pierre Smit

.COMPANYNAME iOCO Tech

.COPYRIGHT

.TAGS Citrix PowerShell

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Created [20/04/2021_10:46] Initital Script Creating
Updated [22/04/2021_11:42] Script Fle Info was updated
Updated [05/05/2021_00:03] added monitor data
Updated [05/05/2021_14:33] 'Update Manifest'

.PRIVATEDATA

#> 

#Requires -Module ImportExcel
#Requires -Module PSWriteHTML
#Requires -Module PSWriteColor



<# 
.DESCRIPTION 
Report on connections in the last x hours

#> 

Param()


Function Get-CTXAPI_ConnectionReport {
	PARAM(
		[Parameter(Mandatory = $true, Position = 0,ParameterSetName='Fetch odata')]
		[ValidateNotNullOrEmpty()]
		[string]$CustomerId,
		[Parameter(Mandatory = $true, Position = 1,ParameterSetName='Fetch odata')]
		[ValidateNotNullOrEmpty()]
		[string]$SiteId,
		[Parameter(Mandatory = $true, Position = 2,ParameterSetName='Fetch odata')]
		[ValidateNotNullOrEmpty()]
		[string]$ApiToken,
        [Parameter(Mandatory = $false,ParameterSetName='Got odata')]
		[pscustomobject]$MonitorData = $null,
		[Parameter(Mandatory = $false, Position = 4,ParameterSetName='Fetch odata')]
		[ValidateNotNullOrEmpty()]
		[ValidateSet('us', 'eu', 'ap-s')]
		[string]$region,
		[ValidateNotNullOrEmpty()]
		[Parameter(Mandatory = $false, Position = 5,ParameterSetName='Fetch odata')]
		[int]$hours = 24,
		[Parameter(Mandatory = $false, Position = 6)]
		[ValidateSet('Excel', 'HTML')]
		[string]$Export = 'Host',
		[Parameter(Mandatory = $false, Position = 7)]
		[ValidateScript( { (Test-Path $_) })]
		[string]$ReportPath = $env:temp
	)




    if ($Null -eq $MonitorData) { $mondata = Get-CTXAPI_MonitorData -CustomerId $CustomerId -SiteId $siteid -ApiToken $apitoken -region $region -hours $hours }
    else {$mondata = $MonitorData }

	$data = @()
	foreach ($connection in $mondata.Connections) {
		try {
			$OneSession = $mondata.session | Where-Object { $_.SessionKey -eq $connection.SessionKey }
			$user = $mondata.users | Where-Object { $_.id -like $OneSession.UserId }
			$mashine = $mondata.machines | Where-Object { $_.id -like $OneSession.MachineId }
			try {
				$avgrtt = 0
				$mondata.SessionMetrics | Where-Object { $_.Sessionid -like $OneSession.SessionKey } | ForEach-Object { $avgrtt = $avgrtt + $_.IcaRttMS }
				$avgrtt = $avgrtt / ($mondata.SessionMetrics | Where-Object { $_.Sessionid -like $OneSession.SessionKey }).count
			} catch { Write-Warning "Not enough RTT data - $_.Exception.Message" }
		} catch { Write-Warning "Error processing - $_.Exception.Message" }
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
			AVG_ICA_RTT              = [math]::Round($avgrtt)
		}
	}

	if ($Export -eq 'Excel') { $data | Export-Excel -Path ($ReportPath + '\Session_Audit-' + (Get-Date -Format yyyy.MM.dd-HH.mm) + '.xlsx') -AutoSize -AutoFilter -Show } 
	if ($Export -eq 'HTML') { $data | Out-GridHtml -DisablePaging -Title 'Citrix Sessions' -HideFooter -SearchHighlight -FixedHeader }
	if ($Export -eq 'Host') { $data }

} #end Function
Export-ModuleMember -Function Get-CTXAPI_ConnectionReport
#EndRegion - Get-CTXAPI_ConnectionReport.ps1
#Region - Get-CTXAPI_DeliveryGroups.ps1

<#PSScriptInfo

.VERSION 1.0.3

.GUID 1c10d8b3-8ca1-4658-8e1b-fa1a99eaa3db

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
Created [03/04/2021_01:17] Initital Script Creating
Updated [06/04/2021_09:03] Script Fle Info was updated
Updated [20/04/2021_10:42] Script Fle Info was updated
Updated [22/04/2021_11:42] Script Fle Info was updated

.PRIVATEDATA

#> 







<# 

.DESCRIPTION 
Get details about Cloud Delivery Groups

#> 

Param()


Function Get-CTXAPI_DeliveryGroups {
	PARAM(
		[Parameter(Mandatory = $true, Position = 0)]
		[ValidateNotNullOrEmpty()]
		[string]$CustomerId,
		[Parameter(Mandatory = $true, Position = 1)]
		[ValidateNotNullOrEmpty()]
		[string]$SiteId,
		[Parameter(Mandatory = $true, Position = 2)]
		[ValidateNotNullOrEmpty()]
		[string]$ApiToken)

	$headers = [System.Collections.Hashtable]@{
		Authorization       = "CwsAuth Bearer=$($ApiToken)"
		'Citrix-CustomerId' = $customerId
		Accept              = 'application/json'
	}

	$Delgroups = @()
	(((Invoke-WebRequest "https://api.cloud.com/cvadapis/$siteid/deliverygroups" -Headers $headers).Content | ConvertFrom-Json).items).name | ForEach-Object {
		$DelGroups += ((Invoke-WebRequest "https://api.cloud.com/cvadapis/$siteid/deliverygroups/$_" -Headers $headers).Content | ConvertFrom-Json)
	}
	$DelGroups

} #end Function
Export-ModuleMember -Function Get-CTXAPI_DeliveryGroups
#EndRegion - Get-CTXAPI_DeliveryGroups.ps1
#Region - Get-CTXAPI_FailureReport.ps1

<#PSScriptInfo

.VERSION 1.0.4

.GUID bcce614e-ed5b-4f57-b35d-526154d152a9

.AUTHOR Pierre Smit

.COMPANYNAME iOCO Tech

.COPYRIGHT

.TAGS Citrix PowerShell

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Created [22/04/2021_10:08] Initital Script Creating
Updated [22/04/2021_11:42] Script Fle Info was updated
Updated [24/04/2021_07:21] Added details from machines api to extract more data
Updated [05/05/2021_00:03] added monitor data
Updated [05/05/2021_14:33] 'Update Manifest'

.PRIVATEDATA

#> 

#Requires -Module ImportExcel
#Requires -Module PSWriteHTML
#Requires -Module PSWriteColor




<# 

.DESCRIPTION 
Creates a report on connection and machine failures in the last x hours

#> 

Param()


Function Get-CTXAPI_FailureReport {
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
        [Parameter(Mandatory = $false,ParameterSetName='Got odata')]
		[pscustomobject]$MonitorData = $null,
		[Parameter(Mandatory = $false, Position = 3,ParameterSetName='Fetch odata')]
		[ValidateNotNullOrEmpty()]
		[ValidateSet('us', 'eu', 'ap-s')]
		[string]$region,
		[ValidateNotNullOrEmpty()]
		[Parameter(Mandatory = $false, Position = 4,ParameterSetName='Fetch odata')]
		[int]$hours = 24,
		[Parameter(Mandatory = $true, Position = 5)]
		[ValidateNotNullOrEmpty()]
		[ValidateSet('Connection', 'Machine')]
		[string]$FailureType,
		[Parameter(Mandatory = $false, Position = 6)]
		[ValidateSet('Excel', 'HTML')]
		[string]$Export = 'Host',
		[Parameter(Mandatory = $false, Position = 7)]
		[ValidateScript( { (Test-Path $_) })]
		[string]$ReportPath = $env:temp
	)

    if ($Null -eq $MonitorData) { $mondata = Get-CTXAPI_MonitorData -CustomerId $CustomerId -SiteId $siteid -ApiToken $apitoken -region $region -hours $hours }
    else {$mondata = $MonitorData }

	$data = @()

	if ($FailureType -eq 'Machine') {
		$machines = Get-CTXAPI_machines -CustomerId $CustomerId -SiteId $SiteId -ApiToken $ApiToken
		foreach ($log in $mondata.MachineFailureLogs) {
			$MonDataMachine = $mondata.Machines | Where-Object { $_.id -eq $log.MachineId }
			$APIMachine = $machines | Where-Object { $_.dnsname -like $MonDataMachine.DnsName }
			$data += [PSCustomObject]@{
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

			}

		}
	}
	if ($FailureType -eq 'Connection') {
		foreach ($log in $mondata.ConnectionFailureLogs) {
			$session = $mondata.Session | Where-Object { $_.SessionKey -eq $log.SessionKey }
			$user = $mondata.users | Where-Object { $_.id -like $Session.UserId }
			$mashine = $mondata.machines | Where-Object { $_.id -like $Session.MachineId }	
			$data += [PSCustomObject]@{
				UserName                   = $user.UserName
				FullName                   = $user.FullName
				DnsName                    = $mashine.DnsName
				IPAddress                  = $mashine.IPAddress
				CurrentRegistrationState   = $RegistrationState.($mashine.CurrentRegistrationState)
				FailureDate                = $log.FailureDate
				ConnectionFailureEnumValue	= $SessionFailureCode.($log.ConnectionFailureEnumValue)
			}
		}
	}



	if ($Export -eq 'Excel') { $data | Export-Excel -Path ($ReportPath + '\Failure_Audit-' + (Get-Date -Format yyyy.MM.dd-HH.mm) + '.xlsx') -AutoSize -AutoFilter -Show } 
	if ($Export -eq 'HTML') { $data | Out-GridHtml -DisablePaging -Title 'Citrix Failures' -HideFooter -SearchHighlight -FixedHeader }
	if ($Export -eq 'Host') { $data }

} #end Function
Export-ModuleMember -Function Get-CTXAPI_FailureReport
#EndRegion - Get-CTXAPI_FailureReport.ps1
#Region - Get-CTXAPI_HealthCheck.ps1

<#PSScriptInfo

.VERSION 1.0.1

.GUID c7bf330c-de8a-4741-8af7-f8858a0109d4

.AUTHOR Pierre Smit

.COMPANYNAME iOCO Tech

.COPYRIGHT

.TAGS citrix

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Created [05/05/2021_14:43] Initital Script Creating
Updated [05/05/2021_14:45] manifest file

.PRIVATEDATA

#> 

#Requires -Module ImportExcel
#Requires -Module PSWriteHTML
#Requires -Module PSWriteColor

<# 

.DESCRIPTION 
Run report to show usefull information

#> 

Param()




Function Get-CTXAPI_HealthCheck {
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
		[Parameter(Mandatory = $false, Position = 4)]
		[ValidateScript( { (Test-Path $_) })]
		[string]$ReportPath = $env:temp
	)
	#######################
	#region Get data
	#######################
	try {
		Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) [Processing] Config Log"
		$configlog = Get-CTXAPI_ConfigLog -CustomerId $CustomerId -SiteId $SiteId -Days 7 -ApiToken $ApiToken | Group-Object -Property text | Select-Object count,name | Sort-Object -Property count -Descending | Select-Object -First 5

		Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) [Processing] Delivery Groups"
		$DeliveryGroups = Get-CTXAPI_DeliveryGroups -CustomerId $CustomerId -SiteId $SiteId -ApiToken $ApiToken | Select-Object Name,DeliveryType,DesktopsAvailable,DesktopsDisconnected,DesktopsFaulted,DesktopsNeverRegistered,DesktopsUnregistered,InMaintenanceMode,IsBroken,RegisteredMachines,SessionCount

		$MonitorData = Get-CTXAPI_MonitorData -CustomerId $CustomerId -SiteId $SiteId -ApiToken $ApiToken -region $region -hours 24

		Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) [Processing] Connection Report"
		$ConnectionReport = Get-CTXAPI_ConnectionReport -MonitorData $MonitorData
		$connectionRTT = $ConnectionReport | Sort-Object -Property AVG_ICA_RTT -Descending -Unique | Select-Object -First 5 FullName,ClientVersion,ClientAddress,AVG_ICA_RTT
		$connectionLogon = $ConnectionReport | Sort-Object -Property LogOnDuration -Descending -Unique | Select-Object -First 5 FullName,ClientVersion,ClientAddress,LogOnDuration
    
		Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) [Processing] Resource Utilization"
		$ResourceUtilization = Get-CTXAPI_ResourceUtilization -MonitorData $MonitorData

		Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) [Processing] Failure Report"
		$ConnectionFailureReport = Get-CTXAPI_FailureReport -CustomerId $CustomerId -SiteId $SiteId -ApiToken $ApiToken -MonitorData $MonitorData -FailureType Connection
		$MachineFailureReport = Get-CTXAPI_FailureReport -CustomerId $CustomerId -SiteId $SiteId -ApiToken $ApiToken -MonitorData $MonitorData -FailureType Machine | Select-Object Name,IP,OSType,FailureStartDate,FailureEndDate,FaultState


		Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) [Processing] Sessions"
		$sessions = Get-CTXAPI_Sessions -CustomerId $CustomerId -SiteId $SiteId -ApiToken $ApiToken
		$sessioncount = [PSCustomObject]@{
			Connected         = ($sessions | Where-Object { $_.state -like 'active' }).count
			Disconnected      = ($sessions | Where-Object { $_.state -like 'Disconnected' }).count
			ConnectionFailure = $ConnectionFailureReport.count
			MachineFailure    = $MachineFailureReport.count
		}

		Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) Machines"
		$vdauptime = Get-CTXAPI_VDAUptime -CustomerId $CustomerId -SiteId $SiteId -ApiToken $ApiToken
		$machinecount = [PSCustomObject]@{
			Inmaintenance = ($vdauptime | Where-Object { $_.InMaintenanceMode -like 'true' }).count
			DesktopCount  = ($vdauptime | Where-Object { $_.OSType -like 'Windows 10' }).count
			ServerCount   = ($vdauptime | Where-Object { $_.OSType -notlike 'Windows 10' }).count
			AgentVersions = ($vdauptime | Group-Object -Property AgentVersion).count
			NeedsReboot   = ($vdauptime | Where-Object { $_.days -gt 7 }).count
		}
		#endregion
		#######################
		#region Table settings
		#######################

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
			HeaderTextColor       = 'grey'
		}

		$TableSectionSettings = @{
			BackgroundColor       = 'white'
			HeaderBackGroundColor = 'grey'
			HeaderTextAlignment   = 'center'
			HeaderTextColor       = 'white'
		}
		#endregion

		#######################
		#region Building HTML the report
		#######################
		Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) [Proccessing] Building HTML Page"
		[string]$HTMLReportname = $ReportPath + "\XD_HealthChecks-$CustomerId-" + (Get-Date -Format yyyy.MM.dd-HH.mm) + '.html'

		$HeadingText = $CustomerId + ' | Report | ' + (Get-Date -Format dd) + ' ' + (Get-Date -Format MMMM) + ',' + (Get-Date -Format yyyy) + ' ' + (Get-Date -Format HH:mm)

		New-HTML -TitleText "$CustomerId Report" -FilePath $HTMLReportname -ShowHTML {
			New-HTMLHeading -Heading h1 -HeadingText $HeadingText -Color Black
			New-HTMLSection @SectionSettings -Content {
				New-HTMLSection -HeaderText 'Session States' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $sessioncount }
			}
			New-HTMLSection @SectionSettings -Content {
				New-HTMLSection -HeaderText 'Top 5 RTT Sessions' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $connectionRTT }
				New-HTMLSection -HeaderText 'Top 5 Logon Duration' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $connectionLogon }
			}
			New-HTMLSection @SectionSettings -Content {
				New-HTMLSection -HeaderText 'Connection Failures' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $ConnectionFailureReport }
				New-HTMLSection -HeaderText 'Machine Failures' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $MachineFailureReport }
			}
			New-HTMLSection @SectionSettings -Content {
				New-HTMLSection -HeaderText 'Config Changes' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $configlog }
				New-HTMLSection -HeaderText 'Machine Summary' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable ($machinecount.psobject.Properties | Select-Object name,value) }
			}

			New-HTMLSection @SectionSettings -Content {
				New-HTMLSection -HeaderText 'Delivery Groups' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $DeliveryGroups }
			}
			New-HTMLSection @SectionSettings -Content {
				New-HTMLSection -HeaderText 'VDI Uptimes' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $vdauptime }
			}
			New-HTMLSection @SectionSettings -Content {
				New-HTMLSection -HeaderText 'Resource Utilization' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $ResourceUtilization }
			}
		}
		#endregion
	} catch {
		Write-Error "Failed to generate report:$($_)" 
 }

} #end Function
Export-ModuleMember -Function Get-CTXAPI_HealthCheck
#EndRegion - Get-CTXAPI_HealthCheck.ps1
#Region - Get-CTXAPI_Hypervisors.ps1

<#PSScriptInfo

.VERSION 1.0.3

.GUID 49c09b99-1918-4fc5-b536-26162b1f0cff

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
Created [03/04/2021_12:08] Initital Script Creating
Updated [06/04/2021_09:03] Script Fle Info was updated
Updated [20/04/2021_10:42] Script Fle Info was updated
Updated [22/04/2021_11:42] Script Fle Info was updated

.PRIVATEDATA

#> 







<# 

.DESCRIPTION 
Details about Citrix Hypervisors (Hosts)

#> 

Param()


Function Get-CTXAPI_Hypervisors {
	PARAM(
		[Parameter(Mandatory = $true, Position = 0)]
		[ValidateNotNullOrEmpty()]
		[string]$CustomerId,
		[Parameter(Mandatory = $true, Position = 1)]
		[ValidateNotNullOrEmpty()]
		[string]$SiteId,
		[Parameter(Mandatory = $true, Position = 2)]
		[ValidateNotNullOrEmpty()]
		[string]$ApiToken)

	$headers = [System.Collections.Hashtable]@{
		Authorization       = "CwsAuth Bearer=$($ApiToken)"
		'Citrix-CustomerId' = $customerId
		Accept              = 'application/json'
	}


	((Invoke-WebRequest "https://api.cloud.com/cvadapis/$siteid/hypervisors" -Headers $headers).Content | ConvertFrom-Json).items


} #end Function
Export-ModuleMember -Function Get-CTXAPI_Hypervisors
#EndRegion - Get-CTXAPI_Hypervisors.ps1
#Region - Get-CTXAPI_LowLevelOperations.ps1

<#PSScriptInfo

.VERSION 1.0.2

.GUID 47e5e6ae-6d08-41e8-b715-3851367ce1df

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
Created [17/04/2021_11:59] Initital Script Creating
Updated [20/04/2021_10:43] Script Fle Info was updated
Updated [22/04/2021_11:42] Script Fle Info was updated

.PRIVATEDATA

#> 





<# 

.DESCRIPTION 
Get the detailed steps for an High Level Operation

#> 

Param()


Function Get-CTXAPI_LowLevelOperations {
PARAM(
		[Parameter(Mandatory = $true, Position = 0)]
		[ValidateNotNullOrEmpty()]
		[string]$CustomerId,
		[Parameter(Mandatory = $true, Position = 1)]
		[ValidateNotNullOrEmpty()]
		[string]$SiteId,
		[Parameter(Mandatory = $true, Position = 2)]
		[ValidateNotNullOrEmpty()]
		[string]$HighLevelID,
		[Parameter(Mandatory = $true, Position = 3)]
		[ValidateNotNullOrEmpty()]
		[string]$ApiToken)


	$headers = [System.Collections.Hashtable]@{
		Authorization       = "CwsAuth Bearer=$($ApiToken)"
		'Citrix-CustomerId' = $customerId
		Accept              = 'application/json'
	}


	((Invoke-WebRequest "https://api.cloud.com/cvadapis/$siteid/ConfigLog/Operations/$HighLevelID/LowLevelOperations" -Headers $headers).Content | ConvertFrom-Json).items

} #end Function
Export-ModuleMember -Function Get-CTXAPI_LowLevelOperations
#EndRegion - Get-CTXAPI_LowLevelOperations.ps1
#Region - Get-CTXAPI_MachineCatalogs.ps1

<#PSScriptInfo

.VERSION 1.0.3

.GUID d8e1762b-129a-47c8-bec8-04d8c74701e7

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
Created [03/04/2021_01:07] Initital Script Creating
Updated [06/04/2021_09:03] Script Fle Info was updated
Updated [20/04/2021_10:43] Script Fle Info was updated
Updated [22/04/2021_11:42] Script Fle Info was updated

.PRIVATEDATA

#> 







<# 

.DESCRIPTION 
Get details about Cloud MachineCatalogs

#> 

Param()


Function Get-CTXAPI_MachineCatalogs {
	PARAM(
		[Parameter(Mandatory = $true, Position = 0)]
		[ValidateNotNullOrEmpty()]
		[string]$CustomerId,
		[Parameter(Mandatory = $true, Position = 1)]
		[ValidateNotNullOrEmpty()]
		[string]$SiteId,
		[Parameter(Mandatory = $true, Position = 2)]
		[ValidateNotNullOrEmpty()]
		[string]$ApiToken)

	$headers = [System.Collections.Hashtable]@{
		Authorization       = "CwsAuth Bearer=$($ApiToken)"
		'Citrix-CustomerId' = $customerId
		Accept              = 'application/json'
	}

	$MachineCat = @()
	(((Invoke-WebRequest "https://api.cloud.com/cvadapis/$siteid/MachineCatalogs" -Headers $headers).Content | ConvertFrom-Json).items).name | ForEach-Object {
		$MachineCat += ((Invoke-WebRequest "https://api.cloud.com/cvadapis/$siteid/MachineCatalogs/$_" -Headers $headers).Content | ConvertFrom-Json)
	}
	$MachineCat
} #end Function
Export-ModuleMember -Function Get-CTXAPI_MachineCatalogs
#EndRegion - Get-CTXAPI_MachineCatalogs.ps1
#Region - Get-CTXAPI_Machines.ps1

<#PSScriptInfo

.VERSION 1.0.4

.GUID a89d5b14-84f0-4461-ae32-fecbc349aa80

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
Created [03/04/2021_01:49] Initital Script Creating
Updated [06/04/2021_09:03] Script Fle Info was updated
Updated [20/04/2021_10:43] Script Fle Info was updated
Updated [22/04/2021_11:42] Script Fle Info was updated
Updated [05/05/2021_14:33] 'Update Manifest'

.PRIVATEDATA

#> 









<# 

.DESCRIPTION 
Get details about VDA Machines

#> 

Param()


Function Get-CTXAPI_Machines
{
	PARAM(
		[Parameter(Mandatory = $true, Position = 0)]
		[ValidateNotNullOrEmpty()]
		[string]$CustomerId,
		[Parameter(Mandatory = $true, Position = 1)]
		[ValidateNotNullOrEmpty()]
		[string]$SiteId,
		[Parameter(Mandatory = $true, Position = 2)]
		[ValidateNotNullOrEmpty()]
		[string]$ApiToken)

	$headers = [System.Collections.Hashtable]@{
		Authorization       = "CwsAuth Bearer=$($ApiToken)"
		'Citrix-CustomerId' = $customerId
		Accept              = 'application/json'
	}

	((Invoke-WebRequest "https://api.cloud.com/cvadapis/$siteid/machines" -Headers $headers).Content | ConvertFrom-Json).items

	<#
	$machines = @()
	(((Invoke-WebRequest "https://api.cloud.com/cvadapis/$siteid/machines" -Headers $headers).Content | ConvertFrom-Json).items).Dnsname | ForEach-Object {
		$machines += ((Invoke-WebRequest "https://api.cloud.com/cvadapis/$siteid/machines/$_" -Headers $headers).Content | ConvertFrom-Json)
	}
	$machines
#>

} #end Function
Export-ModuleMember -Function Get-CTXAPI_Machines
#EndRegion - Get-CTXAPI_Machines.ps1
#Region - Get-CTXAPI_MonitorData.ps1

<#PSScriptInfo

.VERSION 1.0.4

.GUID ce76995e-894d-40ee-ac4a-f700cd9abd01

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
Created [20/04/2021_12:17] Initital Script Creating
Updated [22/04/2021_11:42] Script Fle Info was updated
Updated [23/04/2021_19:03] Reports on progress
Updated [24/04/2021_07:21] added more api calls
Updated [05/05/2021_14:33] 'Update Manifest'

.PRIVATEDATA

#> 

#Requires -Module PSWriteColor





<# 

.DESCRIPTION 
Get monitoring data

#> 

Param()


Function Get-CTXAPI_MonitorData {
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
		[Parameter(Mandatory = $true, Position = 4)]
		[int]$hours
)



	$timer = [Diagnostics.Stopwatch]::StartNew();
	$APItimer = [Diagnostics.Stopwatch]::StartNew();
	$headers = [System.Collections.Hashtable]@{
		Authorization       = "CwsAuth Bearer=$($ApiToken)"
		'Citrix-CustomerId' = $customerId
		Accept              = 'application/json'
	}
	$now = Get-Date -Format yyyy-MM-ddTHH:mm:ss.ffffZ
	$past = ((Get-Date).AddHours(-$hours)).ToString('yyyy-MM-ddTHH:mm:ss.ffffZ')

		$datereport = (Get-Date) - (Get-Date).AddHours(-$hours)

		Write-Color -Text 'Getting data for:' -Color Yellow -LinesBefore 1 -ShowTime
		Write-Color -Text 'Days: ',([math]::Round($datereport.Totaldays)) -Color Yellow,Cyan -StartTab 4
		Write-Color -Text 'Hours: ',([math]::Round($datereport.Totalhours)) -Color Yellow,Cyan -StartTab 4 -LinesAfter 2

		[pscustomobject]@{
			ApplicationActivitySummaries = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\ApplicationActivitySummaries?$filter=(Granularity eq 60 and ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )') -headers $headers
			ApplicationInstances         = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\ApplicationInstances?$filter=(ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )') -headers $headers
			Applications                 = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\Applications') -headers $headers			
            Catalogs                     = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\Catalogs') -headers $headers
			ConnectionFailureLogs        = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\ConnectionFailureLogs?$filter=(ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )') -headers $headers
			Connections                  = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\Connections?$apply=filter(ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )') -headers $headers
			DesktopGroups                = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\DesktopGroups') -headers $headers
			DesktopOSDesktopSummaries    = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\DesktopOSDesktopSummaries?$filter=(Granularity eq 60 and ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )') -headers $headers
			FailureLogSummaries          = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\FailureLogSummaries?$filter=(ModifiedDate ge ' + $past + ' )') -headers $headers
			Hypervisors                  = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\Hypervisors') -headers $headers
			LogOnSummaries               = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\LogOnSummaries?$filter=(ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )') -headers $headers
			MachineFailureLogs           = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\MachineFailureLogs?$filter=(ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )') -headers $headers
			MachineMetric                = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\MachineMetric?$filter=(CollectedDate ge ' + $past + ' and CollectedDate le ' + $now + ' )') -headers $headers
			Machines                     = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\Machines') -headers $headers
			ServerOSDesktopSummaries     = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\ServerOSDesktopSummaries?$filter=(Granularity eq 60 and ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )') -headers $headers
			SessionActivitySummaries     = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\SessionActivitySummaries?$filter=(Granularity eq 60 and ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )') -headers $headers
			SessionAutoReconnects        = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\SessionAutoReconnects?$filter=(CreatedDate ge ' + $past + ' and CreatedDate le ' + $now + ' )') -headers $headers
			Session                      = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\Sessions?$apply=filter(ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )') -headers $headers
			Users                        = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\Users') -headers $headers
            #LoadIndexes                  = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\LoadIndexes?$filter=(ModifiedDate ge ' + $past + ' )') -headers $headers
			#LoadIndexSummaries           = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\LoadIndexSummaries?$filter=(ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )') -headers $headers
			LogOnMetrics                 = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\LogOnMetrics?$filter=(UserInitStartDate ge ' + $past + ' and UserInitStartDate le ' + $now + ' )') -headers $headers
			#Processes                    = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\Processes?$filter=(ProcessCreationDate ge ' + $past + ' and ProcessCreationDate le ' + $now + ' )') -headers $headers
			#ProcessUtilization           = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\ProcessUtilization?$filter=(CollectedDate ge ' + $past + ' and CollectedDate le ' + $now + ' )') -headers $headers
			ResourceUtilizationSummary   = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\ResourceUtilizationSummary?$filter=(ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )') -headers $headers
			ResourceUtilization          = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\ResourceUtilization?$filter=(ModifiedDate ge ' + $past + ' and ModifiedDate le ' + $now + ' )') -headers $headers
			SessionMetrics               = Export-Odata -URI ('https://api-' + $region + '.cloud.com/monitorodata\SessionMetrics?$apply=filter(CollectedDate ge ' + $past + ' and CollectedDate le ' + $now + ' )') -headers $headers
		}

		$timer.Stop()
		$APItimer.Stop()
} #end Function
Export-ModuleMember -Function Get-CTXAPI_MonitorData
#EndRegion - Get-CTXAPI_MonitorData.ps1
#Region - Get-CTXAPI_ResourceLocation.ps1

<#PSScriptInfo

.VERSION 1.0.3

.GUID 3b47fbca-6d13-4688-9161-5043088b967c

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
Created [03/04/2021_01:32] Initital Script Creating
Updated [06/04/2021_09:03] Script Fle Info was updated
Updated [20/04/2021_10:43] Script Fle Info was updated
Updated [22/04/2021_11:42] Script Fle Info was updated

.PRIVATEDATA

#> 







<# 

.DESCRIPTION 
Get cloud Resource Locations

#> 

Param()


Function Get-CTXAPI_ResourceLocation {
	PARAM(
		[Parameter(Mandatory = $true, Position = 0)]
		[ValidateNotNullOrEmpty()]
		[string]$CustomerId,
		[Parameter(Mandatory = $true, Position = 1)]
		[ValidateNotNullOrEmpty()]
		[string]$SiteId,
		[Parameter(Mandatory = $true, Position = 2)]
		[ValidateNotNullOrEmpty()]
		[string]$ApiToken)

	$headers = [System.Collections.Hashtable]@{
		Authorization       = "CwsAuth Bearer=$($ApiToken)"
		'Citrix-CustomerId' = $customerId
		Accept              = 'application/json'
	}

	((Invoke-WebRequest "https://registry.citrixworkspacesapi.net/$customerId/resourcelocations" -Headers $headers).Content | ConvertFrom-Json).items

} #end Function
Export-ModuleMember -Function Get-CTXAPI_ResourceLocation
#EndRegion - Get-CTXAPI_ResourceLocation.ps1
#Region - Get-CTXAPI_ResourceUtilization.ps1

<#PSScriptInfo

.VERSION 1.0.4

.GUID f2cc4273-d5ac-49b1-b12c-a8e2d1b8cf06

.AUTHOR Pierre Smit

.COMPANYNAME iOCO Tech

.COPYRIGHT

.TAGS Citrix PowerShell

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Created [21/04/2021_11:32] Initital Script Creating
Updated [22/04/2021_11:42] Script Fle Info was updated
Updated [24/04/2021_07:22] Changes the report options
Updated [05/05/2021_00:04] added monitor data
Updated [05/05/2021_14:33] 'Update Manifest'

.PRIVATEDATA

#> 

#Requires -Module ImportExcel
#Requires -Module PSWriteHTML
#Requires -Module PSWriteColor




<# 

.DESCRIPTION 
Resource utilization in the last x hours

#> 

Param()

Function Get-CTXAPI_ResourceUtilization {
		PARAM(
		[Parameter(Mandatory = $true, Position = 0,ParameterSetName='Fetch odata')]
		[ValidateNotNullOrEmpty()]
		[string]$CustomerId,
		[Parameter(Mandatory = $true, Position = 1,ParameterSetName='Fetch odata')]
		[ValidateNotNullOrEmpty()]
		[string]$SiteId,
		[Parameter(Mandatory = $true, Position = 2,ParameterSetName='Fetch odata')]
		[ValidateNotNullOrEmpty()]
		[string]$ApiToken,
        [Parameter(Mandatory = $false,ParameterSetName='Got odata')]
		[pscustomobject]$MonitorData = $null,
		[Parameter(Mandatory = $false, Position = 4,ParameterSetName='Fetch odata')]
		[ValidateNotNullOrEmpty()]
		[ValidateSet('us', 'eu', 'ap-s')]
		[string]$region,
		[ValidateNotNullOrEmpty()]
		[Parameter(Mandatory = $false, Position = 5,ParameterSetName='Fetch odata')]
		[int]$hours = 24,
		[Parameter(Mandatory = $false, Position = 6)]
		[ValidateSet('Excel', 'HTML')]
		[string]$Export = 'Host',
		[Parameter(Mandatory = $false, Position = 7)]
		[ValidateScript( { (Test-Path $_) })]
		[string]$ReportPath = $env:temp
	)

    if ($Null -eq $MonitorData) { $monitor = Get-CTXAPI_MonitorData -CustomerId $CustomerId -SiteId $siteid -ApiToken $apitoken -region $region -hours $hours }
    else {$monitor = $MonitorData }


	$data = @()
	foreach ($Machines in ($monitor.Machines | Where-Object {$_.MachineRole -ne 1})) {

		$ResourceUtilization = $monitor.ResourceUtilization | Where-Object { $_.MachineId -eq $Machines.Id }
		$catalog = $monitor.Catalogs | Where-Object { $_.id -eq $Machines.CatalogId } | ForEach-Object { $_.name }
		$desktopgroup = $monitor.DesktopGroups | Where-Object { $_.id -eq $Machines.DesktopGroupId } | ForEach-Object { $_.name }

		try { 
			$PercentCpu = $UsedMemory = $SessionCount = 0 
			foreach ($Resource in $ResourceUtilization) {
				$PercentCpu = $PercentCpu + $Resource.PercentCpu
				$UsedMemory = $UsedMemory + $Resource.UsedMemory
				$SessionCount = $SessionCount + $Resource.SessionCount
			}
			$AVGPercentCpu = [math]::Round($PercentCpu / $ResourceUtilization.Count)
			$AVGUsedMemory = [math]::Ceiling(($UsedMemory / $ResourceUtilization.Count) / 1gb)
			$AVGTotalMemory = [math]::Round($ResourceUtilization[0].TotalMemory / 1gb)
			$AVGSessionCount = [math]::Round($SessionCount / $ResourceUtilization.Count)
		} catch { Write-Warning 'divide by 0 attempted' }
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
	if ($Export -eq 'Excel') { $data | Export-Excel -Path ($ReportPath + '\Resources_Audit-' + (Get-Date -Format yyyy.MM.dd-HH.mm) + '.xlsx') -AutoSize -AutoFilter -Show } 
	if ($Export -eq 'HTML') { $data | Out-GridHtml -DisablePaging -Title 'Citrix Resources' -HideFooter -FixedHeader }
	if ($Export -eq 'Host') { $data }

} #end Function
Export-ModuleMember -Function Get-CTXAPI_ResourceUtilization
#EndRegion - Get-CTXAPI_ResourceUtilization.ps1
#Region - Get-CTXAPI_Sessions.ps1

<#PSScriptInfo

.VERSION 1.0.3

.GUID ee88aaa7-ac78-46f9-896b-3b29aea20a00

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
Created [03/04/2021_01:17] Initital Script Creating
Updated [06/04/2021_09:03] Script Fle Info was updated
Updated [20/04/2021_10:43] Script Fle Info was updated
Updated [22/04/2021_11:42] Script Fle Info was updated

.PRIVATEDATA

#> 







<# 

.DESCRIPTION 
Get details about cloud sessions

#> 

Param()


Function Get-CTXAPI_Sessions {
	PARAM(
		[Parameter(Mandatory = $true, Position = 0)]
		[ValidateNotNullOrEmpty()]
		[string]$CustomerId,
		[Parameter(Mandatory = $true, Position = 1)]
		[ValidateNotNullOrEmpty()]
		[string]$SiteId,
		[Parameter(Mandatory = $true, Position = 2)]
		[ValidateNotNullOrEmpty()]
		[string]$ApiToken)

	$headers = [System.Collections.Hashtable]@{
		Authorization       = "CwsAuth Bearer=$($ApiToken)"
		'Citrix-CustomerId' = $customerId
		Accept              = 'application/json'
	}


	((Invoke-WebRequest "https://api.cloud.com/cvadapis/$siteid/sessions" -Headers $headers).Content | ConvertFrom-Json).items

} #end Function
Export-ModuleMember -Function Get-CTXAPI_Sessions
#EndRegion - Get-CTXAPI_Sessions.ps1
#Region - Get-CTXAPI_SiteID.ps1

<#PSScriptInfo

.VERSION 1.0.5

.GUID 7b30365c-2695-4a40-b701-4d25be3cbaa5

.AUTHOR Pierre Smit

.COMPANYNAME iOCO Tech

.COPYRIGHT

.TAGS Citrix PowerShell

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Created [03/04/2021_00:58] Initital Script Creating
Updated [06/04/2021_09:03] Script Fle Info was updated
Updated [20/04/2021_10:43] Script Fle Info was updated
Updated [22/04/2021_11:42] Script Fle Info was updated
Updated [05/05/2021_00:04] renamed script
Updated [05/05/2021_14:33] 'Update Manifest'

.PRIVATEDATA

#> 











<# 

.DESCRIPTION 
Get cloud site id

#> 

Param()


Function Get-CTXAPI_SiteID {
	PARAM(
		[Parameter(Mandatory = $true, Position = 0)]
		[ValidateNotNullOrEmpty()]
		[string]$CustomerId,
		[Parameter(Mandatory = $true, Position = 1)]
		[ValidateNotNullOrEmpty()]
		[string]$ApiToken)

	$headers = [System.Collections.Hashtable]@{
		Authorization       = "CwsAuth Bearer=$($ApiToken)"
		'Citrix-CustomerId' = $customerId
		Accept              = 'application/json'
	}

	try {
		$me = Invoke-WebRequest 'https://api-us.cloud.com/cvadapis/me' -Headers $headers
		($me.Content | ConvertFrom-Json).customers.sites.id
	} catch { Write-Error "Failed to connect to api:$($_)" }
} #end Function
Export-ModuleMember -Function Get-CTXAPI_SiteID
#EndRegion - Get-CTXAPI_SiteID.ps1
#Region - Get-CTXAPI_StoreFrontServers.ps1

<#PSScriptInfo

.VERSION 1.0.2

.GUID 5b996933-e86d-4a29-b665-d8315c40e89b

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
Created [11/04/2021_09:17] Initital Script Creating
Updated [20/04/2021_10:43] Script Fle Info was updated
Updated [22/04/2021_11:42] Script Fle Info was updated

.PRIVATEDATA

#> 





<# 

.DESCRIPTION 
Get storefront servers from api

#> 

Param()


Function Get-CTXAPI_StoreFrontServers {
	PARAM(
		[Parameter(Mandatory = $true, Position = 0)]
		[ValidateNotNullOrEmpty()]
		[string]$CustomerId,
		[Parameter(Mandatory = $true, Position = 1)]
		[ValidateNotNullOrEmpty()]
		[string]$SiteId,
		[Parameter(Mandatory = $true, Position = 2)]
		[ValidateNotNullOrEmpty()]
		[string]$ApiToken)

	$headers = [System.Collections.Hashtable]@{
		Authorization       = "CwsAuth Bearer=$($ApiToken)"
		'Citrix-CustomerId' = $customerId
		Accept              = 'application/json'
	}


	((Invoke-WebRequest "https://api.cloud.com/cvadapis/$siteid/storefrontservers" -Headers $headers).Content | ConvertFrom-Json).items


} #end Function
Export-ModuleMember -Function Get-CTXAPI_StoreFrontServers
#EndRegion - Get-CTXAPI_StoreFrontServers.ps1
#Region - Get-CTXAPI_Token.ps1

<#PSScriptInfo

.VERSION 1.0.5

.GUID 4ad090f6-2553-4c76-8eac-4484dccafb7e

.AUTHOR Pierre Smit

.COMPANYNAME iOCO Tech

.COPYRIGHT

.TAGS Citrix PowerShell

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Created [03/04/2021_00:59] Initital Script Creating
Updated [06/04/2021_09:03] Script Fle Info was updated
Updated [20/04/2021_10:43] Script Fle Info was updated
Updated [22/04/2021_11:42] Script Fle Info was updated
Updated [05/05/2021_00:05] added error reporting
Updated [05/05/2021_14:33] 'Update Manifest'

.PRIVATEDATA

#> 











<# 

.DESCRIPTION 
Get cloud api token bearer

#> 

Param()


Function Get-CTXAPI_Token {
	[CmdletBinding()]
	param(
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$client_id,
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$client_secret
	)
	$body = [hashtable]@{
		grant_type    = 'client_credentials'
		client_id     = $client_id
		client_secret = $client_secret
	}
	$tokenUrl = 'https://api-us.cloud.com/cctrustoauth2/root/tokens/clients'
	try { ((Invoke-WebRequest -Uri $tokenUrl -Method POST -Body $body).Content | ConvertFrom-Json).access_token }
	catch { Write-Error "Failed to logon:$($_)" }





} #end Function
Export-ModuleMember -Function Get-CTXAPI_Token
#EndRegion - Get-CTXAPI_Token.ps1
#Region - Get-CTXAPI_VDAUptime.ps1

<#PSScriptInfo

.VERSION 1.0.3

.GUID bc970a9f-0566-4048-8332-0bceda215135

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
Created [06/04/2021_11:17] Initital Script Creating
Updated [20/04/2021_10:43] Script Fle Info was updated
Updated [22/04/2021_11:42] Script Fle Info was updated
Updated [05/05/2021_14:33] 'Update Manifest'

.PRIVATEDATA

#> 

#Requires -Module ImportExcel
#Requires -Module PSWriteHTML
#Requires -Module PSWriteColor




<# 

.DESCRIPTION 
Uses Registration date to calculate uptime

#> 

Param()

Function Get-CTXAPI_VDAUptime {
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
		[Parameter(Mandatory = $false, Position = 5)]
		[ValidateSet('Excel', 'HTML')]
		[string]$Export = 'Host',
		[Parameter(Mandatory = $false, Position = 6)]
		[ValidateScript( { (Test-Path $_) })]
		[string]$ReportPath = $env:temp)

try{
	$Complist = @()
	$machines = Get-CTXAPI_Machines -CustomerId $CustomerId -SiteId $SiteId -ApiToken $apitoken 
	
	foreach ($machine in $machines){
		if ($null -eq $machine.LastDeregistrationTime) {$lastBootTime = Get-Date -Format 'M/d/yyyy h:mm:ss tt'}
		else {$lastBootTime = [Datetime]::ParseExact($machine.LastDeregistrationTime, 'M/d/yyyy h:mm:ss tt', $null)}

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
		$Complist += [PSCustomObject]@{
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
		}
	}
}catch{Write-Warning "Date calculation failed"}
	if ($Export -eq 'Excel') { $complist | Export-Excel -Path ($ReportPath + '\VDAUptime-' + (Get-Date -Format yyyy.MM.dd-HH.mm) + '.xlsx') -AutoSize -AutoFilter -Show }
	if ($Export -eq 'HTML') { $complist | Out-GridHtml -DisablePaging -Title 'Citrix Uptime' -HideFooter -FixedHeader }
	if ($Export -eq 'Host') { $complist }

} #end Function

Export-ModuleMember -Function Get-CTXAPI_VDAUptime
#EndRegion - Get-CTXAPI_VDAUptime.ps1
#Region - Get-CTXAPI_Zones.ps1

<#PSScriptInfo

.VERSION 1.0.2

.GUID 8474c4cc-e529-4c1f-8820-9b299fe9fa19

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
Created [11/04/2021_09:19] Initital Script Creating
Updated [20/04/2021_10:43] Script Fle Info was updated
Updated [22/04/2021_11:42] Script Fle Info was updated

.PRIVATEDATA

#> 





<# 

.DESCRIPTION 
Get zones details from api

#> 

Param()


Function Get-CTXAPI_Zones {
	PARAM(
		[Parameter(Mandatory = $true, Position = 0)]
		[ValidateNotNullOrEmpty()]
		[string]$CustomerId,
		[Parameter(Mandatory = $true, Position = 1)]
		[ValidateNotNullOrEmpty()]
		[string]$SiteId,
		[Parameter(Mandatory = $true, Position = 2)]
		[ValidateNotNullOrEmpty()]
		[string]$ApiToken)

	$headers = [System.Collections.Hashtable]@{
		Authorization       = "CwsAuth Bearer=$($ApiToken)"
		'Citrix-CustomerId' = $customerId
		Accept              = 'application/json'
	}


	((Invoke-WebRequest "https://api.cloud.com/cvadapis/$siteid/zones" -Headers $headers).Content | ConvertFrom-Json).items


} #end Function
Export-ModuleMember -Function Get-CTXAPI_Zones
#EndRegion - Get-CTXAPI_Zones.ps1
#Region - Set-CTXAPI_SecretStore.ps1

<#PSScriptInfo

.VERSION 1.0.0

.GUID cdfb5404-4936-4c04-95f1-dec99294d7b3

.AUTHOR Pierre Smit

.COMPANYNAME iOCO Tech

.COPYRIGHT

.TAGS CTX

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Created [24/04/2021_07:26] Initital Script Creating

.PRIVATEDATA

#>

<# 

.DESCRIPTION 
 Integrates module with a local ms secret store 

#> 

Param()

Function Set-CTXAPI_SecretStore
{
	PARAM(
		[Parameter(Mandatory = $true, Position = 0)]
		[ValidateScript( { (Test-Path $_) })]
		[string]$PasswordFilePath)

	$module = Get-Module -Name Microsoft.PowerShell.SecretManagement -ListAvailable | Select-Object -First 1
	if ([bool]$module -eq $false)
	{
		Write-Color -Text 'Installing module: ','SecretManagement' -Color yellow,green
		Install-Module Microsoft.PowerShell.SecretManagement, -AllowClobber -Scope AllUsers
	} else
	{
		Write-Color -Text 'Using installed module path: ',$module.ModuleBase -Color yellow,green
	}
	$module = Get-Module -Name Microsoft.PowerShell.SecretStore -ListAvailable | Select-Object -First 1
	if ([bool]$module -eq $false)
	{
		Write-Color -Text 'Installing module: ','SecretStore' -Color yellow,green
		Install-Module Microsoft.PowerShell.SecretStore -AllowClobber -Scope AllUsers
	} else
	{
		Write-Color -Text 'Using installed module path: ',$module.ModuleBase -Color yellow,green
	}
	import-module Microsoft.PowerShell.SecretManagement,Microsoft.PowerShell.SecretManagement -force
	$vault = Get-SecretVault -Name CTXAPIStore -ErrorAction SilentlyContinue
	if ([bool]$vault -eq $false)
	{
		Register-SecretVault -Name CTXAPIStore -ModuleName Microsoft.PowerShell.SecretStore
		$Password = Read-Host 'Password ' -AsSecureString
		$Password | Export-Clixml -Path "$PasswordFilePath\CTXAPI.xml" -Depth 3 -Force	
		Write-Host "Password file $PasswordFilePath\CTXAPI.xml created "
		try
		{
			Set-SecretStoreConfiguration -Scope CurrentUser -Authentication Password -PasswordTimeout 3600 -Password $Password -Interaction None -Confirm:$false
		} catch
		{ Write-Warning 'SecretStoreConfiguration already set' 
  }
	}
	$password = Import-Clixml -Path "$PasswordFilePath\CTXAPI.xml"
	Unlock-SecretStore -Password $password

	$CustomerId = Read-Host 'CustomerId '	 
	$clientid = Read-Host 'clientid '
	$clientsecret = Read-Host 'clientsecret '
	
	Set-Secret -Name $CustomerId -Secret $clientsecret -Metadata @{clientid = $clientid.ToString() } -Vault CTXAPIStore

} #end Function
Export-ModuleMember -Function Set-CTXAPI_SecretStore
#EndRegion - Set-CTXAPI_SecretStore.ps1
#Region - Unlock-CTXAPI_CredentialFromSecretStore.ps1

<#PSScriptInfo

.VERSION 1.0.0

.GUID d2e6e808-e5fc-45d6-942d-3df754591008

.AUTHOR Pierre Smit

.COMPANYNAME iOCO Tech

.COPYRIGHT

.TAGS citrix

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Created [24/04/2021_08:30] Initital Script Creating

.PRIVATEDATA

#>

<# 

.DESCRIPTION 
 Get api logon details from ms secret store 

#> 

Param()


Function Unlock-CTXAPI_CredentialFromSecretStore {
	PARAM(
		[Parameter(Mandatory = $true, Position = 0)]
		[ValidateScript( { (Test-Path $_) -and ((Get-Item $_).name -eq 'CTXAPI.xml') })]
		[string]$PasswordFilePath,
		[Parameter(Mandatory = $true, Position = 1)]
		[ValidateNotNull()]
		[ValidateNotNullOrEmpty()]
		[string]$CustomerId)

	$password = Import-Clixml -Path $PasswordFilePath
	Unlock-SecretStore -Password $password

	$Global:CustomerId = $CustomerId
	$Global:clientid = ((Get-SecretInfo -Name $CustomerId -Vault CTXAPIStore).Metadata).clientid
	$Global:clientsecret = Get-Secret -Name $CustomerId -Vault CTXAPIStore -AsPlainText

	Write-Color -Text "Using the following details" -Color DarkYellow -LinesAfter 1
    Write-Color -Text "CustomerID :", $CustomerId -Color Yellow,Cyan
    Write-Color -Text "clientid :", $clientid -Color Yellow,Cyan
    Write-Color -Text "clientsecret :", $clientsecret -Color Yellow,Cyan


} #end Function
Export-ModuleMember -Function Unlock-CTXAPI_CredentialFromSecretStore
#EndRegion - Unlock-CTXAPI_CredentialFromSecretStore.ps1
### --- PRIVATE FUNCTIONS --- ###
#Region - Export-Odata.ps1

<#PSScriptInfo

.VERSION 1.0.1

.GUID f8a1aed0-09c4-4853-b310-9c6e87818f26

.AUTHOR Pierre Smit

.COMPANYNAME iOCO Tech

.COPYRIGHT

.TAGS citrix

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Created [05/05/2021_09:09] Initital Script Creating
Updated [05/05/2021_14:32] Manifest

.PRIVATEDATA

#> 

#Requires -Module PSWriteColor

<# 

.DESCRIPTION 
Export multiple pages from odata

#> 

Param()

Function Export-Odata {
		[CmdletBinding()]
		param(
			[string]$URI,
			[Hashtable]$headers)

		$data = @()
		$NextLink = $URI

		Write-Color -Text 'Fetching :',$URI.split('?')[0].split('\')[1] -Color Yellow,Cyan -ShowTime -DateTimeFormat HH:mm:ss -NoNewLine
		$APItimer.Restart()
		While ($Null -ne $NextLink) {
			$tmp = Invoke-WebRequest -Uri $NextLink -Headers $headers | ConvertFrom-Json
			$tmp.Value | ForEach-Object { $data += $_ }
			$NextLink = $tmp.'@odata.NextLink' 
		}
		[String]$seconds = '[' + ($APItimer.elapsed.seconds).ToString() + 'sec]'
		Write-Color $seconds -Color Red
		return $data


} #end Function
#EndRegion - Export-Odata.ps1
