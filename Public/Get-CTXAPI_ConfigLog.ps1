
<#PSScriptInfo

.VERSION 1.0.0

.GUID 8e3eaddb-c8e2-4cd6-8a70-0fbea6245f4d

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
Created [03/04/2021_01:54] Initital Script Creating

#>

<# 

.DESCRIPTION 
 get cloud config log 

#> 

Param()


Function Get-CTXAPI_ConfigLog {
                PARAM(
					[Parameter(Mandatory = $true, Position = 0)]
               	 	[ValidateNotNullOrEmpty()]
					[string]$CustomerId,
					[Parameter(Mandatory = $true, Position = 1)]
               	 	[ValidateNotNullOrEmpty()]
					[string]$SiteId,
					[Parameter(Mandatory = $true, Position = 2)]
               	 	[ValidateNotNullOrEmpty()]
					[string]$Days,
                	[Parameter(Mandatory = $true, Position = 3)]
               	 	[ValidateNotNullOrEmpty()]
					[string]$ApiToken)

$headers = @{Authorization = "CwsAuth Bearer=$($ApiToken)"}
$headers += @{
	'Citrix-CustomerId' = $customerId
	Accept              = 'application/json'
}


((Invoke-WebRequest "https://api.cloud.com/cvadapis/$siteid/ConfigLog/Operations?days=$days" -Headers $headers).Content | ConvertFrom-Json).items





} #end Function
