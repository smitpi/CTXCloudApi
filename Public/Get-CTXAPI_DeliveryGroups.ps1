
<#PSScriptInfo

.VERSION 1.1.1

.GUID 411c19ab-8d64-4620-b1e6-5494eedd9a08

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
Created [06/10/2021_21:23] Initital Script Creating
Updated [07/10/2021_13:28] Script info updated for module

.PRIVATEDATA

#> 



<# 

.DESCRIPTION 
Return details about Delivery Groups

#> 

Param()

#.ExternalHelp CTXCloudApi-help.xml
Function Get-CTXAPI_DeliveryGroups {
	<#
.SYNOPSIS
Return details about Delivery Groups

.DESCRIPTION
Return details about Delivery Groups

.PARAMETER APIHeader
Custom object from Get-CTXAPI_Headers

.EXAMPLE
Get-CTXAPI_DeliveryGroups -APIHeader $APIHeader

#>
	[Cmdletbinding()]
	[OutputType([System.Object[]])]
	PARAM(
		[PSTypeName(CTXAPIHeaderObject)]$APIHeader
	)

	(Invoke-RestMethod -Uri 'https://api.cloud.com/cvad/manage/DeliveryGroups/' -Method get -Headers $APIHeader.headers).items | ForEach-Object {
		Invoke-RestMethod -Uri "https://api.cloud.com/cvad/manage/DeliveryGroups/$($_.id)" -Method Get -Headers $APIHeader.headers
	}

} #end Function
