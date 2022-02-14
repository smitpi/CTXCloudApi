
<#PSScriptInfo

.VERSION 0.1.1

.GUID 7696386a-1c5f-4f56-81d4-926c33d2bc6e

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
Created [03/11/2021_19:29] Initial Script Creating
Updated [06/11/2021_16:49] Using the new api

.PRIVATEDATA

#>



<#

.DESCRIPTION
Return details about hosting (hypervisor)

#>


<#
.SYNOPSIS
Return details about hosting (hypervisor)

.DESCRIPTION
Return details about hosting (hypervisor)

.PARAMETER APIHeader
Use Connect-CTXAPI to create headers

.EXAMPLE
Get-CTXAPI_Hypervisor -APIHeader $APIHeader

#>

Function Get-CTXAPI_Hypervisor {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Hypervisor')]
    [Alias('Get-CTXAPI_Hypervisors')]
    [OutputType([System.Object[]])]
    PARAM(
        [Parameter(Mandatory = $true)]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader
    )

    (Invoke-RestMethod -Uri 'https://api.cloud.com/cvad/manage/hypervisors/' -Method get -Headers $APIHeader.headers).items | ForEach-Object {
        Invoke-RestMethod -Uri "https://api.cloud.com/cvad/manage/hypervisors/$($_.id)" -Method Get -Headers $APIHeader.headers
    }


} #end Function
