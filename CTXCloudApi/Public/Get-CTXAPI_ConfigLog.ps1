
<#PSScriptInfo

.VERSION 1.1.7

.GUID 8e3eaddb-c8e2-4cd6-8a70-0fbea6245f4d

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
Created [03/04/2021_01:54] Initial Script Creating
Updated [06/04/2021_09:03] Script File Info was updated
Updated [05/10/2021_21:22] Module Info Updated
Updated [07/10/2021_13:28] Script info updated for module
Updated [03/11/2021_19:17] Info Update
Updated [06/11/2021_16:48] Using the new api

.PRIVATEDATA

#>





<#

.DESCRIPTION
Returns high-level configuration changes over the past X days.
Queries the CVAD Manage API `ConfigLog/Operations?days=<X>` and returns the `items` collection.

#>



<#
.SYNOPSIS
Returns high-level configuration changes in the last X days.

.DESCRIPTION
Returns high-level configuration changes over the past X days from the Config Log Operations endpoint.

.PARAMETER Days
Number of days to report on (e.g., 7, 15, 30).

.PARAMETER APIHeader
Header object created by Connect-CTXAPI; contains authentication and request headers.

.EXAMPLE
Get-CTXAPI_ConfigLog -APIHeader $APIHeader -Days 15 | Select-Object TimeStamp, ObjectType, OperationType, User
Shows recent configuration operations with key fields for the past 15 days.

.EXAMPLE
Get-CTXAPI_ConfigLog -APIHeader $APIHeader -Days 7 | Where-Object { $_.ObjectType -eq 'DeliveryGroup' }
Filters operations related to Delivery Groups in the last 7 days.

.INPUTS
None. Parameters are not accepted from the pipeline.

.OUTPUTS
System.Object[]
Array of configuration operation objects returned from the CVAD Manage API.

.LINK
https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_ConfigLog

#>

function Get-CTXAPI_ConfigLog {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_ConfigLog')]
    param(
        [Parameter(Mandatory = $true)]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader,
        [Parameter(Mandatory = $true)]
        [string]$Days)

        

    (Invoke-RestMethod -Uri "https://api.cloud.com/cvad/manage/ConfigLog/Operations?days=$days" -Headers $APIHeader.headers).items

} #end Function
