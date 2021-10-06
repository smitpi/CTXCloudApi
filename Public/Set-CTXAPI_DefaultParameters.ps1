
<#PSScriptInfo

.VERSION 1.0.0

.GUID 1d5077f2-38c0-4abc-9404-c209338557cb

.AUTHOR Pierre Smit

.COMPANYNAME iOCO Tech

.COPYRIGHT

.TAGS ctx

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Created [06/10/2021_21:23] Initital Script Creating

.PRIVATEDATA

#>

<# 

.DESCRIPTION 
 Return details about published apps 

#> 

Param()


Function Set-CTXAPI_DefaultParameters {
           [Cmdletbinding(SupportsShouldProcess=$true)]
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

        if ($pscmdlet.ShouldProcess("Target", "Operation")) {


$global:CustomerId = $CustomerId
$global:ClientId = $ClientId
$global:ClientSecret = $ClientSecret
$global:ApiToken = Get-CTXAPI_Token -client_id $ClientId -client_secret $ClientSecret
$global:SiteID = Get-CTXAPI_SiteID -CustomerId $CustomerId -ApiToken $ApiToken

$CTX_APIDefaultParm = @()
$CTX_APIAllParm = @()
$ClientDefault = @()

$CTX_APIDefaultParm = [psobject]@{
    CustomerId   = $CustomerId
    SiteId       = $SiteID
    ApiToken     = $ApiToken
}

$global:CTX_APIAllParm = [psobject]@{
    CustomerId     = $CustomerId
    ClientId       = $ClientId
    ClientSecret   = $ClientSecret
    SiteId         = $SiteID
    ApiToken       = $ApiToken
    ReportPath     = $env:TEMP
}
$out = Get-Variable CTX_APIDefaultParm
$out2 = Get-Variable CTX_APIAllParm

Write-Color -Text $out.Name -Color Green
$global:CTX_APIDefaultParm

Write-Color -Text $out2.Name -Color Green
$global:CTX_APIAllParm

Write-Color -Text 'Use ','@CTX_APIDefaultParm',' and ','@CTX_APIAllParm ','in the other commands.' -Color Cyan,Yellow,Cyan,Yellow,Cyan -LinesBefore 2
}

} #end Function
