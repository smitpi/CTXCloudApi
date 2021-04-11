
<#PSScriptInfo

.VERSION 1.0.0

.GUID 8474c4cc-e529-4c1f-8820-9b299fe9fa19

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
Created [11/04/2021_09:19] Initital Script Creating

.PRIVATEDATA

#>

<# 

.DESCRIPTION 
 Get zones servers from api 

#> 

Param()


Function Get-CTXAPI_Zones {
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

	$headers = @{Authorization = "CwsAuth Bearer=$($ApiToken)" }
	$headers += @{
		'Citrix-CustomerId' = $customerId
		Accept              = 'application/json'
	}


	((Invoke-WebRequest "https://api.cloud.com/cvadapis/$siteid/zones" -Headers $headers).Content | ConvertFrom-Json).items


} #end Function
