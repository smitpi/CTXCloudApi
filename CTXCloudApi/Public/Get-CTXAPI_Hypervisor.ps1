
<#PSScriptInfo

.VERSION 1.1.8

.GUID 058030ee-c22c-451c-b62d-146ee6064682

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
 Returns details about hosting (hypervisor) connections (handles pagination). 

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
PSCustomObject[]
Array of hypervisor objects returned from the CVAD Manage API.

.LINK
https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Hypervisor

#>

function Get-CTXAPI_Hypervisor {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Hypervisor')]
    [Alias('Get-CTXAPI_Hypervisors')]
    [OutputType([psobject[]])]
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
