
<#PSScriptInfo

.VERSION 0.1.1

.GUID a7feac60-f442-4370-b96d-56e0613376ab

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
Created [03/11/2021_19:28] Initial Script Creating
Updated [06/11/2021_16:48] Using the new api

.PRIVATEDATA

#>



<#

.DESCRIPTION
Returns details about Citrix Cloud services and subscription state.
Queries the Core Citrix Workspaces API `serviceStates` endpoint and returns the `items` collection.

#>


<#
.SYNOPSIS
Returns details about cloud services and subscription.

.DESCRIPTION
Returns details about Citrix Cloud services and subscription state from the `serviceStates` endpoint.

.PARAMETER APIHeader
Header object created by Connect-CTXAPI; contains authentication and request headers.

.EXAMPLE
Get-CTXAPI_CloudService -APIHeader $APIHeader | Select-Object serviceName, state, lastUpdated
Lists each service name, its current state, and the last update time.

.EXAMPLE
Get-CTXAPI_CloudService -APIHeader $APIHeader | Where-Object { $_.state -ne 'Enabled' }
Shows services that are not currently enabled.

.INPUTS
None. Parameters are not accepted from the pipeline.

.OUTPUTS
System.Object[]
Array of service state objects returned from the Core Workspaces API.

.LINK
https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_CloudService

#>

function Get-CTXAPI_CloudService {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_CloudService')]
    [Alias('Get-CTXAPI_CloudServices')]
    [OutputType([System.Object[]])]
    param(
        [Parameter(Mandatory = $true)]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader)

    (Invoke-RestMethod -Uri "https://core.citrixworkspacesapi.net/$($ApiHeader.headers.'Citrix-CustomerId')/serviceStates" -Headers $ApiHeader.headers).items

} #end Function
