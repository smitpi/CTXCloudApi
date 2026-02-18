
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
Returns Zone details from Citrix Cloud CVAD.
Retrieves all zones (handling continuation tokens) and outputs the items returned by the API.

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
System.Object[]
Array of zone objects returned from the CVAD Manage API.

.LINK
https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Zone

#>

function Get-CTXAPI_Zone {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Zone')]
    [Alias('Get-CTXAPI_Zones')]
    [OutputType([System.Object[]])]
    param(
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader
    )

    $requestUri = 'https://api-eu.cloud.com/cvad/manage/Zones?limit=1000'
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
