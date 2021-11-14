
<#PSScriptInfo

.VERSION 0.1.2

.GUID 18f4de3b-a991-4aee-8bd6-1892110bbb1a

.AUTHOR Pierre Smit

.COMPANYNAME iOCO Tech

.COPYRIGHT

.TAGS ctx ps

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Created [03/11/2021_23:30] Initial Script Creating
Updated [06/11/2021_16:48] Using the new api
Updated [14/11/2021_07:05] Added more functions

.PRIVATEDATA

#> 





<#

.DESCRIPTION 
Details about current Cloud Connectors

#>


<#
.SYNOPSIS
Details about current Cloud Connectors

.DESCRIPTION
Details about current Cloud Connectors

.PARAMETER APIHeader
Use Connect-CTXAPI to create headers

.EXAMPLE
Get-CTXAPI_CloudConnectors -APIHeader $APIHeader

#>
Function Get-CTXAPI_CloudConnectors {
    [Cmdletbinding()]
    [OutputType([System.Object[]])]
    PARAM(
        [Parameter(Mandatory = $true)]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader)

    (Invoke-RestMethod -Uri "https://agenthub.citrixworkspacesapi.net/$($APIHeader.headers.'Citrix-CustomerId')/EdgeServers" -Method get -Headers $APIHeader.headers).id | ForEach-Object {
        Invoke-RestMethod -Uri "https://agenthub.citrixworkspacesapi.net/$($APIHeader.headers.'Citrix-CustomerId')/EdgeServers/$($_)" -Method Get -Headers $APIHeader.headers
    }
} #end Function
