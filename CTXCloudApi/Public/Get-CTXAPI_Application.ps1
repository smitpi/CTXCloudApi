
<#PSScriptInfo

.VERSION 1.1.8

.GUID 16f98a36-7797-40bf-b2ab-d61ba2547c2d

.AUTHOR Pierre Smit

.COMPANYNAME Private

.COPYRIGHT

.TAGS

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES


.PRIVATEDATA

#>

<# 

.DESCRIPTION 
 Returns details about published applications (handles pagination). 

#> 



<#
.SYNOPSIS
Returns details about published applications (handles pagination).

.DESCRIPTION
Returns details about published applications from Citrix Cloud CVAD.

.PARAMETER APIHeader
Header object created by Connect-CTXAPI; contains authentication and request headers.

.EXAMPLE
Get-CTXAPI_Application -APIHeader $APIHeader | Select-Object Name, Enabled, NumAssociatedDeliveryGroups
Lists application names, enabled state, and associated delivery group count.

.EXAMPLE
Get-CTXAPI_Application -APIHeader $APIHeader | Where-Object Enabled | Select-Object Name
Shows only enabled applications.

.INPUTS
None. Parameters are not accepted from the pipeline.

.OUTPUTS
PSCustomObject[]
Array of application objects returned from the CVAD Manage API.

.LINK
https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Application
#>

function Get-CTXAPI_Application {
	[Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Application')]
	[Alias('Get-CTXAPI_Applications')]
	[OutputType([psobject[]])]
	param(
		[Parameter(Mandatory = $true)]
		[ValidateNotNullorEmpty()]
		[PSTypeName('CTXAPIHeaderObject')]$APIHeader)


	$requestUri = 'https://api.cloud.com/cvad/manage/Applications?limit=1000'
	$data = Get-CTXAPIDatapages -APIHeader $APIHeader -uri $requestUri
	return $data

} #end Function
