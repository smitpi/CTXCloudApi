
<#PSScriptInfo

.VERSION 1.1.6

.GUID c910816d-788d-4e5f-b405-cb9f898bb106

.AUTHOR Pierre Smit

.COMPANYNAME iOCO Tech

.COPYRIGHT

.TAGS api citrix ctx cvad PowerShell

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Created [17/04/2021_09=58]  Script Creating
Updated [20/04/2021_10:42] Script File Info was updated
Updated [22/04/2021_11:42] Script File Info was updated
Updated [05/05/2021_00:03] error reporting
Updated [05/05/2021_14:33] 'Update Manifest'
Updated [05/10/2021_21:22] Module Info Updated
Updated [07/10/2021_13:28] Script info updated for module

.PRIVATEDATA

#> 



<#

.DESCRIPTION 
Add manually installed machine to a catalog

#>

Param()


#.ExternalHelp CTXCloudApi-help.xml
Function Add-CTXAPI_MachineToCatalog {
	
	[Cmdletbinding()]
	PARAM(
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[string]$CustomerId,
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[string]$SiteId,
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[string]$ApiToken,
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[string]$CatalogNameORID,
		[Parameter(Mandatory = $true)]
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
