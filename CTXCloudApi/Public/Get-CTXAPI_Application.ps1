﻿
<#PSScriptInfo

.VERSION 0.1.0

.GUID 0e921c82-3104-4753-9a17-344af43706ab

.AUTHOR Pierre Smit

.COMPANYNAME HTPCZA Tech

.COPYRIGHT

.TAGS ctx

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Created [09/01/2022_09:17] Initial Script Creating

.PRIVATEDATA

#>

<#

.DESCRIPTION
Return details about published apps

#>


<#
.SYNOPSIS
Return details about published apps

.DESCRIPTION
Return details about published apps

.PARAMETER APIHeader
Use Connect-CTXAPI to create headers

.EXAMPLE
Get-CTXAPI_Applications -APIHeader $APIHeader

#>

Function Get-CTXAPI_Application {
	[Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Applications')]
	[Alias('Get-CTXAPI_Applications')]
	[OutputType([System.Object[]])]
	PARAM(
		[Parameter(Mandatory = $true)]
		[PSTypeName('CTXAPIHeaderObject')]$APIHeader)

    (Invoke-RestMethod -Uri 'https://api.cloud.com/cvad/manage/Applications/' -Method get -Headers $APIHeader.headers).items | ForEach-Object {
		Invoke-RestMethod -Uri "https://api.cloud.com/cvad/manage/Applications/$($_.id)" -Method Get -Headers $APIHeader.headers
	}

} #end Function
