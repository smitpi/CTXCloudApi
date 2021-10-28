
<#PSScriptInfo

.VERSION 1.1.1

.GUID 409ebf3e-e88c-4a89-8dcc-e7bdb1ea6d0b

.AUTHOR Pierre Smit

.COMPANYNAME iOCO Tech

.COPYRIGHT

.TAGS api ctx

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Created [06/10/2021_21:07] Initital Script Creating
Updated [07/10/2021_13:28] Script info updated for module

.PRIVATEDATA

#> 



<# 

.DESCRIPTION 
Return details about cloud services and subscription

#> 

Param()
#.ExternalHelp CTXCloudApi-help.xml

Function Get-CTXAPI_CloudServices {
	<#
.SYNOPSIS
Return details about cloud services and subscription

.DESCRIPTION
Return details about cloud services and subscription

.PARAMETER APIHeader
Custom object from Get-CTXAPI_Headers

.EXAMPLE
Get-CTXAPI_CloudServices -APIHeader $APIHeader

#>
	[Cmdletbinding()]
	[OutputType([System.Object[]])]
	PARAM(
		[PSTypeName(CTXAPIHeaderObject)]$APIHeader
	)


	(Invoke-RestMethod -Uri "https://core.citrixworkspacesapi.net/$($ApiHeader.headers.'Citrix-CustomerId')/serviceStates" -Headers $ApiHeader.headers).items

} #end Function
