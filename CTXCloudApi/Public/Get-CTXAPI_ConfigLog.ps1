
<#PSScriptInfo

.VERSION 1.1.8

.GUID f59cc498-a4c5-4ca9-9de5-bee2682d67ca

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
 Returns high-level configuration changes in the last X days. 

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

        
    if (-not(Test-CTXAPI_Header -APIHeader $APIHeader)) {Test-CTXAPI_Header -APIHeader $APIHeader -AutoRenew}
    else {	Write-Verbose "[$(Get-Date -Format HH:mm:ss) APIHEADER] Header still valid"}

    (Invoke-RestMethod -Uri "https://api.cloud.com/cvad/manage/ConfigLog/Operations?days=$days" -Headers $APIHeader.headers).items

} #end Function
