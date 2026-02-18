
<#PSScriptInfo

.VERSION 0.1.1

.GUID 02947c49-f670-4398-8fdb-3b522c22b593

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
Created [03/11/2021_19:34] Initial Script Creating
Updated [06/11/2021_16:49] Using the new api

.PRIVATEDATA

#>




<#

.DESCRIPTION
Returns details about current sessions from Citrix Cloud CVAD.
Retrieves all sessions (handling continuation tokens) and outputs the items returned by the API.

#>


<#
.SYNOPSIS
Returns details about current sessions (handles pagination).

.DESCRIPTION
Returns details about current sessions from Citrix Cloud CVAD.

.PARAMETER APIHeader
Header object created by Connect-CTXAPI; contains authentication and request headers.

.EXAMPLE
Get-CTXAPI_Session -APIHeader $APIHeader
Retrieves and lists current session objects.

.EXAMPLE
Get-CTXAPI_Session -APIHeader $APIHeader | Select-Object UserName, DnsName, LogOnDuration, ConnectionState
Shows key fields for each session.

.INPUTS
None. Parameters are not accepted from the pipeline.

.OUTPUTS
System.Object[]
Array of session objects returned from the CVAD Manage API.

.LINK
https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Session

#>

function Get-CTXAPI_Session {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Session')]
    [Alias('Get-CTXAPI_Sessions')]
    [OutputType([System.Object[]])]
    param(
        [Parameter(Mandatory = $true)]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader
    )
    $requestUri = 'https://api-eu.cloud.com/cvad/manage/Sessions?limit=1000'
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
