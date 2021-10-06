
<#PSScriptInfo

.VERSION 1.1.1

.GUID d68cb688-a371-4f63-95d9-396acff79fad

.AUTHOR Pierre Smit

.COMPANYNAME iOCO Tech

.COPYRIGHT

.TAGS "api" "cloud") "vda" ("ctx" api cloud ctx vda

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Created [06/10/2021_18:15] Initital Script Creating
Updated [06/10/2021_19:00] "Help Files Added"

.PRIVATEDATA

#>



<#

.DESCRIPTION
"Retrieves detailed logs  administrator actions, from the Get-CTXAPI_ConfigLog function"

#>

Param()



# .ExternalHelp CTXCloudApi-help.xml
Function Get-CTXAPI_LowLevelOperation {
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
		[string]$HighLevelID,
		[Parameter(Mandatory = $true, Position = 3)]
		[ValidateNotNullOrEmpty()]
		[string]$ApiToken)


	$headers = [System.Collections.Hashtable]@{
		Authorization       = "CwsAuth Bearer=$($ApiToken)"
		'Citrix-CustomerId' = $customerId
		Accept              = 'application/json'
	}


	((Invoke-WebRequest "https://api.cloud.com/cvadapis/$siteid/ConfigLog/Operations/$HighLevelID/LowLevelOperations" -Headers $headers).Content | ConvertFrom-Json).items

} #end Function
