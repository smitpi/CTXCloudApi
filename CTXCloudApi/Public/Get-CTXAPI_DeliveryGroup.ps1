
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


    
    $requestUri = 'https://api-eu.cloud.com/cvad/manage/DeliveryGroups?limit=1000'
    $response = Invoke-RestMethod -Uri $requestUri -Method GET -Headers $APIHeader.headers

    # Safely get initial continuation token if present
    if ($response.PSObject.Properties['ContinuationToken']) {
        $ContinuationToken = $response.ContinuationToken
    } else {
        $ContinuationToken = $null
    }

    while (-not [string]::IsNullOrEmpty($ContinuationToken)) {
        $requestUriContinue = $requestUri + '&continuationtoken=' + $ContinuationToken
        $responsePage = Invoke-RestMethod -Uri $requestUriContinue -Method GET -Headers $APIHeader.headers

        # Merge items from the next page when available
        if ($responsePage.PSObject.Properties['Items']) {
            $response.Items += $responsePage.Items
        }

        # Safely read continuation token for the next page
        if ($responsePage.PSObject.Properties['ContinuationToken'] -and -not [string]::IsNullOrEmpty($responsePage.ContinuationToken)) {
            $ContinuationToken = $responsePage.ContinuationToken
        } else {
            $ContinuationToken = $null
        }
    }
    $response.items

} #end Function
