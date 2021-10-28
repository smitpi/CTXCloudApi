
<#PSScriptInfo

.VERSION 1.1.1

.GUID 47f78f99-0059-4a79-96bc-8af1cae12259

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
Return details about hosting (hypervizor)

#> 

Param()

#.ExternalHelp CTXCloudApi-help.xml
Function Get-CTXAPI_Hypervisors {
	<#
.SYNOPSIS
Return details about hosting (hypervizor)

.DESCRIPTION
Return details about hosting (hypervizor)

.PARAMETER APIHeader
Custom object from Get-CTXAPI_Headers

.EXAMPLE
Get-CTXAPI_Hypervisors -APIHeader $APIHeader

#>
	[Cmdletbinding()]
	[OutputType([System.Object[]])]
	PARAM(
		[PSTypeName(CTXAPIHeaderObject)]$APIHeader
	)

	(Invoke-RestMethod -Uri 'https://api.cloud.com/cvad/manage/hypervisors/' -Method get -Headers $APIHeader.headers).items | ForEach-Object {
		Invoke-RestMethod -Uri "https://api.cloud.com/cvad/manage/hypervisors/$($_.id)" -Method Get -Headers $APIHeader.headers
	}


} #end Function
