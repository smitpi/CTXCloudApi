
<#PSScriptInfo

.VERSION 1.0.2

.GUID 49c09b99-1918-4fc5-b536-26162b1f0cff

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
Created [03/04/2021_12:08] Initital Script Creating
Updated [06/04/2021_09:03] Script Fle Info was updated
Updated [20/04/2021_10:42] Script Fle Info was updated

.PRIVATEDATA

#> 





<# 

.DESCRIPTION 
details about ctx objects

#> 

Param()


Function Get-CTXAPI_Hypervisors {
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


	((Invoke-WebRequest "https://api.cloud.com/cvadapis/$siteid/hypervisors" -Headers $headers).Content | ConvertFrom-Json).items


} #end Function
