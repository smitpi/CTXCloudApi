
<#PSScriptInfo

.VERSION 0.1.1

.GUID 36405065-6970-4852-94ce-0cddf2898d29

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
Created [03/11/2021_19:33] Initial Script Creating
Updated [06/11/2021_16:49] Using the new api

.PRIVATEDATA

#>




<#

.DESCRIPTION
Return details about machine Catalogs

#>


<#
.SYNOPSIS
Return details about machine Catalogs

.DESCRIPTION
Return details about machine Catalogs

.PARAMETER APIHeader
Use Connect-CTXAPI to create headers

.EXAMPLE
$MachineCatalogs = Get-CTXAPI_MachineCatalog -APIHeader $APIHeader

#>

Function Get-CTXAPI_MachineCatalog {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_MachineCatalog')]
    [Alias('Get-CTXAPI_MachineCatalogs')]
    [OutputType([System.Object[]])]
    PARAM(
        [Parameter(Mandatory = $true)]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader	)

    (Invoke-RestMethod -Uri 'https://api.cloud.com/cvad/manage/MachineCatalogs/' -Method get -Headers $APIHeader.headers).items | ForEach-Object {
        Invoke-RestMethod -Uri "https://api.cloud.com/cvad/manage/MachineCatalogs/$($_.id)" -Method Get -Headers $APIHeader.headers
    }

} #end Function
