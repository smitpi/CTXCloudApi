
<#PSScriptInfo

.VERSION 1.0.1

.GUID d8e1762b-129a-47c8-bec8-04d8c74701e7

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
Created [03/04/2021_01:07] Initital Script Creating
Updated [06/04/2021_09:03] Script Fle Info was updated

#> 



<# 

.DESCRIPTION 
get cloud MachineCatalogs

#> 

Param()


Function Get-CTXAPI_MachineCatalogs {
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
