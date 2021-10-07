
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

#.ExternalHelp CTXCloudApi-help.xml

Function Set-CTXAPI_DefaultParameters {
	[Cmdletbinding(SupportsShouldProcess = $true)]
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

	if ($pscmdlet.ShouldProcess('Target', 'Operation')) {


		$global:CustomerId = $CustomerId
		$global:ClientId = $ClientId
		$global:ClientSecret = $ClientSecret
		$global:ApiToken = Get-CTXAPI_Token -clientid $ClientId -clientsecret $ClientSecret
		$global:SiteID = Get-CTXAPI_SiteID -CustomerId $CustomerId -ApiToken $ApiToken

		$CTX_API = @()
		$CTX_API = [psobject]@{
			CustomerId = $CustomerId
			SiteId     = $SiteID
			ApiToken   = $ApiToken
		}
		
		$out = Get-Variable CTX_API

		Write-Color -Text $out.Name -Color Green
		$CTX_API

		Write-Color -Text 'Use ','@CTX_API',' to splat other commamds.' -Color Cyan,Yellow,Cyan,Yellow,Cyan -LinesBefore 2
	}

} #end Function
