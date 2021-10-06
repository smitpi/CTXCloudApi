
<#PSScriptInfo

.VERSION 1.0.0

.GUID e397808a-0085-4ccb-9ed4-06fff40baf80

.AUTHOR Pierre Smit

.COMPANYNAME iOCO Tech

.COPYRIGHT

.TAGS ("ctx","vda","api","cloud")

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Created [06/10/2021_18:13] Initital Script Creating

.PRIVATEDATA

#>

<#

.DESCRIPTION
 "Return details of all delivery groups"

#>

Param()



# .ExternalHelp CTXCloudApi-help.xml

Function Get-CTXAPI_DeliveryGroup {
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

	$Delgroups = @()
	(((Invoke-WebRequest "https://api.cloud.com/cvadapis/$siteid/deliverygroups" -Headers $headers).Content | ConvertFrom-Json).items).name | ForEach-Object {
		$DelGroups += ((Invoke-WebRequest "https://api.cloud.com/cvadapis/$siteid/deliverygroups/$_" -Headers $headers).Content | ConvertFrom-Json)
	}
	$DelGroups

} #end Function
