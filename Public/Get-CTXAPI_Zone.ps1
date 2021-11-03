
<#PSScriptInfo

.VERSION 0.1.0

.GUID dd758abe-6542-401a-a224-6507b6f590c7

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
Created [03/11/2021_19:35] Initital Script Creating

.PRIVATEDATA

#>

#Requires -Module ImportExcel
#Requires -Module PSWriteHTML
#Requires -Module PSWriteColor

<# 

.DESCRIPTION 
 Get zone details 

#> 



Function Get-CTXAPI_Zone {
<#
.SYNOPSIS
Get zone details

.DESCRIPTION
Get zone details

.PARAMETER APIHeader
Use Connect-CTXAPI to create headers

.EXAMPLE
Get-CTXAPI_Zone

#>
	[Cmdletbinding()]
	[OutputType([System.Object[]])]
	PARAM(
		[PSTypeName('CTXAPIHeaderObject')]$APIHeader
	)

	(Invoke-RestMethod -Uri 'https://api.cloud.com/cvad/manage/Zones/' -Method get -Headers $APIHeader.headers).items | ForEach-Object {
		Invoke-RestMethod -Uri "https://api.cloud.com/cvad/manage/Zones/$($_.id)" -Method Get -Headers $APIHeader.headers
	}
} #end Function