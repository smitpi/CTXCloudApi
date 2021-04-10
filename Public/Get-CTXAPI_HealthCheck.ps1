
<#PSScriptInfo

.VERSION 1.0.0

.GUID 537fc472-0d06-40de-b672-9a507443cf44

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
Created [10/04/2021_14:59] Initital Script Creating

#>

<# 

.DESCRIPTION 
 Quick healthcheck to show whats offline 

#Requires –Modules PSWriteHTML
#> 


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
		[ValidateScript( { (Test-Path $_) })]
		[string]$ReportPath = $env:temp
	)
	#######################
	#region Get data
	#######################
	Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) [Proccessing] Config Log"
	$configlog = Get-CTXAPI_ConfigLog -CustomerId $CustomerId -SiteId $SiteId -Days 7 -ApiToken $ApiToken | Group-Object -Property text | Select-Object count,name | Sort-Object -Property count -Descending | Select-Object -First 5

	Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) [Proccessing] Delivery Groups"
	$DeliveryGroups = Get-CTXAPI_DeliveryGroups -CustomerId $CustomerId -SiteId $SiteId -ApiToken $ApiToken | Select-Object Name,DeliveryType,DesktopsAvailable,DesktopsDisconnected,DesktopsFaulted,DesktopsNeverRegistered,DesktopsUnregistered,InMaintenanceMode,IsBroken,RegisteredMachines,SessionCount

	Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) [Proccessing] Sessions"
	$sessions = Get-CTXAPI_Sessions -CustomerId $CustomerId -SiteId $SiteId -ApiToken $ApiToken
	$sessioncount = [PSCustomObject]@{
		Connected    = ($sessions | Where-Object { $_.state -like 'Connected' }).count
		Disconnected = ($sessions | Where-Object { $_.state -like 'Disconnected' }).count
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
	[string]$HTMLReportname = $ReportPath + '\XD_Healthcheck-' + (Get-Date -Format yyyy.MM.dd-HH.mm) + '.html'

	$HeadingText = $CustomerId + ' | Report | ' + (Get-Date -Format dd) + ' ' + (Get-Date -Format MMMM) + ',' + (Get-Date -Format yyyy) + ' ' + (Get-Date -Format HH:mm)

	New-HTML -TitleText "$CustomerId Report" -FilePath $HTMLReportname -ShowHTML {
		New-HTMLHeading -Heading h1 -HeadingText $HeadingText -Color Black
		New-HTMLSection @SectionSettings -Content {
			New-HTMLSection -HeaderText 'Citrix Sessions' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $sessioncount }
		}
		New-HTMLSection @SectionSettings -Content {
			New-HTMLSection -HeaderText 'Config Changes' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $configlog }
			New-HTMLSection -HeaderText 'Machine Summary' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable ($machinecount.psobject.Properties | Select-Object name,value) }
		}
		New-HTMLSection @SectionSettings -Content {
			New-HTMLSection -HeaderText 'Delivery Groups' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $DeliveryGroups }
		}
		New-HTMLSection @SectionSettings -Content {
			New-HTMLSection -HeaderText 'Machines' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $vdauptime }
		}
	}
	#endregion
} #end Function
