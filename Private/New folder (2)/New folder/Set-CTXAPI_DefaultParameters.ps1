
<#PSScriptInfo

.VERSION 1.1.3

.GUID 15a2bb20-bf6f-4eca-ad8f-96d878b5db89

.AUTHOR Pierre Smit

.COMPANYNAME iOCO Tech

.COPYRIGHT

.TAGS api citrix ctx cvad

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Created [18/09/2021_08:03] Initital Script Creating
Updated [05/10/2021_21:18] Module Info Updated
Updated [05/10/2021_21:22] Module Info Updated
Updated [06/10/2021_17:51] Added help file

.PRIVATEDATA

#>







<#

.DESCRIPTION
Get details on published applications

#>
Param()

# .ExternalHelp CTXCloudApi-help.xml
Function Set-CTXAPI_DefaultParameter {
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

$script:ApiToken = Get-CTXAPI_Token -client_id $ClientId -client_secret $ClientSecret
$script:SiteID = Get-CTXAPI_SiteID -CustomerId $CustomerId -ApiToken $ApiToken

[hashtable]$script:CTX_APIDefaultParm = @{
    CustomerId   = $CustomerId
    SiteId       = $SiteID
    ApiToken     = $ApiToken
}

[hashtable]$script:CTX_APIAllParm = @{
    CustomerId     = $CustomerId
    ClientId       = $ClientId
    ClientSecret   = $ClientSecret
    SiteId         = $SiteID
    ApiToken       = $ApiToken
    ReportPath     = $env:TEMP
}
$CTX_APIDefaultParm
$CTX_APIAllParm

Write-Color -Text 'Use ','@CTX_APIDefaultParm',' and ','@CTX_APIAllParm ','in the other commands.' -Color Cyan,Yellow,Cyan,Yellow,Cyan -LinesBefore 2
}
} #end Function
