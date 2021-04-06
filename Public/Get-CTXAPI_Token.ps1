
<#PSScriptInfo

.VERSION 1.0.1

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

#> 



<# 

.DESCRIPTION 
get cloud token

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

$tokenUrl = 'https://api-us.cloud.com/cctrustoauth2/root/tokens/clients'

$response = Invoke-WebRequest $tokenUrl -Method POST -Body @{
	grant_type    = 'client_credentials'
	client_id     = $client_id
	client_secret = $client_secret
}
$token = $response.Content | ConvertFrom-Json
$token.access_token




} #end Function
