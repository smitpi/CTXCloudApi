
<#PSScriptInfo

.VERSION 1.0.3

.GUID f2cc4273-d5ac-49b1-b12c-a8e2d1b8cf06

.AUTHOR Pierre Smit

.COMPANYNAME iOCO Tech

.COPYRIGHT

.TAGS PowerShell Citrix PowerShell

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
