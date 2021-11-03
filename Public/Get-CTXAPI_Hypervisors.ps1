
<#PSScriptInfo

.VERSION 0.1.0

.GUID 7696386a-1c5f-4f56-81d4-926c33d2bc6e

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
 Return details about hosting (hypervisor) 

#> 


# .ExternalHelp CTXCloudApi-help.xml

Function Get-CTXAPI_Hypervisors {
<#
.SYNOPSIS
Return details about hosting (hypervisor)

.DESCRIPTION
Return details about hosting (hypervisor)

.PARAMETER APIHeader
Use Connect-CTXAPI to create headers

.EXAMPLE
Get-CTXAPI_Hypervisor

#>
	[Cmdletbinding()]
	[OutputType([System.Object[]])]
	PARAM(
		[Parameter(Mandatory = $true)]
		[PSTypeName('CTXAPIHeaderObject')]$APIHeader
	)

	(Invoke-RestMethod -Uri 'https://api.cloud.com/cvad/manage/hypervisors/' -Method get -Headers $APIHeader.headers).items | ForEach-Object {
		Invoke-RestMethod -Uri "https://api.cloud.com/cvad/manage/hypervisors/$($_.id)" -Method Get -Headers $APIHeader.headers
	}


} #end Function