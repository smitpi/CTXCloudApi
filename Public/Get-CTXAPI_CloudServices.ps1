
<#PSScriptInfo

.VERSION 1.0.0

.GUID 409ebf3e-e88c-4a89-8dcc-e7bdb1ea6d0b

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
Created [06/10/2021_21:07] Initital Script Creating

.PRIVATEDATA

#>

<# 

.DESCRIPTION 
 Return details about published apps 

#> 

Param()
#.ExternalHelp CTXCloudApi-help.xml

Function Get-CTXAPI_CloudServices {
[Cmdletbinding()]
	PARAM(
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[string]$CustomerId,
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[string]$ApiToken)

	$headers = [System.Collections.Hashtable]@{
		Authorization       = "CwsAuth Bearer=$($ApiToken)"
		'Citrix-CustomerId' = $customerId
		Accept              = 'application/json'
	}

	((Invoke-WebRequest "https://core.citrixworkspacesapi.net/$customerId/serviceStates" -Headers $headers).Content | ConvertFrom-Json).items


} #end Function
