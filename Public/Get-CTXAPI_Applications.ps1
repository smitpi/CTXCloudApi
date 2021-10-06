
<#PSScriptInfo

.VERSION 1.0.5

.GUID be2a50c0-7921-4bcb-a556-606bdf5f4ca7

.AUTHOR Pierre Smit

.COMPANYNAME iOCO Tech

.COPYRIGHT

.TAGS api citrix ctx cvad

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Created [03/04/2021_01:17] Initital Script Creating
Updated [06/04/2021_09:03] Script Fle Info was updated
Updated [20/04/2021_10:42] Script Fle Info was updated
Updated [22/04/2021_11:42] Script Fle Info was updated
Updated [05/10/2021_21:11] Module Info Updated
Updated [05/10/2021_21:22] Module Info Updated

.PRIVATEDATA

#>











<#

.DESCRIPTION
Get details on published applications

#>
# .ExternalHelp CTXCloudApi-help.xml

Function Get-CTXAPI_Application {
	[Cmdletbinding()]
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

	$headers = [System.Collections.Hashtable]@{
		Authorization       = "CwsAuth Bearer=$($ApiToken)"
		'Citrix-CustomerId' = $customerId
		Accept              = 'application/json'
	}
	$apps = @()
	(((Invoke-WebRequest "https://api.cloud.com/cvadapis/$siteid/applications" -Headers $headers).Content | ConvertFrom-Json).items).name | ForEach-Object {
		$apps += ((Invoke-WebRequest "https://api.cloud.com/cvadapis/$siteid/applications/$_" -Headers $headers).Content | ConvertFrom-Json)
	}
	$apps



} #end Function
