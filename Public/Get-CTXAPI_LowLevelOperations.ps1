
<#PSScriptInfo

.VERSION 0.1.1

.GUID 341638e1-4b02-4f7c-ae55-c4756a21d724

.AUTHOR Pierre Smit

.COMPANYNAME iOCO Tech

.COPYRIGHT

.TAGS ctx ps

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Created [03/11/2021_19:32] Initial Script Creating
Updated [06/11/2021_16:49] Using the new api

.PRIVATEDATA

#>



<#

.DESCRIPTION
Return details about low lever config change (More detailed)

#>


<#
.SYNOPSIS
Return details about low lever config change (More detailed)

.DESCRIPTION
Return details about low lever config change (More detailed)

.PARAMETER APIHeader
Use Connect-CTXAPI to create headers

.PARAMETER HighLevelID
Unique id for a config change. From the Get-CTXAPI_ConfigLog function.

.EXAMPLE
$ConfigLog = Get-CTXAPI_ConfigLog -APIHeader $APIHeader -Days 7
$LowLevelOperations = Get-CTXAPI_LowLevelOperations -APIHeader $APIHeader -HighLevelID $ConfigLog[0].id

#>

Function Get-CTXAPI_LowLevelOperation {
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
