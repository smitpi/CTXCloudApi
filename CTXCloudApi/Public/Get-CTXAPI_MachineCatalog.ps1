
<#PSScriptInfo

.VERSION 1.1.8

.GUID 840adf50-231b-46d5-b3b7-a03280c9b3b3

.AUTHOR Pierre Smit

.COMPANYNAME Private

.COPYRIGHT

.TAGS

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES


.PRIVATEDATA

#>

<# 

.DESCRIPTION 
 Returns details about Machine Catalogs (handles pagination). 

#> 



<#
.SYNOPSIS
Returns details about Machine Catalogs (handles pagination).

.DESCRIPTION
Returns details about Machine Catalogs from Citrix Cloud CVAD.

.PARAMETER APIHeader
Header object created by Connect-CTXAPI; contains authentication and request headers.

.EXAMPLE
$MachineCatalogs = Get-CTXAPI_MachineCatalog -APIHeader $APIHeader
Retrieves all machine catalogs and stores them for reuse.

.EXAMPLE
Get-CTXAPI_MachineCatalog -APIHeader $APIHeader | Select-Object Name, SessionSupport, TotalCount, IsPowerManaged
Lists key catalog fields including session support, total machines, and power management.

.INPUTS
None. Parameters are not accepted from the pipeline.

.OUTPUTS
PSCustomObject[]
Array of machine catalog objects returned from the CVAD Manage API.

.LINK
https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_MachineCatalog

#>

function Get-CTXAPI_MachineCatalog {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_MachineCatalog')]
    [Alias('Get-CTXAPI_MachineCatalogs')]
    [OutputType([psobject[]])]
    param(
        [Parameter(Mandatory = $true)]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader	)

        
    if (-not(Test-CTXAPI_Header -APIHeader $APIHeader)) {Test-CTXAPI_Header -APIHeader $APIHeader -AutoRenew}
    else {	Write-Verbose "[$(Get-Date -Format HH:mm:ss) APIHEADER] Header still valid"}


    $requestUri = 'https://api.cloud.com/cvad/manage/MachineCatalogs?limit=1000'
    $data = Get-CTXAPIDatapages -APIHeader $APIHeader -uri $requestUri
    return $data
} #end Function
