
<#PSScriptInfo

.VERSION 1.0.1

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
Updated [22/04/2021_11:42] Script Fle Info was updated

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
		[Parameter(Mandatory = $true, Position = 4)]
		[int]$hours,
		[Parameter(Mandatory = $false, Position = 5)]
		[ValidateSet('Excel', 'HTML')]
		[string]$Export = 'Host',
		[Parameter(Mandatory = $false, Position = 6)]
		[ValidateScript( { (Test-Path $_) })]
		[string]$ReportPath = $env:temp
	)

	$monitor = Get-CTXAPI_MonitorData -CustomerId $CustomerId -SiteId $siteid -ApiToken $apitoken -region $region -hours $hours

	$RegistrationState = [PSCustomObject]@{
		0 = 'Unknown'
		1 = 'Registered'
		2 = 'Unregistered'
	}
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
