
<#PSScriptInfo

.VERSION 1.1.1

.GUID 5f6ad0a4-e034-47e5-b957-b70399c4e4eb

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
Created [06/10/2021_21:04] Initital Script Creating
Updated [07/10/2021_13:28] Script info updated for module

.PRIVATEDATA

#> 



<# 

.DESCRIPTION 
Return details about published apps

#> 

#.ExternalHelp CTXCloudApi-help.xml
Function Get-CTXAPI_Applications {
<#
.SYNOPSIS
Return details about published apps

.DESCRIPTION
Return details about published apps

.PARAMETER APIHeader
Custom object from Get-CTXAPI_Headers

.EXAMPLE
Get-CTXAPI_Applications -APIHeader $APIHeader

#>
[Cmdletbinding()]
    [OutputType([System.Object[]])]
	PARAM(
		[PSTypeName(CTXAPIHeaderObject)]$APIHeader
	)

	(Invoke-RestMethod -Uri 'https://api.cloud.com/cvad/manage/Applications/' -Method get -Headers $APIHeader.headers).items | ForEach-Object {
		Invoke-RestMethod -Uri "https://api.cloud.com/cvad/manage/Applications/$($_.id)" -Method Get -Headers $APIHeader.headers
	}

} #end Function
