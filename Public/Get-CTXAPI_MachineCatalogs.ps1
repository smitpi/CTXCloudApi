
<#PSScriptInfo

.VERSION 1.0.0

.GUID 7e2cc53d-2308-4c7f-96f0-6f7472a3f0b1

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




Function Get-CTXAPI_MachineCatalogs {
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

	$MachineCat = @()
	(((Invoke-WebRequest "https://api.cloud.com/cvadapis/$siteid/MachineCatalogs" -Headers $headers).Content | ConvertFrom-Json).items).name | ForEach-Object {
		$MachineCat += ((Invoke-WebRequest "https://api.cloud.com/cvadapis/$siteid/MachineCatalogs/$_" -Headers $headers).Content | ConvertFrom-Json)
	}
	$MachineCat


} #end Function
