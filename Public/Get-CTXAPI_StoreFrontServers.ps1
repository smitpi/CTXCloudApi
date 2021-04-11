
<#PSScriptInfo

.VERSION 1.0.0

.GUID 5b996933-e86d-4a29-b665-d8315c40e89b

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
Created [11/04/2021_09:17] Initital Script Creating

.PRIVATEDATA

#>

<# 

.DESCRIPTION 
 Get storefront servers from api 

#> 

Param()


Function Get-CTXAPI_StoreFrontServers {
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


	((Invoke-WebRequest "https://api.cloud.com/cvadapis/$siteid/storefrontservers" -Headers $headers).Content | ConvertFrom-Json).items


} #end Function