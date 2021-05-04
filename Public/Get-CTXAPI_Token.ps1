
<#PSScriptInfo

.VERSION 1.0.3

.GUID 4ad090f6-2553-4c76-8eac-4484dccafb7e

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
Created [03/04/2021_00:59] Initital Script Creating
Updated [06/04/2021_09:03] Script Fle Info was updated
Updated [20/04/2021_10:43] Script Fle Info was updated
Updated [22/04/2021_11:42] Script Fle Info was updated

.PRIVATEDATA

#> 







<# 

.DESCRIPTION 
Get cloud api token bearer

#> 

Param()


Function Get-CTXAPI_Token {
	[CmdletBinding()]
	param(
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$client_id,
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$client_secret
	)
	$body = [hashtable]@{
		grant_type    = 'client_credentials'
		client_id     = $client_id
		client_secret = $client_secret
	}
	$tokenUrl = 'https://api-us.cloud.com/cctrustoauth2/root/tokens/clients'
	try { ((Invoke-WebRequest -Uri $tokenUrl -Method POST -Body $body).Content | ConvertFrom-Json).access_token }
	catch { Write-Error "Failed to logon:$($_)" }





} #end Function
