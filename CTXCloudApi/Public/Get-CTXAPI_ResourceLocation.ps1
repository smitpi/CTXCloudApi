
<#PSScriptInfo

.VERSION 1.1.8

.GUID 3510156d-02af-4361-acb2-99f9e3d9d138

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
 Returns cloud Resource Locations. 

#> 



<#
.SYNOPSIS
Returns cloud Resource Locations.

.DESCRIPTION
Returns Citrix Cloud Resource Locations for the current customer.

.PARAMETER APIHeader
Header object created by Connect-CTXAPI; contains authentication and request headers.

.EXAMPLE
Get-CTXAPI_ResourceLocation -APIHeader $APIHeader
Lists all Resource Locations for the tenant.

.EXAMPLE
Get-CTXAPI_ResourceLocation -APIHeader $APIHeader | Select-Object name, description, id
Selects key fields from the returned items.

.INPUTS
None. Parameters are not accepted from the pipeline.

.OUTPUTS
PSCustomObject[]
Array of resource location objects returned from the Registry API.

.LINK
https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_ResourceLocation

#>

function Get-CTXAPI_ResourceLocation {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_ResourceLocation')]
    [Alias('Get-CTXAPI_ResourceLocations')]
    [OutputType([psobject[]])]
    param(
        [Parameter(Mandatory = $true)]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader)


    (Invoke-RestMethod -Uri "https://registry.citrixworkspacesapi.net/$($APIHeader.headers.'Citrix-CustomerId')/resourcelocations" -Headers $APIHeader.headers).items

} #end Function
