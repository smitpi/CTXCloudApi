
<#PSScriptInfo

.VERSION 1.0.0

.GUID 5b8588ac-59f0-49c5-8631-8fd2c83f0c19

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
Created [06/10/2021_21:23] Initital Script Creating

.PRIVATEDATA

#>

<# 

.DESCRIPTION 
 Return details about published apps 

#> 

Param()

#.ExternalHelp CTXCloudApi-help.xml

Function Get-CTXAPI_SiteDetails {
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

	((Invoke-WebRequest "https://api-us.cloud.com/cvadapis/Sites/$siteid" -Headers $headers).Content | ConvertFrom-Json)
	#((Invoke-WebRequest "https://api-us.cloud.com/cvadapis/$siteid/tenants" -Headers $headers).Content | ConvertFrom-Json)


} #end Function
