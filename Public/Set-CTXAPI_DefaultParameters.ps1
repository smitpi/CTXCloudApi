
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
		        [string]$ClientId,
		        [Parameter()]
		        [ValidateNotNullOrEmpty()]
		        [string]$ClientSecret
	            )
$global:ApiToken = Get-CTXAPI_Token -client_id $ClientId -client_secret $ClientSecret
$global:SiteID = Get-CTXAPI_SiteID -CustomerId $CustomerId -ApiToken $ApiToken

[hashtable]$global:CTX_APIDefaultParm = @{
    CustomerId   = $CustomerId
    SiteId       = $SiteID
    ApiToken     = $ApiToken
}

[hashtable]$global:CTX_APIAllParm = @{
    CustomerId     = $CustomerId
    ClientId       = $ClientId
    ClientSecret   = $ClientSecret
    SiteId         = $SiteID
    ApiToken       = $ApiToken
    ReportPath     = $env:TEMP
}

Write-Color -Text 'Use ','@CTX_APIDefaultParm',' and ','@CTX_APIAllParm ','in the other commands.' -Color Cyan,Yellow,Cyan,Yellow,Cyan -LinesBefore 2 

} #end Function
