
<#PSScriptInfo

.VERSION 1.1.1

.GUID 8e117b47-e4b9-423e-9ee6-a82e45efd9b1

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
Return details about low lever config change (More detailed)

#>

Param()


#.ExternalHelp CTXCloudApi-help.xml
Function Get-CTXAPI_LowLevelOperation {
	<#
.SYNOPSIS
Return details about low lever config change (More detailed)

.DESCRIPTION
Return details about low lever config change (More detailed)

.PARAMETER APIHeader
Use Connect-CTXAPI to create headers

.PARAMETER HighLevelID
get the id from Get-CTXAPI_ConfigLog

.EXAMPLE
Get-CTXAPI_LowLevelOperations -APIHeader $APIHeader -HighLevelID $High.id

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
