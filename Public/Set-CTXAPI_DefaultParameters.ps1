
<#PSScriptInfo

.VERSION 1.1.1

.GUID 1d5077f2-38c0-4abc-9404-c209338557cb

.AUTHOR Pierre Smit

.COMPANYNAME iOCO Tech

.COPYRIGHT

.TAGS api ctx

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Created [06/10/2021_21:23] Initital Script Creating
Updated [07/10/2021_13:28] Script info updated for module

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
		[string]$ClientSecret,
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$CustomerName
	)

	if ($pscmdlet.ShouldProcess('Target', 'Operation')) {

		$global:ApiToken = Get-CTXAPI_Token -clientid $ClientId -clientsecret $ClientSecret
		$global:SiteID = Get-CTXAPI_SiteID -CustomerId $CustomerId -ApiToken $ApiToken

        $tmp = @()
		$tmp = [psobject]@{
			CustomerId = $CustomerId
			SiteId     = $SiteID
			ApiToken   = $ApiToken
		}
		
		$ou = New-Variable -Name CTX_API_$($CustomerName) -Value $tmp -Scope global -Force -PassThru

		Write-Color -Text $ou.Name -Color Green
		$ou.Value

		Write-Color -Text 'Use ',"`@$($ou.Name)",' to splat other commamds.' -Color Cyan,Yellow,Cyan,Yellow,Cyan -LinesBefore 2
	}

} #end Function
