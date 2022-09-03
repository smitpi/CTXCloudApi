
<#PSScriptInfo

.VERSION 0.1.0

.GUID 78b2a2b9-01c1-4296-bc53-82adfb509c60

.AUTHOR Pierre Smit

.COMPANYNAME HTPCZA Tech

.COPYRIGHT

.TAGS ctx

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Created [03/09/2022_16:47] Initial Script Creating

.PRIVATEDATA

#>

#Requires -Module PSWriteColor

<# 

.DESCRIPTION 
 This function will add connection settings to PSDefaultParameter and your profile. 

#> 


<#
.SYNOPSIS
This function will add connection settings to PSDefaultParameter and your profile.

.DESCRIPTION
This function will add connection settings to PSDefaultParameter and your profile.

.PARAMETER Customer_Id
From Citrix Cloud

.PARAMETER Client_Id
From Citrix Cloud

.PARAMETER Client_Secret
From Citrix Cloud

.PARAMETER Customer_Name
Name of your Company, or what you want to call your connection.

.PARAMETER RemoveConfig
Remove the config from your profile.

.EXAMPLE
$splat = @{
	Customer_Id = "xxx"
	Client_Id = "xxx-xxx-xxx-xxx"
	Client_Secret = "yyyyyy=="
	Customer_Name = 'HomeLab'
}
Add-CTXAPI_DefaultsToProfile @splat

#>
Function Add-CTXAPI_DefaultsToProfile {
	[Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Add-CTXAPI_DefaultsToProfile')]
	[OutputType([System.Object[]])]
	PARAM(
		[Parameter(Mandatory)]
		[string]$Customer_Id,
		[Parameter(Mandatory)]
		[string]$Client_Id,
		[Parameter(Mandatory)]
		[string]$Client_Secret,
		[Parameter(Mandatory)]
		[string]$Customer_Name,
		[switch]$RemoveConfig
	)
	try {
		$PSDefaultParameterValues.Add('*CTXAPI*:Customer_Id', "$($Customer_Id)")
		$PSDefaultParameterValues.Add('*CTXAPI*:Client_Id', "$($Client_Id)")
		$PSDefaultParameterValues.Add('*CTXAPI*:Client_Secret', "$($Client_Secret)")
		$PSDefaultParameterValues.Add('*CTXAPI*:Customer_Name', "$($Customer_Name)")
	} catch {Write-Warning "Error: `n`tMessage:$($_.Exception.Message)"}
	$ToAppend = @"

#region CTXAPI Defaults
`$PSDefaultParameterValues['*CTXAPI*:Customer_Id'] = "$($Customer_Id)"
`$PSDefaultParameterValues['*CTXAPI*:Client_Id'] = "$($Client_Id)"
`$PSDefaultParameterValues['*CTXAPI*:Client_Secret'] = "$($Client_Secret)"
`$PSDefaultParameterValues['*CTXAPI*:Customer_Name'] = "$($Customer_Name)"
#endregion CTXAPI

"@
	
	try {
		$CheckProfile = Get-Item $PROFILE -ErrorAction Stop
	} catch { $CheckProfile = New-Item $PROFILE -ItemType File -Force}
	
	$Files = Get-ChildItem -Path "$($CheckProfile.Directory)\*profile*"

	foreach ($file in $files) {	
		$tmp = Get-Content -Path $file.FullName | Where-Object { $_ -notlike '*CTXAPI*'}
		$tmp | Set-Content -Path $file.FullName -Force
		if (-not($RemoveConfig)) {Add-Content -Value $ToAppend -Path $file.FullName -Force -Encoding utf8 }
		Write-Host '[Updated]' -NoNewline -ForegroundColor Yellow; Write-Host ' Profile File:' -NoNewline -ForegroundColor Cyan; Write-Host " $($file.FullName)" -ForegroundColor Green
	}

} #end Function