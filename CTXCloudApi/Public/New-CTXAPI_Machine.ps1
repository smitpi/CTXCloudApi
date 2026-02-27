
<#PSScriptInfo

.VERSION 0.1.0

.GUID 5849cff9-5beb-46a9-b54f-774c2e6b019c

.AUTHOR Pierre Smit

.COMPANYNAME HTPCZA Tech

.COPYRIGHT

.TAGS ps

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Created [19/02/2026_12:01] Initial Script

.PRIVATEDATA

#>

<# 

.DESCRIPTION 
 Creates and add a new machine to a delivery group 

#> 


<#
.SYNOPSIS
Creates and adds new machines to a Citrix Cloud Delivery Group.

.DESCRIPTION
This function provisions one or more new machines in a specified Machine Catalog and adds them to a specified Delivery Group in Citrix Cloud using the CTXCloudApi module. The function supports verbose output for detailed process tracking.

.PARAMETER APIHeader
The authentication header object returned by Connect-CTXAPI, required for all API calls.

.PARAMETER MachineCatalogName
The name of the Machine Catalog where new machines will be created.

.PARAMETER DeliveryGroupName
The name of the Delivery Group to which the new machines will be added.

.PARAMETER AmountOfMachines
The number of machines to create and add to the Delivery Group.

.EXAMPLE
New-CTXAPI_Machine -APIHeader $header -MachineCatalogName "Win10-Catalog" -DeliveryGroupName "Win10-Users" -AmountOfMachines 2 -Verbose

Creates 2 new machines in the "Win10-Catalog" Machine Catalog and adds them to the "Win10-Users" Delivery Group, showing verbose output.

.NOTES

.LINK
https://smitpi.github.io/CTXCloudApi/New-CTXAPI_Machine
#>
function New-CTXAPI_Machine {
	[Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/New-CTXAPI_Machine', SupportsShouldProcess = $true, SupportsPaging = $false, ConfirmImpact = 'None')]
	[OutputType([System.Object[]])]

	param(
		[Parameter(Mandatory = $true)]
		[PSTypeName('CTXAPIHeaderObject')]$APIHeader,
		[Parameter(Mandatory = $true)]
		[string]$MachineCatalogName,
		[Parameter(Mandatory = $true)]
		[string]$DeliveryGroupName,
		[Parameter(Mandatory = $true)]
		[int]$AmountOfMachines
	)
	if (-not(Test-CTXAPI_Header -APIHeader $APIHeader)) {Test-CTXAPI_Header -APIHeader $APIHeader -AutoRenew}
	else {	Write-Verbose "[$(Get-Date -Format HH:mm:ss) APIHEADER] Header still valid"}

	Write-Verbose "Retrieving Machine Catalog ID for: $MachineCatalogName"
	$catid = Get-CTXAPI_MachineCatalog -APIHeader $APIHeader | Where-Object Name -EQ $MachineCatalogName
	Write-Verbose "Machine Catalog ID: $($catid.id)"
	$requestUri = [string]::Format('https://api.cloud.com/cvad/manage/MachineCatalogs/{0}/Machines?async=true', $catid.id)

	Write-Verbose 'Building request body for machine creation.'
	$body = [pscustomobject]@{
		MachineName                 = $null
		MachineAccountCreationRules = $catid.ProvisioningScheme.MachineAccountCreationRules
	} | ConvertTo-Json -Depth 10

	for ($i = 1; $i -le $AmountOfMachines; $i++) {
		Write-Verbose "Starting creation of machine $i of $AmountOfMachines."
		try {
			Write-Verbose "Invoking REST method to create machine. URI: $requestUri"
			Invoke-RestMethod -Uri $requestUri -Method POST -Headers $APIHeader.headers -Body $body
			Start-Sleep -Seconds 5
			$Jobrequest = [string]::Format('https://api.cloud.com/cvad/manage/Jobs')
			Write-Verbose "Checking job status at: $Jobrequest"
			$jobresponse = Invoke-RestMethod -Uri $Jobrequest -Method get -Headers $APIHeader.headers
			$topreponce = ($jobresponse.Items | Sort-Object -Property CreationTime -Descending)[0]
			Write-Verbose "Job state: $($topreponce.status). Waiting for completion... Number $i"
			while ($topreponce.status -eq 'InProgress') {
				Write-Verbose "Job state: $($topreponce.status). Waiting for completion... Number $i"
				Start-Sleep -Seconds 5
				$Jobrequest = [string]::Format('https://api.cloud.com/cvad/manage/Jobs/{0}', $topreponce.id)
				$topreponce = Invoke-RestMethod -Uri $Jobrequest -Method get -Headers $APIHeader.headers
			}
			Write-Verbose 'Successfully created machine.'
		} catch {
			Write-Error "Failed to create machine: Error: $_"
		}
	}
	Write-Verbose "Retrieving Delivery Group: $DeliveryGroupName"
	$DeliveryGroup = Get-CTXAPI_DeliveryGroup -APIHeader $APIHeader | Where-Object Name -EQ $DeliveryGroupName
	Write-Verbose 'Retrieving all machines.'
	
	$mac = Get-CTXAPI_Machine -APIHeader $APIHeader
	$newmachines = $mac | Where-Object {($_.MachineCatalog.id -eq $catid.id) -and ($null -eq $_.DeliveryGroup)}

	Write-Verbose ('Found {0} new machines to add to Delivery Group.' -f ($newmachines | Measure-Object | Select-Object -ExpandProperty Count))
	[System.Collections.generic.List[PSObject]]$ResultObject = @()
	if ($newmachines) {
		$newmachines | ForEach-Object {
			Write-Verbose "Assigning machine $($_.Name) to Delivery Group $($DeliveryGroup.Name)"
			$deliveryobject = [pscustomobject]@{
				MachineCatalog        = $catid.FullName
				AssignMachinesToUsers = @(
					@{
						Machine = $_.Name
					}
				)
			} | ConvertTo-Json -Depth 10
			$deliveryrequestUri = [string]::Format('https://api.cloud.com/cvad/manage/DeliveryGroups/{0}/Machines', $DeliveryGroup.id)
			Write-Verbose "Invoking REST method to add machine to Delivery Group. URI: $deliveryrequestUri"
			$invoke = Invoke-RestMethod -Uri $deliveryrequestUri -Method POST -Headers $APIHeader.headers -Body $deliveryobject
			$ResultObject.Add($invoke)
		}
	} else {
		Write-Verbose 'No new machines found to add to Delivery Group.'
	}
	Write-Verbose 'Returning result object.'
	$ResultObject

} #end Function
