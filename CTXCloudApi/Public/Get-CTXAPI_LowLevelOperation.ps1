
<#PSScriptInfo

.VERSION 0.1.1

.GUID 341638e1-4b02-4f7c-ae55-c4756a21d724

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
Created [03/11/2021_19:32] Initial Script Creating
Updated [06/11/2021_16:49] Using the new api

.PRIVATEDATA

#>



<#

.DESCRIPTION
Returns details about low-level configuration changes for a specific operation.
Queries the CVAD Manage API `ConfigLog/Operations/<HighLevelID>/LowLevelOperations` and returns the `items` collection.

#>


<#
.SYNOPSIS
Returns details about low-level configuration changes (more detailed).

.DESCRIPTION
Returns details about low-level configuration changes for a specific operation ID from Config Log.

.PARAMETER APIHeader
Header object created by Connect-CTXAPI; contains authentication and request headers.

.PARAMETER HighLevelID
Unique id for a config change (from Get-CTXAPI_ConfigLog).

.EXAMPLE
$ConfigLog = Get-CTXAPI_ConfigLog -APIHeader $APIHeader -Days 7
$LowLevelOperations = Get-CTXAPI_LowLevelOperation -APIHeader $APIHeader -HighLevelID $ConfigLog[0].id
Retrieves low-level operations for the first high-level operation in the past 7 days.

.EXAMPLE
Get-CTXAPI_LowLevelOperation -APIHeader $APIHeader -HighLevelID "<operation-id>" | Select-Object OperationType, Property, OldValue, NewValue
Shows key fields for each low-level change.

.INPUTS
None. Parameters are not accepted from the pipeline.

.OUTPUTS
System.Object[]
Array of low-level operation objects returned from the CVAD Manage API.

.LINK
https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_LowLevelOperation

#>

function Get-CTXAPI_LowLevelOperation {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_LowLevelOperation')]
    [Alias('Get-CTXAPI_LowLevelOperations')]
    [OutputType([System.Object[]])]
    param(
        [Parameter(Mandatory = $true)]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$HighLevelID)

    (Invoke-RestMethod -Uri "https://api.cloud.com/cvad/manage/ConfigLog/Operations/$($HighLevelID)/LowLevelOperations" -Method get -Headers $APIHeader.headers).items


}
