
<#PSScriptInfo

.VERSION 1.0.0

.GUID e1a502c7-0dec-45cd-afed-d1041a24b1cf

.AUTHOR Pierre Smit

.COMPANYNAME iOCO Tech

.COPYRIGHT

.TAGS ctx

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Created [06/10/2021_19:58] Initital Script Creating

.PRIVATEDATA

#>

<# 

.DESCRIPTION 
 Get zone details from api 

#> 

Param()

#.ExternalHelp CTXCloudApi-help.xml


Function Get-CTXAPI_Zones {
	[Cmdletbinding()]
	PARAM(
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[string]$CustomerId,
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[string]$SiteId,
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[string]$ApiToken)

	$headers = [System.Collections.Hashtable]@{
		Authorization       = "CwsAuth Bearer=$($ApiToken)"
		'Citrix-CustomerId' = $customerId
		Accept              = 'application/json'
	}


	((Invoke-WebRequest "https://api.cloud.com/cvadapis/$siteid/zones" -Headers $headers).Content | ConvertFrom-Json).items

} #end Function
