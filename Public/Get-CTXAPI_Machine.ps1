
<#PSScriptInfo

.VERSION 0.1.0

.GUID 54693dbd-02ca-4269-96d6-96e30c60fb0b

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
Created [03/11/2021_19:33] Initital Script Creating

.PRIVATEDATA

#>

#Requires -Module ImportExcel
#Requires -Module PSWriteHTML
#Requires -Module PSWriteColor

<# 

.DESCRIPTION 
 Return details about vda machines 

#> 



Function Get-CTXAPI_Machine {
<#
.SYNOPSIS
Return details about vda machines

.DESCRIPTION
Return details about vda machines

.PARAMETER APIHeader
Use Connect-CTXAPI to create headers

.PARAMETER GetPubDesktop
Get published desktop details

.EXAMPLE
Get-CTXAPI_Machine

#>
	[Cmdletbinding()]
	[OutputType([System.Object[]])]
	PARAM(
		[Parameter(Mandatory = $true)]
		[PSTypeName('CTXAPIHeaderObject')]$APIHeader,
		[switch]$GetPubDesktop = $false
	)

	(Invoke-RestMethod -Uri 'https://api.cloud.com/cvad/manage/Machines/' -Method get -Headers $APIHeader.headers).items | ForEach-Object {
		Invoke-RestMethod -Uri "https://api.cloud.com/cvad/manage/Machines/$($_.id)" -Method Get -Headers $APIHeader.headers
	}

	if ($GetPubDesktop) {
		(Invoke-RestMethod -Uri 'https://api.cloud.com/cvad/manage/Machines/' -Method get -Headers $APIHeader.headers).items | ForEach-Object {
			Invoke-RestMethod -Uri "https://api.cloud.com/cvad/manage/Machines/$($_.id)/Desktop" -Method Get -Headers $APIHeader.headers
		}
	}
} #end Function