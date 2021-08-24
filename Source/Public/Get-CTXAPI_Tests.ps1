
<#PSScriptInfo

.VERSION 1.0.0

.GUID 2771087e-b214-426e-aa65-95c2960ea6f6

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
Created [24/08/2021_10:02] Initital Script Creating

#>

<# 

.DESCRIPTION 
 Run CVAD Tests and results 

#> 

Param()


#Requires -Module ImportExcel
#Requires -Module PSWriteHTML
#Requires -Module PSWriteColor
Function Get-CTXAPI_Tests {
                PARAM(
		            [Parameter(Mandatory = $true, Position = 0)]
		            [ValidateNotNullOrEmpty()]
		            [string]$CustomerId,
		            [Parameter(Mandatory = $true, Position = 1)]
		            [ValidateNotNullOrEmpty()]
		            [string]$SiteId,
		            [Parameter(Mandatory = $true, Position = 2)]
		            [ValidateNotNullOrEmpty()]
		            [string]$ApiToken,
                    [switch]$SiteTest = $false,
                    [switch]$HypervisorsTest = $false,	
                    [switch]$DeliveryGroupsTest = $false,
                    [switch]$MachineCatalogsTest = $false,
                    [Parameter(Mandatory = $false, Position = 3)]
					[ValidateSet('Excel', 'HTML')]
					[string]$Export = 'Host',
                	[Parameter(Mandatory = $false, Position = 4)]
					[ValidateScript( { (Test-Path $_) })]
					[string]$ReportPath = $env:temp
				)


$headers = [System.Collections.Hashtable]@{
		Authorization       = "CwsAuth Bearer=$($ApiToken)"
		'Citrix-CustomerId' = $customerId
		Accept              = 'application/json'
	}

$data = @()

if ($SiteTest){
Invoke-WebRequest "https://api-us.cloud.com/cvadapis/sites/$siteid/`$test" -Headers $headers -ContentType 'application/json' -Method Post
$data += (Invoke-RestMethod "https://api-us.cloud.com/cvadapis/sites/$siteid/TestReport" -Headers $headers -ContentType 'application/json').TestResults 
}

if ($HypervisorsTest){
(Invoke-RestMethod "https://api.cloud.com/cvadapis/$siteid/hypervisors" -Headers $headers).items.id | ForEach-Object {Invoke-RestMethod "https://api.cloud.com/cvadapis/$siteid/hypervisors/$_/`$test" -Method Post -Headers $headers -ContentType 'application/json'}
$data += (Invoke-RestMethod "https://api.cloud.com/cvadapis/$siteid/hypervisors" -Headers $headers).items.id | ForEach-Object {(Invoke-RestMethod "https://api.cloud.com/cvadapis/$siteid/hypervisors/$_/TestReport" -Headers $headers).TestResults}
}

if ($DeliveryGroupsTest) {
(Invoke-RestMethod "https://api.cloud.com/cvadapis/$siteid/DeliveryGroups" -Headers $headers).items.id | ForEach-Object {Invoke-RestMethod "https://api.cloud.com/cvadapis/$siteid/DeliveryGroups/$_/`$test" -Method Post -Headers $headers -ContentType 'application/json'}
$data += (Invoke-RestMethod "https://api.cloud.com/cvadapis/$siteid/DeliveryGroups" -Headers $headers).items.id | ForEach-Object {(Invoke-RestMethod "https://api.cloud.com/cvadapis/$siteid/DeliveryGroups/$_/TestReport" -Headers $headers).TestResults}
}

if ($MachineCatalogsTest) {
(Invoke-RestMethod "https://api.cloud.com/cvadapis/$siteid/MachineCatalogs" -Headers $headers).items.id | ForEach-Object {Invoke-RestMethod "https://api.cloud.com/cvadapis/$siteid/MachineCatalogs/$_/`$test" -Method Post -Headers $headers -ContentType 'application/json'}
$data +=  (Invoke-RestMethod "https://api.cloud.com/cvadapis/$siteid/MachineCatalogs" -Headers $headers).items.id | ForEach-Object {(Invoke-RestMethod "https://api.cloud.com/cvadapis/$siteid/MachineCatalogs/$_/TestReport" -Headers $headers).TestResults}
}

if ($Export -eq 'Excel') { $data | Export-Excel -Path ($ReportPath + '\Tests-' + (Get-Date -Format yyyy.MM.dd-HH.mm) + '.xlsx') -AutoSize -AutoFilter -Show } 
if ($Export -eq 'HTML')  { $data | Out-GridHtml -DisablePaging -Title 'Citrix Tests' -HideFooter -SearchHighlight -FixedHeader }
if ($Export -eq 'Host')  { $data }


} #end Function
