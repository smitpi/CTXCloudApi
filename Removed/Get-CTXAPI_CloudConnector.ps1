
<#PSScriptInfo

.VERSION 0.1.2

.GUID 18f4de3b-a991-4aee-8bd6-1892110bbb1a

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
Created [03/11/2021_23:30] Initial Script Creating
Updated [06/11/2021_16:48] Using the new api
Updated [14/11/2021_07:05] Added more functions

.PRIVATEDATA

#>





<#

.DESCRIPTION
Returns details about current Citrix Cloud Connectors.
Queries the Agent Hub API to list edge servers and retrieves full details for each connector.

#>


<#
.SYNOPSIS
Returns details about current Cloud Connectors.

.DESCRIPTION
Returns details about current Citrix Cloud Connectors by enumerating EdgeServers and expanding each to full detail.

.PARAMETER APIHeader
Header object created by Connect-CTXAPI; contains authentication and request headers.

.EXAMPLE
Get-CTXAPI_CloudConnector -APIHeader $APIHeader | Select-Object name, version, status
Lists connector name, version, and status.

.EXAMPLE
Get-CTXAPI_CloudConnector -APIHeader $APIHeader | Where-Object {$_.status -ne 'Healthy'}
Shows connectors not in a healthy state.

.INPUTS
None. Parameters are not accepted from the pipeline.

.OUTPUTS
System.Object[]
Array of Cloud Connector objects returned from the Agent Hub API.

.LINK
https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_CloudConnector

#>

function Get-CTXAPI_CloudConnector {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_CloudConnector')]
    [Alias('Get-CTXAPI_CloudConnectors')]
    [OutputType([System.Object[]])]
    param(
        [Parameter(Mandatory = $true)]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader)

    (Invoke-RestMethod -Uri "https://agenthub.citrixworkspacesapi.net/$($APIHeader.headers.'Citrix-CustomerId')/EdgeServers" -Method get -Headers $APIHeader.headers).id | ForEach-Object {
        Invoke-RestMethod -Uri "https://agenthub.citrixworkspacesapi.net/$($APIHeader.headers.'Citrix-CustomerId')/EdgeServers/$($_)" -Method Get -Headers $APIHeader.headers
    }
} #end Function
