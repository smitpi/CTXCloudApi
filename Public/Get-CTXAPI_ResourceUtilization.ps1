
<#PSScriptInfo

.VERSION 1.0.0

.GUID f2cc4273-d5ac-49b1-b12c-a8e2d1b8cf06

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
Created [21/04/2021_11:32] Initital Script Creating

#>

<# 

.DESCRIPTION 
 Resource utilization in the last x hours 

#> 

Param()



<#PSScriptInfo

.VERSION 1.0.0

.GUID 37e74ed2-1a4e-4fc2-a43c-fdd58f14950a

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
Created [21/04/2021_11:04] Initital Script Creating

#>

<# 

.DESCRIPTION 
 Resource Utilization of x hours 

#> 
#requires -Modules ImportExcel,PSWriteHTML,PSWriteColor

Function Get-CTXAPI_ResourceUtilization {
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
		[Parameter(Mandatory = $false, Position = 4)]
		[int]$hours,
		[Parameter(Mandatory = $false, Position = 5)]
		[ValidateSet('Excel', 'HTML')]
		[string]$Export,
		[Parameter(Mandatory = $false, Position = 6)]
		[ValidateScript( { (Test-Path $_) })]
		[string]$ReportPath = $env:temp
	)
	$monitor = Get-CTXAPI_MonitorData -CustomerId $CustomerId -SiteId $siteid -ApiToken $apitoken -region $region -hours $hours

	$data = @()
	foreach ($Machines in $monitor.Machines) {

		$ResourceUtilization = $monitor.ResourceUtilization | Where-Object { $_.MachineId -eq $Machines.Id }
		$catalog = $monitor.Catalogs | Where-Object { $_.id -eq $Machines.CatalogId } | ForEach-Object { $_.name }
		$desktopgroup = $monitor.DesktopGroups | Where-Object { $_.id -eq $Machines.DesktopGroupId } | ForEach-Object { $_.name }

		try { 
			$PercentCpu = $UsedMemory = $TotalMemory = $SessionCount = 0 
			foreach ($Resource in $ResourceUtilization) {
				$PercentCpu = $PercentCpu + $Resource.PercentCpu
				$UsedMemory = $UsedMemory + $Resource.UsedMemory
				$TotalMemory = $TotalMemory + $Resource.TotalMemory
				$SessionCount = $SessionCount + $Resource.SessionCount
			}
			$AVGPercentCpu = [math]::Round($PercentCpu / $ResourceUtilization.Count)
			$AVGUsedMemory = [math]::Ceiling(($UsedMemory / $ResourceUtilization.Count) / 1gb)
			$AVGTotalMemory = [math]::Ceiling(($TotalMemory / $ResourceUtilization.Count) / 1gb)
			$AVGSessionCount = [math]::Round($SessionCount / $ResourceUtilization.Count)
		} catch { Write-Warning 'devide by 0 atempted' }
		$data += [PSCustomObject]@{
			DnsName                  = $Machines.DnsName
			IsInMaintenanceMode      = $Machines.IsInMaintenanceMode
			AgentVersion             = $Machines.AgentVersion
			CurrentRegistrationState = $RegistrationState[$Machines.CurrentRegistrationState]
			OSType                   = $Machines.OSType
			Catalog                  = $catalog
			DesktopGroup             = $desktopgroup
			MachineRole              = $MachineRole[$Machines.MachineRole]
			AVGPercentCpu            = $AVGPercentCpu
			AVGUsedMemory            = $AVGUsedMemory
			AVGTotalMemory           = $AVGTotalMemory
			AVGSessionCount          = $AVGSessionCount
		}
	}
	if ($Export -eq 'Excel') {
		[string]$ExcelReportname = $ReportPath + '\Resources_Audit-' + (Get-Date -Format yyyy.MM.dd-HH.mm) + '.xlsx'
		$data | Export-Excel -Path $ExcelReportname -AutoSize -AutoFilter -Show
	} elseif ($Export -eq 'HTML') { $data | Out-GridHtml -DisablePaging -Title 'Citrix Resources' -HideFooter -FixedHeader }
	else { 
		$data
	}
} #end Function
