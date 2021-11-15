
<#PSScriptInfo

.VERSION 1.1.7

.GUID 8e3eaddb-c8e2-4cd6-8a70-0fbea6245f4d

.AUTHOR Pierre Smit

.COMPANYNAME iOCO Tech

.COPYRIGHT

.TAGS api citrix ctx cvad ps

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Created [03/04/2021_01:54] Initial Script Creating
Updated [06/04/2021_09:03] Script File Info was updated
Updated [05/10/2021_21:22] Module Info Updated
Updated [07/10/2021_13:28] Script info updated for module
Updated [03/11/2021_19:17] Info Update
Updated [06/11/2021_16:48] Using the new api

.PRIVATEDATA

#> 





<#

.DESCRIPTION 
Get high level configuration changes in the last x days

#>



<#
.SYNOPSIS
Get high level configuration changes in the last x days.

.DESCRIPTION
Get high level configuration changes in the last x days.

.PARAMETER Days
Number of days to report on.

.PARAMETER APIHeader
Use Connect-CTXAPI to create headers.

.EXAMPLE
Get-CTXAPI_ConfigLog -APIHeader $APIHeader -Days 15

#>
# .ExternalHelp  CTXCloudApi-help.xml
Function Get-CTXAPI_ConfigLog {
    [Cmdletbinding()]
    PARAM(
        [Parameter(Mandatory = $true)]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader,
        [Parameter(Mandatory = $true)]
        [string]$Days)


    (Invoke-RestMethod -Uri "https://api.cloud.com/cvad/manage/ConfigLog/Operations?days=$days" -Headers $APIHeader.headers).items

} #end Function
