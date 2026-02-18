
<#PSScriptInfo

.VERSION 1.1.8

.GUID f551ba3e-e77c-458c-861c-779150316116

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
 Returns details about VDA machines (handles pagination). 

#> 



<#
.SYNOPSIS
Returns details about VDA machines (handles pagination).

.DESCRIPTION
Returns details about VDA machines from Citrix Cloud CVAD.

.PARAMETER APIHeader
Header object created by Connect-CTXAPI; contains authentication and request headers.



.EXAMPLE
$machines = Get-CTXAPI_Machine -APIHeader $APIHeader
Retrieves all machines and stores them for reuse.

.EXAMPLE
Get-CTXAPI_Machine -APIHeader $APIHeader | Select-Object DnsName, IPAddress, OSType, RegistrationState
Lists key machine fields for quick inspection.

.INPUTS
None. Parameters are not accepted from the pipeline.

.OUTPUTS
PSCustomObject[]
Array of machine objects returned from the CVAD Manage API.

.LINK
https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Machine

#>

function Get-CTXAPI_Machine {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Machine')]
    [Alias('Get-CTXAPI_Machines')]
    [OutputType([psobject[]])]
    param(
        [Parameter(Mandatory = $true)]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader
    )

    $requestUri = 'https://api-eu.cloud.com/cvad/manage/Machines?limit=1000'
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
