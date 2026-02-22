
<#PSScriptInfo

.VERSION 1.1.8

.GUID 7231be1e-4b7b-41fc-a2df-8362e31b4741

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
 Returns details about current sessions (handles pagination). 

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
PSCustomObject[]
Array of session objects returned from the CVAD Manage API.

.LINK
https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Session

#>

function Get-CTXAPI_Session {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Session')]
    [Alias('Get-CTXAPI_Sessions')]
    [OutputType([psobject[]])]
    param(
        [Parameter(Mandatory = $true)]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader
    )
    $requestUri = 'https://api.cloud.com/cvad/manage/Sessions?limit=1000'
    $data = Get-CTXAPIDatapages -APIHeader $APIHeader -uri $requestUri
    return $data
} #end Function
