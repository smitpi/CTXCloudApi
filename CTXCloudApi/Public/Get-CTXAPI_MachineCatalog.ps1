
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
System.Object[]
Array of machine catalog objects returned from the CVAD Manage API.

.LINK
https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_MachineCatalog

#>

function Get-CTXAPI_MachineCatalog {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_MachineCatalog')]
    [Alias('Get-CTXAPI_MachineCatalogs')]
    [OutputType([System.Object[]])]
    param(
        [Parameter(Mandatory = $true)]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader	)


    $requestUri = 'https://api-eu.cloud.com/cvad/manage/MachineCatalogs?limit=1000'
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
