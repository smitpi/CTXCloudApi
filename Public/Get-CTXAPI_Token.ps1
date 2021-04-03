
<#PSScriptInfo

.VERSION 1.0.0

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
		[string]$client_id = '02ba0b44-5997-4b3f-a3d0-d1b1514d2537',
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$client_secret = 'VaMg_Ghixo_KvdoX9UPlWQ=='
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
