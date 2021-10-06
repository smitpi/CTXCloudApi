
<#PSScriptInfo

.VERSION 1.0.1

.GUID b19486c7-7f81-4e31-82d4-4a4d81e80574

.AUTHOR Pierre Smit

.COMPANYNAME iOCO Tech

.COPYRIGHT

.TAGS api citrix ctx cvad

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Created [28/05/2021_20:38] Initital Script Creating
Updated [05/10/2021_21:22] Module Info Updated

.PRIVATEDATA

#>



<#

.DESCRIPTION
Get cloud site details

#>

Param()



Function Get-CTXAPI_SiteDetail {
	[Cmdletbinding()]
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

	((Invoke-WebRequest "https://api-us.cloud.com/cvadapis/Sites/$siteid" -Headers $headers).Content | ConvertFrom-Json)
	#((Invoke-WebRequest "https://api-us.cloud.com/cvadapis/$siteid/tenants" -Headers $headers).Content | ConvertFrom-Json)


} #end Function
