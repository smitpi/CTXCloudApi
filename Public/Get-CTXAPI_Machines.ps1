
<#PSScriptInfo

.VERSION 1.0.1

.GUID a89d5b14-84f0-4461-ae32-fecbc349aa80

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
Created [03/04/2021_01:49] Initital Script Creating
Updated [06/04/2021_09:03] Script Fle Info was updated

#> 



<# 

.DESCRIPTION 
get cloud service info

#> 

Param()


Function Get-CTXAPI_Machines {
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

$headers = @{Authorization = "CwsAuth Bearer=$($ApiToken)"}
$headers += @{
	'Citrix-CustomerId' = $customerId
	Accept              = 'application/json'
}


((Invoke-WebRequest "https://api.cloud.com/cvadapis/$siteid/machines" -Headers $headers).Content | ConvertFrom-Json).items




} #end Function
