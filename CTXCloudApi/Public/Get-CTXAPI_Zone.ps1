
<#PSScriptInfo

.VERSION 0.1.1

.GUID dd758abe-6542-401a-a224-6507b6f590c7

.AUTHOR Pierre Smit

.COMPANYNAME HTPCZA Tech

.COPYRIGHT

.TAGS ctx ps

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Created [03/11/2021_19:35] Initial Script Creating
Updated [06/11/2021_16:49] Using the new api

.PRIVATEDATA

#>





<#

.DESCRIPTION
Get zone details

#>


<#
.SYNOPSIS
Get zone details

.DESCRIPTION
Get zone details

.PARAMETER APIHeader
Use Connect-CTXAPI to create headers

.EXAMPLE
 Get-CTXAPI_Zone -APIHeader $APIHeader

#>

Function Get-CTXAPI_Zone {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Zone')]
    [Alias('Get-CTXAPI_Zones')]
    [OutputType([System.Object[]])]
    PARAM(
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader
    )

    (Invoke-RestMethod -Uri 'https://api.cloud.com/cvad/manage/Zones/' -Method get -Headers $APIHeader.headers).items | ForEach-Object {
        Invoke-RestMethod -Uri "https://api.cloud.com/cvad/manage/Zones/$($_.id)" -Method Get -Headers $APIHeader.headers
    }
} #end Function
