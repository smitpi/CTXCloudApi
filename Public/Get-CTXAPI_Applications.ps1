
<#PSScriptInfo

.VERSION 1.0.0

.GUID 5f6ad0a4-e034-47e5-b957-b70399c4e4eb

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
Created [06/10/2021_21:04] Initital Script Creating

.PRIVATEDATA

#>

<# 

.DESCRIPTION 
 Return details about published apps 

#> 

Param()


Function Get-CTXAPI_Applications {
[Cmdletbinding()]
    [OutputType([System.Object[]])]
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
