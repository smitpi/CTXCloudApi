
<#PSScriptInfo

.VERSION 0.1.0

.GUID 02947c49-f670-4398-8fdb-3b522c22b593

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
Created [03/11/2021_19:34] Initital Script Creating

.PRIVATEDATA

#>

#Requires -Module ImportExcel
#Requires -Module PSWriteHTML
#Requires -Module PSWriteColor

<# 

.DESCRIPTION 
 Return details about current sessions 

#> 



Function Get-CTXAPI_Session {
<#
.SYNOPSIS
Return details about current sessions

.DESCRIPTION
Return details about current sessions

.PARAMETER APIHeader
Use Connect-CTXAPI to create headers

.EXAMPLE
Get-CTXAPI_Session

#>
	[Cmdletbinding()]
	[OutputType([System.Object[]])]
	PARAM(
		[Parameter(Mandatory = $true)]
		[PSTypeName('CTXAPIHeaderObject')]$APIHeader
	)

	(Invoke-RestMethod -Uri 'https://api.cloud.com/cvad/manage/Sessions/' -Method get -Headers $APIHeader.headers).items
} #end Function
