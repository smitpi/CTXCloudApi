
<#PSScriptInfo

.VERSION 0.1.0

.GUID 18f4de3b-a991-4aee-8bd6-1892110bbb1a

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
Created [03/11/2021_23:30] Initital Script Creating

.PRIVATEDATA

#>

<# 

.DESCRIPTION 
 Details about current Cloud Connectors 

#> 



Function Get-CTXAPI_CloudConnectors {
<#
.SYNOPSIS
Details about current Cloud Connectors

.DESCRIPTION
Details about current Cloud Connectors

.PARAMETER APIHeader
Use Connect-CTXAPI to create headers

.EXAMPLE
Get-CTXAPI_CloudConnectors

#>
	[Cmdletbinding()]
	[OutputType([System.Object[]])]
	PARAM(
		[Parameter(Mandatory = $true)]
		[PSTypeName('CTXAPIHeaderObject')]$APIHeader)

	(Invoke-RestMethod -Uri "https://agenthub.citrixworkspacesapi.net/$($APIHeaders.headers.'Citrix-CustomerId')/EdgeServers" -Method get -Headers $APIHeader.headers).id | ForEach-Object {
		Invoke-RestMethod -Uri "https://agenthub.citrixworkspacesapi.net/$($APIHeaders.headers.'Citrix-CustomerId')/EdgeServers/$($_)" -Method Get -Headers $APIHeader.headers
	}
} #end Function
