
<#PSScriptInfo

.VERSION 0.1.0

.GUID 0e921c82-3104-4753-9a17-344af43706ab

.AUTHOR Pierre Smit

.COMPANYNAME HTPCZA Tech

.COPYRIGHT

.TAGS ctx

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Created [09/01/2022_09:17] Initial Script Creating

.PRIVATEDATA

#>

<#

.DESCRIPTION
Return details about published apps

#>


<#
.SYNOPSIS
Return details about published apps

.DESCRIPTION
Return details about published apps

.PARAMETER APIHeader
Use Connect-CTXAPI to create headers

.EXAMPLE
Get-CTXAPI_Applications -APIHeader $APIHeader

#>

function Get-CTXAPI_Application {
	[Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Applications')]
	[Alias('Get-CTXAPI_Applications')]
	[OutputType([System.Object[]])]
	param(
		[Parameter(Mandatory = $true)]
		[PSTypeName('CTXAPIHeaderObject')]$APIHeader)


	$requestUri = 'https://api-eu.cloud.com/cvad/manage/Applications?limit=1000'
	$response = Invoke-RestMethod -Uri $requestUri -Method GET -Headers $APIHeader.headers

	# Safely get initial continuation token if present
	if ($response.PSObject.Properties['ContinuationToken']) {
		$ContinuationToken = $response.ContinuationToken
	} else {
		$ContinuationToken = $null
	}

	while (-not [string]::IsNullOrEmpty($ContinuationToken)) {
		$requestUriContinue = $requestUri + '&continuationtoken=' + $ContinuationToken
		$responsePage = Invoke-RestMethod -Uri $requestUriContinue -Method GET -Headers $APIHeader.headers

		# Merge items from the next page when available
		if ($responsePage.PSObject.Properties['Items']) {
			$response.Items += $responsePage.Items
		}

		# Safely read continuation token for the next page
		if ($responsePage.PSObject.Properties['ContinuationToken'] -and -not [string]::IsNullOrEmpty($responsePage.ContinuationToken)) {
			$ContinuationToken = $responsePage.ContinuationToken
		} else {
			$ContinuationToken = $null
		}
	}
	$response.items

} #end Function
