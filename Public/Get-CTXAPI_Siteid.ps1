
<#PSScriptInfo

.VERSION 1.0.1

.GUID 7b30365c-2695-4a40-b701-4d25be3cbaa5

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
Created [03/04/2021_00:58] Initital Script Creating
Updated [06/04/2021_09:03] Script Fle Info was updated

#> 



<# 

.DESCRIPTION 
get cloud site id

#> 

Param()


Function Get-CTXAPI_Siteid {
                PARAM(
					[Parameter(Mandatory = $true, Position = 0)]
               	 	[ValidateNotNullOrEmpty()]
					[string]$CustomerId,
                	[Parameter(Mandatory = $true, Position = 1)]
               	 	[ValidateNotNullOrEmpty()]
					[string]$ApiToken)

$headers = @{
	Authorization = "CwsAuth Bearer=$($ApiToken)"
}
$headers += @{
	'Citrix-CustomerId' = $customerId
	Accept              = 'application/json'
}


$me = Invoke-WebRequest 'https://api-us.cloud.com/cvadapis/me' -Headers $headers
($me.Content | ConvertFrom-Json).customers.sites.id

} #end Function
