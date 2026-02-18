
<#PSScriptInfo

.VERSION 0.1.1

.GUID 7696386a-1c5f-4f56-81d4-926c33d2bc6e

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
Created [03/11/2021_19:29] Initial Script Creating
Updated [06/11/2021_16:49] Using the new api

.PRIVATEDATA

#>



<#

.DESCRIPTION
Returns details about hosting (hypervisor) connections from Citrix Cloud CVAD.
Retrieves all hypervisors (handling continuation tokens) and outputs the items returned by the API.

#>


<#
.SYNOPSIS
Returns details about hosting (hypervisor) connections (handles pagination).

.DESCRIPTION
Returns details about hosting (hypervisor) connections from Citrix Cloud CVAD.

.PARAMETER APIHeader
Header object created by Connect-CTXAPI; contains authentication and request headers.

.EXAMPLE
Get-CTXAPI_Hypervisor -APIHeader $APIHeader | Select-Object Name, HostingType, Enabled
Lists hypervisor name, hosting type, and enabled state.

.EXAMPLE
Get-CTXAPI_Hypervisor -APIHeader $APIHeader | Where-Object { $_.IsBroken }
Shows hypervisors marked as broken.

.INPUTS
None. Parameters are not accepted from the pipeline.

.OUTPUTS
System.Object[]
Array of hypervisor objects returned from the CVAD Manage API.

.LINK
https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Hypervisor

#>

function Get-CTXAPI_Hypervisor {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Hypervisor')]
    [Alias('Get-CTXAPI_Hypervisors')]
    [OutputType([System.Object[]])]
    param(
        [Parameter(Mandatory = $true)]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader
    )

    $requestUri = 'https://api-eu.cloud.com/cvad/manage/hypervisors?limit=1000'
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
