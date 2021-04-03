
<#PSScriptInfo

.VERSION 1.0.0

.GUID ee88aaa7-ac78-46f9-896b-3b29aea20a00

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
Created [03/04/2021_01:17] Initital Script Creating

#>

<# 

.DESCRIPTION 
 get cloud Sessions 

#> 

Param()


Function Get-CTXAPI_Sessions {
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


((Invoke-WebRequest "https://api.cloud.com/cvadapis/$siteid/sessions" -Headers $headers).Content | ConvertFrom-Json).items

} #end Function