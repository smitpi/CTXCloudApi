
<#PSScriptInfo

.VERSION 1.1.7

.GUID 3b47fbca-6d13-4688-9161-5043088b967c

.AUTHOR Pierre Smit

.COMPANYNAME HTPCZA Tech

.COPYRIGHT

.TAGS api citrix ctx cvad ps

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Created [03/04/2021_01:32] Initial Script Creating
Updated [05/10/2021_21:22] Module Info Updated
Updated [07/10/2021_13:28] Script info updated for module
Updated [03/11/2021_19:17] Info Update
Updated [06/11/2021_16:49] Using the new api

.PRIVATEDATA

#>





<#

.DESCRIPTION
Returns Citrix Cloud Resource Locations for the current customer.
Queries the Registry API and returns the `items` collection.

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
System.Object[]
Array of resource location objects returned from the Registry API.

.LINK
https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_ResourceLocation

#>

function Get-CTXAPI_ResourceLocation {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_ResourceLocation')]
    [Alias('Get-CTXAPI_ResourceLocations')]
    param(
        [Parameter(Mandatory = $true)]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader)


    (Invoke-RestMethod -Uri "https://registry.citrixworkspacesapi.net/$($APIHeader.headers.'Citrix-CustomerId')/resourcelocations" -Headers $APIHeader.headers).items

} #end Function
