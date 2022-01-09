
<#PSScriptInfo

.VERSION 1.1.7

.GUID 3b47fbca-6d13-4688-9161-5043088b967c

.AUTHOR Pierre Smit

.COMPANYNAME iOCO Tech

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
Get cloud Resource Locations

#>

<#
.SYNOPSIS
Get cloud Resource Locations

.DESCRIPTION
Get cloud Resource Locations

.PARAMETER APIHeader
Use Connect-CTXAPI to create headers

.EXAMPLE
Get-CTXAPI_ResourceLocations -APIHeader $APIHeader

#>

Function Get-CTXAPI_ResourceLocations {
    [Cmdletbinding()]
    PARAM(
        [Parameter(Mandatory = $true)]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader)


    (Invoke-RestMethod -Uri "https://registry.citrixworkspacesapi.net/$($APIHeader.headers.'Citrix-CustomerId')/resourcelocations" -Headers $APIHeader.headers).items

} #end Function
