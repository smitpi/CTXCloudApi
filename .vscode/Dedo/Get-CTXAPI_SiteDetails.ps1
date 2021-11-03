
<#PSScriptInfo

.VERSION 1.1.1

.GUID 5b8588ac-59f0-49c5-8631-8fd2c83f0c19

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
Return details about your farm / site

#>

Param()

#.ExternalHelp CTXCloudApi-help.xml

Function Get-CTXAPI_SiteDetail {
	<#
.SYNOPSIS
Return details about your farm / site

.DESCRIPTION
Return details about your farm / site

.PARAMETER APIHeader
Use Connect-CTXAPI to create headers

.EXAMPLE
Get-CTXAPI_SiteDetails -APIHeader $APIHeader

#>
	[Cmdletbinding()]
	[OutputType([System.Object[]])]
	PARAM(
		[Parameter(Mandatory = $true)]
		[PSTypeName('CTXAPIHeaderObject')]$APIHeader	)

	Invoke-RestMethod -Uri "https://api.cloud.com/cvad/manage/Sites/$($APIHeader.headers.'Citrix-InstanceId')" -Method get -Headers $APIHeader.headers



} #end Function
