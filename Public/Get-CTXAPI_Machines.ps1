
<#PSScriptInfo

.VERSION 1.1.1

.GUID c33c8458-e6e0-4035-9b18-9e606a12fff4

.AUTHOR Pierre Smit

.COMPANYNAME iOCO Tech

.COPYRIGHT

.TAGS api ctx

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Created [06/10/2021_21:23] Initital Script Creating
Updated [07/10/2021_13:28] Script info updated for module

.PRIVATEDATA

#> 



<# 

.DESCRIPTION 
Return details about published apps

#> 

Param()


#.ExternalHelp CTXCloudApi-help.xml
Function Get-CTXAPI_Machines {
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

	((Invoke-WebRequest "https://api.cloud.com/cvadapis/$siteid/machines" -Headers $headers).Content | ConvertFrom-Json).items

	<#
	$machines = @()
	(((Invoke-WebRequest "https://api.cloud.com/cvadapis/$siteid/machines" -Headers $headers).Content | ConvertFrom-Json).items).Dnsname | ForEach-Object {
		$machines += ((Invoke-WebRequest "https://api.cloud.com/cvadapis/$siteid/machines/$_" -Headers $headers).Content | ConvertFrom-Json)
	}
	$machines
#>
} #end Function
