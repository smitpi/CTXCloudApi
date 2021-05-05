
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
		$MachineFailureReport = Get-CTXAPI_FailureReport -CustomerId $CustomerId -SiteId $SiteId -ApiToken $ApiToken -MonitorData $MonitorData -FailureType Machine

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
			HeaderTextColor       = 'orange'
		}

		$TableSectionSettings = @{
			BackgroundColor       = 'white'
			HeaderBackGroundColor = 'orange'
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
				New-HTMLSection -HeaderText 'Top 5 RTT Sessions' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $connectionRTT }
				New-HTMLSection -HeaderText 'Top 5 Logon Duration' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $connectionLogon }
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
			New-HTMLSection @SectionSettings -Content {
				New-HTMLSection -HeaderText 'Resource Utilization' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $ResourceUtilization }
			}
		}
		#endregion
	} catch { Write-Error "Failed to generate report:$($_)" }

} #end Function
