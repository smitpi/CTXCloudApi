
<#PSScriptInfo

.VERSION 0.1.0

.GUID 341638e1-4b02-4f7c-ae55-c4756a21d724

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
Created [03/11/2021_19:32] Initital Script Creating

.PRIVATEDATA

#>

<# 

.DESCRIPTION 
 Return details about low lever config change (More detailed) 

#> 


# .ExternalHelp CTXCloudApi-help.xml

Function Get-CTXAPI_LowLevelOperations {
<#
.SYNOPSIS
Return details about low lever config change (More detailed)

.DESCRIPTION
Return details about low lever config change (More detailed)

.PARAMETER APIHeader
Use Connect-CTXAPI to create headers

.PARAMETER HighLevelID
High id

.EXAMPLE
Get-CTXAPI_LowLevelOperation

#>
	[Cmdletbinding()]
	[OutputType([System.Object[]])]
	PARAM(
		[Parameter(Mandatory = $true)]
		[PSTypeName('CTXAPIHeaderObject')]$APIHeader,
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[string]$HighLevelID)

	(Invoke-RestMethod -Uri "https://api.cloud.com/cvad/manage/ConfigLog/Operations/$($HighLevelID)/LowLevelOperations" -Method get -Headers $APIHeader.headers).items


}
