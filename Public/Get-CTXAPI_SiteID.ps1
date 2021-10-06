
<#PSScriptInfo

.VERSION 1.0.6

.GUID 7b30365c-2695-4a40-b701-4d25be3cbaa5

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
Created [03/04/2021_00:58] Initital Script Creating
Updated [06/04/2021_09:03] Script Fle Info was updated
Updated [20/04/2021_10:43] Script Fle Info was updated
Updated [22/04/2021_11:42] Script Fle Info was updated
Updated [05/05/2021_00:04] renamed script
Updated [05/05/2021_14:33] 'Update Manifest'
Updated [05/10/2021_21:22] Module Info Updated

.PRIVATEDATA

#>













<#

.DESCRIPTION
Get cloud site id

#>


Param()


# .ExternalHelp CTXCloudApi-help.xml
Function Get-CTXAPI_SiteID {
	[Cmdletbinding()]
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
