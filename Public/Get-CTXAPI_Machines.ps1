
<#PSScriptInfo

.VERSION 1.0.5

.GUID a89d5b14-84f0-4461-ae32-fecbc349aa80

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
Created [03/04/2021_01:49] Initital Script Creating
Updated [06/04/2021_09:03] Script Fle Info was updated
Updated [20/04/2021_10:43] Script Fle Info was updated
Updated [22/04/2021_11:42] Script Fle Info was updated
Updated [05/05/2021_14:33] 'Update Manifest'
Updated [05/10/2021_21:22] Module Info Updated

.PRIVATEDATA

#>











<#

.DESCRIPTION
Get details about VDA Machines

#>

Param()


Function Get-CTXAPI_Machine {
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

	((Invoke-WebRequest "https://api.cloud.com/cvadapis/$siteid/machines" -Headers $headers).Content | ConvertFrom-Json).items

	<#
	$machines = @()
	(((Invoke-WebRequest "https://api.cloud.com/cvadapis/$siteid/machines" -Headers $headers).Content | ConvertFrom-Json).items).Dnsname | ForEach-Object {
		$machines += ((Invoke-WebRequest "https://api.cloud.com/cvadapis/$siteid/machines/$_" -Headers $headers).Content | ConvertFrom-Json)
	}
	$machines
#>

} #end Function
