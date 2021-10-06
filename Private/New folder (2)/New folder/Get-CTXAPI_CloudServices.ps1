﻿
<#PSScriptInfo

.VERSION 1.0.4

.GUID d169133e-621a-46b4-9782-0ab323ced022

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
Created [03/04/2021_01:33] Initital Script Creating
Updated [06/04/2021_09:03] Script Fle Info was updated
Updated [20/04/2021_10:42] Script Fle Info was updated
Updated [22/04/2021_11:42] Script Fle Info was updated
Updated [05/10/2021_21:22] Module Info Updated

.PRIVATEDATA

#>

<#

.DESCRIPTION
Get details on the cloud services.

#>


Param()

# .ExternalHelp CTXCloudApi-help.xml

Function Get-CTXAPI_CloudService {
	[Cmdletbinding()]
	PARAM(
		[Parameter(Mandatory = $true, Position = 0)]
		[ValidateNotNullOrEmpty()]
		[string]$CustomerId,
		[Parameter(Mandatory = $true, Position = 2)]
		[ValidateNotNullOrEmpty()]
		[string]$ApiToken)

	$headers = [System.Collections.Hashtable]@{
		Authorization       = "CwsAuth Bearer=$($ApiToken)"
		'Citrix-CustomerId' = $customerId
		Accept              = 'application/json'
	}

	((Invoke-WebRequest "https://core.citrixworkspacesapi.net/$customerId/serviceStates" -Headers $headers).Content | ConvertFrom-Json).items


} #end Function