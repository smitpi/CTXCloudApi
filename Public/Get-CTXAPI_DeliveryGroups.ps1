
<#PSScriptInfo

.VERSION 0.1.0

.GUID 2d5b1922-da2b-48c8-8d33-0686390699a8

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
Created [03/11/2021_19:29] Initital Script Creating

.PRIVATEDATA

#>

<# 

.DESCRIPTION 
 Return details about Delivery Groups 

#> 


# .ExternalHelp CTXCloudApi-help.xml

Function Get-CTXAPI_DeliveryGroups {
<#
.SYNOPSIS
Return details about Delivery Groups

.DESCRIPTION
Return details about Delivery Groups

.PARAMETER APIHeader
Use Connect-CTXAPI to create headers

.EXAMPLE
Get-CTXAPI_DeliveryGroup

#>
	[Cmdletbinding()]
	[OutputType([System.Object[]])]
	PARAM(
		[Parameter(Mandatory = $true)]
		[PSTypeName('CTXAPIHeaderObject')]$APIHeader
	)

	(Invoke-RestMethod -Uri 'https://api.cloud.com/cvad/manage/DeliveryGroups/' -Method get -Headers $APIHeader.headers).items | ForEach-Object {
		Invoke-RestMethod -Uri "https://api.cloud.com/cvad/manage/DeliveryGroups/$($_.id)" -Method Get -Headers $APIHeader.headers
	}

} #end Function