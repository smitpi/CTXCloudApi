
<#PSScriptInfo

.VERSION 1.0.0

.GUID 15a2bb20-bf6f-4eca-ad8f-96d878b5db89

.AUTHOR Pierre Smit

.COMPANYNAME iOCO Tech

.COPYRIGHT

.TAGS citrix

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Created [18/09/2021_08:03] Initital Script Creating

.PRIVATEDATA

#>

<# 

.DESCRIPTION 
 Creates Hashtable with settings 

#> 

Param()

Function Set-CTXAPI_DefaultParameters {
            [Cmdletbinding()]
            	param(
                [ValidateNotNullOrEmpty()]
		        [string]$CustomerId,
		        [Parameter()]
		        [ValidateNotNullOrEmpty()]
		        [string]$Client_Id,
		        [Parameter()]
		        [ValidateNotNullOrEmpty()]
		        [string]$Client_Secret
	            )
$ApiToken = Get-CTXAPI_Token -client_id $Client_Id -client_secret $Client_Secret
$SiteID = Get-CTXAPI_SiteID -CustomerId $CustomerId -ApiToken $ApiToken

$script:CTX_APIDefaultParm = @{
CustomerId = $CustomerId
SiteId = $SiteID
ApiToken = $ApiToken
}

$CTX_APIDefaultParm
Write-Color -Text 'Use ','@CTX_APIDefaultParm ','in the other commands.' -Color Cyan,Yellow,Cyan -LinesBefore 2 

} #end Function
