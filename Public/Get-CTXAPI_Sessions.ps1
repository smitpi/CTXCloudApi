
<#PSScriptInfo

.VERSION 1.1.1

.GUID e94ac0d8-1b25-4adb-9712-7f75a070d83b

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
Return details about current sessions

#>

Param()
#.ExternalHelp CTXCloudApi-help.xml
Function Get-CTXAPI_Session {
	<#
.SYNOPSIS
Return details about current sessions

.DESCRIPTION
Return details about current sessions

.PARAMETER APIHeader
Use Connect-CTXAPI to create headers

.EXAMPLE
Get-CTXAPI_Sessions -APIHeader $APIHeader

#>
	[Cmdletbinding()]
	[OutputType([System.Object[]])]
	PARAM(
		[Parameter(Mandatory = $true)]
		[PSTypeName('CTXAPIHeaderObject')]$APIHeader
	)

	(Invoke-RestMethod -Uri 'https://api.cloud.com/cvad/manage/Sessions/' -Method get -Headers $APIHeader.headers).items
} #end Function
