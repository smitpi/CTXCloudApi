
<#PSScriptInfo

.VERSION 1.1.8

.GUID f551ba3e-e77c-458c-861c-779150316116

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
 Returns details about VDA machines (handles pagination). 

#> 



<#
.SYNOPSIS
Returns details about VDA machines (handles pagination).

.DESCRIPTION
Returns details about VDA machines from Citrix Cloud CVAD.

.PARAMETER APIHeader
Header object created by Connect-CTXAPI; contains authentication and request headers.



.EXAMPLE
$machines = Get-CTXAPI_Machine -APIHeader $APIHeader
Retrieves all machines and stores them for reuse.

.EXAMPLE
Get-CTXAPI_Machine -APIHeader $APIHeader | Select-Object DnsName, IPAddress, OSType, RegistrationState
Lists key machine fields for quick inspection.

.INPUTS
None. Parameters are not accepted from the pipeline.

.OUTPUTS
PSCustomObject[]
Array of machine objects returned from the CVAD Manage API.

.LINK
https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Machine

#>

function Get-CTXAPI_Machine {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Machine')]
    [Alias('Get-CTXAPI_Machines')]
    [OutputType([psobject[]])]
    param(
        [Parameter(Mandatory = $true)]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader,
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('DNSName', 'Id')]
        [string[]]$Name
    )
    if (-not(Test-CTXAPI_Header -APIHeader $APIHeader)) {Test-CTXAPI_Header -APIHeader $APIHeader -AutoRenew}
    else {	Write-Verbose "[$(Get-Date -Format HH:mm:ss) APIHEADER] Header still valid"}

    if ($PSBoundParameters.ContainsKey('Name')) {
        [System.Collections.generic.List[PSObject]]$MachineObject = @()
        $name | ForEach-Object {
            $NamerequestUri = [string]::Format('https://api.cloud.com/cvad/manage/Machines/{0}', $_)
            try {
                Write-Verbose "Retrieving machine details for: $_"
                $Nameresponse = Invoke-RestMethod -Uri $NamerequestUri -Method GET -Headers $APIHeader.headers
                $MachineObject.Add($Nameresponse)
            } catch {
                Write-Warning "Failed to retrieve machine details for: $_."
            }            
        }
        return $MachineObject
    } else {
        Write-Verbose 'No Name filter applied; retrieving all machines.'
    
        $requestUri = 'https://api.cloud.com/cvad/manage/Machines?limit=1000'
        $data = Get-CTXAPIDatapages -APIHeader $apiHeader -uri $requestUri
        return $data

    }
} #end Function
