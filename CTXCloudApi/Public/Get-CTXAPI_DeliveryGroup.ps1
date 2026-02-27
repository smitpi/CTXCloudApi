
<#PSScriptInfo

.VERSION 1.1.8

.GUID 0f1991f9-3999-40f8-b43d-3b797eb22aa8

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
 Returns details about Delivery Groups (handles pagination). 

#> 



<#
.SYNOPSIS
Returns details about Delivery Groups (handles pagination).

.DESCRIPTION
Returns details about Delivery Groups from Citrix Cloud CVAD.

.PARAMETER APIHeader
Header object created by Connect-CTXAPI; contains authentication and request headers.

.EXAMPLE
Get-CTXAPI_DeliveryGroup -APIHeader $APIHeader | Select-Object Name, TotalMachines, InMaintenanceMode
Lists group name, total machines, and maintenance status.

.EXAMPLE
Get-CTXAPI_DeliveryGroup -APIHeader $APIHeader | Where-Object { $_.IsBroken }
Shows delivery groups marked as broken.

.INPUTS
None. Parameters are not accepted from the pipeline.

.OUTPUTS
PSCustomObject[]
Array of delivery group objects returned from the CVAD Manage API.

.LINK
https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_DeliveryGroup

#>

function Get-CTXAPI_DeliveryGroup {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_DeliveryGroup')]
    [Alias('Get-CTXAPI_DeliveryGroups')]
    [OutputType([psobject[]])]
    param(
        [Parameter(Mandatory = $true)]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader
    )

    if (-not(Test-CTXAPI_Header -APIHeader $APIHeader)) {Test-CTXAPI_Header -APIHeader $APIHeader -AutoRenew}
    else {	Write-Verbose "[$(Get-Date -Format HH:mm:ss) APIHEADER] Header still valid"}

    
    $requestUri = 'https://api.cloud.com/cvad/manage/DeliveryGroups?limit=1000'
    $data = Get-CTXAPIDatapages -APIHeader $APIHeader -uri $requestUri
    return $data
} #end Function
