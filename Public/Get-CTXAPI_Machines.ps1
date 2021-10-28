
<#PSScriptInfo

.VERSION 1.1.1

.GUID c33c8458-e6e0-4035-9b18-9e606a12fff4

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
Return details about vda machines

#> 

Param()


#.ExternalHelp CTXCloudApi-help.xml
Function Get-CTXAPI_Machines {
	<#
.SYNOPSIS
Return details about vda machines

.DESCRIPTION
Return details about vda machines

.PARAMETER APIHeader
Custom object from Get-CTXAPI_Headers

.EXAMPLE
Get-CTXAPI_Machines -APIHeader $APIHeader

#>
	[Cmdletbinding()]
	[OutputType([System.Object[]])]
	PARAM(
		[PSTypeName(CTXAPIHeaderObject)]$APIHeader,
		[switch]$GetPubDesktop =$false
	)

	(Invoke-RestMethod -Uri 'https://api.cloud.com/cvad/manage/Machines/' -Method get -Headers $APIHeader.headers).items | ForEach-Object {
		Invoke-RestMethod -Uri "https://api.cloud.com/cvad/manage/Machines/$($_.id)" -Method Get -Headers $APIHeader.headers
	}

	if ($GetPubDesktop){
	(Invoke-RestMethod -Uri 'https://api.cloud.com/cvad/manage/Machines/' -Method get -Headers $APIHeader.headers).items | ForEach-Object {
		Invoke-RestMethod -Uri "https://api.cloud.com/cvad/manage/Machines/$($_.id)/Desktop" -Method Get -Headers $APIHeader.headers
	}
}
} #end Function
