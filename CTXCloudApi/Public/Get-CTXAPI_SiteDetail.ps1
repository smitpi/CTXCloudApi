
<#PSScriptInfo

.VERSION 0.1.1

.GUID d52798b4-350d-491e-bd04-dea52b1ef49c

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
Returns details about your CVAD site (farm).
Queries the CVAD Manage API using the resolved `Citrix-InstanceId` and returns the site object.

#>


<#
.SYNOPSIS
Returns details about your CVAD site.

.DESCRIPTION
Returns details about your CVAD site (farm) from Citrix Cloud.

.PARAMETER APIHeader
Header object created by Connect-CTXAPI; contains authentication and request headers.

.EXAMPLE
Get-CTXAPI_SiteDetail -APIHeader $APIHeader
Returns the site details for the current `Citrix-InstanceId`.

.EXAMPLE
Get-CTXAPI_SiteDetail -APIHeader $APIHeader | Select-Object Name, FunctionalLevel, LicensingMode
Selects key fields from the site object.

.INPUTS
None. Parameters are not accepted from the pipeline.

.OUTPUTS
System.Object
Site detail object returned from the CVAD Manage API.

.LINK
https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_SiteDetail

#>

function Get-CTXAPI_SiteDetail {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_SiteDetail')]
    [Alias('Get-CTXAPI_SiteDetails')]
    [OutputType([System.Object[]])]
    param(
        [Parameter(Mandatory = $true)]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader	)

    Invoke-RestMethod -Uri "https://api.cloud.com/cvad/manage/Sites/$($APIHeader.headers.'Citrix-InstanceId')" -Method get -Headers $APIHeader.headers



} #end Function
