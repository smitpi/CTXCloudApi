
<#PSScriptInfo

.VERSION 1.1.1

.GUID e1a502c7-0dec-45cd-afed-d1041a24b1cf

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
Created [06/10/2021_19:58] Initital Script Creating
Updated [07/10/2021_13:28] Script info updated for module

.PRIVATEDATA

#> 



<# 

.DESCRIPTION 
Get zone details from api

#> 

Param()

#.ExternalHelp CTXCloudApi-help.xml


Function Get-CTXAPI_Zones {
	<#
.SYNOPSIS
Get zone details from api

.DESCRIPTION
Get zone details from api

.PARAMETER APIHeader
Custom object from Get-CTXAPI_Headers

.EXAMPLE
Get-CTXAPI_Zones -APIHeader $APIHeader

#>
	[Cmdletbinding()]
	[OutputType([System.Object[]])]
	PARAM(
		[PSTypeName(CTXAPIHeaderObject)]$APIHeader
	)

	(Invoke-RestMethod -Uri 'https://api.cloud.com/cvad/manage/Zones/' -Method get -Headers $APIHeader.headers).items | ForEach-Object {
		Invoke-RestMethod -Uri "https://api.cloud.com/cvad/manage/Zones/$($_.id)" -Method Get -Headers $APIHeader.headers
	}
} #end Function
