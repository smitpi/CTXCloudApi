
<#PSScriptInfo

.VERSION 1.1.1

.GUID 7e2cc53d-2308-4c7f-96f0-6f7472a3f0b1

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
Return details about machine catalogs

#> 

Param()




Function Get-CTXAPI_MachineCatalogs {
<#
.SYNOPSIS
Return details about machine catalogs

.DESCRIPTION
Return details about machine catalogs

.PARAMETER APIHeader
Custom object from Get-CTXAPI_Headers

.EXAMPLE
Get-CTXAPI_MachineCatalogs -APIHeader $APIHeader

#>
	[Cmdletbinding()]
	[OutputType([System.Object[]])]
	PARAM(
		[PSTypeName(CTXAPIHeaderObject)]$APIHeader
	)

	(Invoke-RestMethod -Uri 'https://api.cloud.com/cvad/manage/MachineCatalogs/' -Method get -Headers $APIHeader.headers).items | ForEach-Object {
		Invoke-RestMethod -Uri "https://api.cloud.com/cvad/manage/MachineCatalogs/$($_.id)" -Method Get -Headers $APIHeader.headers
	}

} #end Function
