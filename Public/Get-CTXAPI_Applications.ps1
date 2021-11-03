
<#PSScriptInfo

.VERSION 0.1.0

.GUID 9dfebdd1-fcf2-4cf3-949e-a7be9a46537d

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
Created [03/11/2021_19:26] Initital Script Creating

.PRIVATEDATA

#>

<# 

.DESCRIPTION 
 Return details about published apps 

#> 



Function Get-CTXAPI_Applications {
<#
.SYNOPSIS
Return details about published apps

.DESCRIPTION
Return details about published apps

.PARAMETER APIHeader
Use Connect-CTXAPI to create headers

.EXAMPLE
Get-CTXAPI_Applications

#>
	[Cmdletbinding()]
	[OutputType([System.Object[]])]
	PARAM(
		[Parameter(Mandatory = $true)]
		[PSTypeName('CTXAPIHeaderObject')]$APIHeader)

	(Invoke-RestMethod -Uri 'https://api.cloud.com/cvad/manage/Applications/' -Method get -Headers $APIHeader.headers).items | ForEach-Object {
		Invoke-RestMethod -Uri "https://api.cloud.com/cvad/manage/Applications/$($_.id)" -Method Get -Headers $APIHeader.headers
	}

} #end Function