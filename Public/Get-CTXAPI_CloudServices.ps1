
<#PSScriptInfo

.VERSION 0.1.0

.GUID a7feac60-f442-4370-b96d-56e0613376ab

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
Created [03/11/2021_19:28] Initital Script Creating

.PRIVATEDATA

#>

<# 

.DESCRIPTION 
 Return details about cloud services and subscription 

#> 


# .ExternalHelp CTXCloudApi-help.xml

Function Get-CTXAPI_CloudServices {
<#
.SYNOPSIS
Return details about cloud services and subscription

.DESCRIPTION
Return details about cloud services and subscription

.PARAMETER APIHeader
Use Connect-CTXAPI to create headers

.EXAMPLE
Get-CTXAPI_CloudServices

#>
	[Cmdletbinding()]
	[OutputType([System.Object[]])]
	PARAM(
		[Parameter(Mandatory = $true)]
		[PSTypeName('CTXAPIHeaderObject')]$APIHeader)

	(Invoke-RestMethod -Uri "https://core.citrixworkspacesapi.net/$($ApiHeader.headers.'Citrix-CustomerId')/serviceStates" -Headers $ApiHeader.headers).items

} #end Function