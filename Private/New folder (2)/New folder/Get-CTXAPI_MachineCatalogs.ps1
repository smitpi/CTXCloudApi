
<#PSScriptInfo

.VERSION 1.1.1

.GUID 09d83877-8979-4379-a7ca-d6d6bd538fa1

.AUTHOR Pierre Smit

.COMPANYNAME iOCO Tech

.COPYRIGHT

.TAGS "api" "cloud") "vda" ("ctx" api cloud ctx vda

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Created [06/10/2021_18:16] Initital Script Creating
Updated [06/10/2021_19:00] "Help Files Added"

.PRIVATEDATA

#>



<#

.DESCRIPTION
Retrieves details about machine catalogs

#>

Param()



#>
# .ExternalHelp CTXCloudApi-help.xml

Function Get-CTXAPI_MachineCatalog {
	[Cmdletbinding()]
    [OutputType([System.Object[]])]
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
