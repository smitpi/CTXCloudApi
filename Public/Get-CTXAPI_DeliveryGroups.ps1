
<#PSScriptInfo

.VERSION 1.1.1

.GUID 411c19ab-8d64-4620-b1e6-5494eedd9a08

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
Function Get-CTXAPI_DeliveryGroups {
	[Cmdletbinding()]
    [OutputType([System.Object[]])]
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

	$Delgroups = @()
	(((Invoke-WebRequest "https://api.cloud.com/cvadapis/$siteid/deliverygroups" -Headers $headers).Content | ConvertFrom-Json).items).name | ForEach-Object {
		$DelGroups += ((Invoke-WebRequest "https://api.cloud.com/cvadapis/$siteid/deliverygroups/$_" -Headers $headers).Content | ConvertFrom-Json)
	}
	$DelGroups


} #end Function
