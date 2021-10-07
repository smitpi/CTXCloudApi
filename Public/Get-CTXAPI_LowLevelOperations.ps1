
<#PSScriptInfo

.VERSION 1.0.0

.GUID 8e117b47-e4b9-423e-9ee6-a82e45efd9b1

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
Function Get-CTXAPI_LowLevelOperations {
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
		[string]$HighLevelID,
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[string]$ApiToken)


	$headers = [System.Collections.Hashtable]@{
		Authorization       = "CwsAuth Bearer=$($ApiToken)"
		'Citrix-CustomerId' = $customerId
		Accept              = 'application/json'
	}


	((Invoke-WebRequest "https://api.cloud.com/cvadapis/$siteid/ConfigLog/Operations/$HighLevelID/LowLevelOperations" -Headers $headers).Content | ConvertFrom-Json).items

}


