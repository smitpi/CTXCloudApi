
<#PSScriptInfo

.VERSION 1.1.8

.GUID 7329577d-a1e7-436c-bbd2-d509f4304a87

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
 Returns Zone details (handles pagination). 

#> 



<#
.SYNOPSIS
Returns Zone details (handles pagination).

.DESCRIPTION
Returns Zone details from Citrix Cloud CVAD.

.PARAMETER APIHeader
Header object created by Connect-CTXAPI; contains authentication and request headers.

.EXAMPLE
 Get-CTXAPI_Zone -APIHeader $APIHeader
Lists all zones for the tenant.

.EXAMPLE
Get-CTXAPI_Zone -APIHeader $APIHeader | Select-Object Name, Enabled, Description
Shows key fields for each zone.

.INPUTS
None. Parameters are not accepted from the pipeline.

.OUTPUTS
psobject[]
Array of zone objects returned from the CVAD Manage API.

.LINK
https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Zone

#>

function Get-CTXAPI_Zone {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Zone')]
    [Alias('Get-CTXAPI_Zones')]
    [OutputType([psobject[]])]
    param(
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader
    )
    if (-not(Test-CTXAPI_Header -APIHeader $APIHeader)) {Test-CTXAPI_Header -APIHeader $APIHeader -AutoRenew}
    else {	Write-Verbose "[$(Get-Date -Format HH:mm:ss) APIHEADER] Header still valid"}

    $requestUri = 'https://api.cloud.com/cvad/manage/Zones?limit=1000'
    $data = Get-CTXAPIDatapages -APIHeader $APIHeader -uri $requestUri
    return $data
} #end Function
