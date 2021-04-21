
<#PSScriptInfo

.VERSION 1.0.1

.GUID 47e5e6ae-6d08-41e8-b715-3851367ce1df

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
Created [17/04/2021_11:59] Initital Script Creating
Updated [20/04/2021_10:43] Script Fle Info was updated

.PRIVATEDATA

#> 



<# 

.DESCRIPTION 
Get the detailed steps for an High Level Operation

#> 

Param()


Function Get-CTXAPI_LowLevelOperations {
PARAM(
		[Parameter(Mandatory = $true, Position = 0)]
		[ValidateNotNullOrEmpty()]
		[string]$CustomerId,
		[Parameter(Mandatory = $true, Position = 1)]
		[ValidateNotNullOrEmpty()]
		[string]$SiteId,
		[Parameter(Mandatory = $true, Position = 2)]
		[ValidateNotNullOrEmpty()]
		[string]$HighLevelID,
		[Parameter(Mandatory = $true, Position = 3)]
		[ValidateNotNullOrEmpty()]
		[string]$ApiToken)


	$headers = [System.Collections.Hashtable]@{
		Authorization       = "CwsAuth Bearer=$($ApiToken)"
		'Citrix-CustomerId' = $customerId
		Accept              = 'application/json'
	}


	((Invoke-WebRequest "https://api.cloud.com/cvadapis/$siteid/ConfigLog/Operations/$HighLevelID/LowLevelOperations" -Headers $headers).Content | ConvertFrom-Json).items

} #end Function
