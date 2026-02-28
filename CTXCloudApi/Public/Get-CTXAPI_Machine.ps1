
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

.PARAMETER Name
The machine name, DNS name, or ID to retrieve from the CVAD Manage API.

.PARAMETER InputObject
When piping machine objects into this function (for example, output from Set-CTXAPI_MachineMaintenanceMode), the objects are passed through unchanged.



.EXAMPLE
$machines = Get-CTXAPI_Machine -APIHeader $APIHeader
Retrieves all machines and stores them for reuse.

.EXAMPLE
Get-CTXAPI_Machine -APIHeader $APIHeader | Select-Object DnsName, IPAddress, OSType, RegistrationState
Lists key machine fields for quick inspection.

.EXAMPLE
Set-CTXAPI_MachineMaintenanceMode -APIHeader $APIHeader -Name "CTX-Machine01" -InMaintenanceMode $false |
    Get-CTXAPI_Machine
Passes through the updated machine object returned by Set-CTXAPI_MachineMaintenanceMode.

.INPUTS
System.Object. You can pipe machine objects to Get-CTXAPI_Machine and it will pass them through unchanged.

.OUTPUTS
PSCustomObject[]
Array of machine objects returned from the CVAD Manage API.

.LINK
https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Machine

#>

function Get-CTXAPI_Machine {
    [Cmdletbinding(DefaultParameterSetName = 'PassThru', HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Machine')]
    [Alias('Get-CTXAPI_Machines')]
    [OutputType([psobject[]])]
    param(
        [Parameter(Mandatory, ParameterSetName = 'ApiAll')]
        [Parameter(Mandatory, ParameterSetName = 'ApiByName')]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader,
        
        [Parameter(Mandatory, ParameterSetName = 'ApiByName')]
        [Alias('DNSName', 'Id')]
        [string[]]$Name,

        [Parameter(ValueFromPipeline, ParameterSetName = 'PassThru')]
        [psobject]$InputObject
    )

    begin {
        $results = [System.Collections.Generic.List[psobject]]::new()

        if ($PSCmdlet.ParameterSetName -eq 'PassThru' -and -not $PSCmdlet.MyInvocation.ExpectingInput) {
            throw "Get-CTXAPI_Machine: -APIHeader is required to query the CTX API. Use 'Get-CTXAPI_Machine -APIHeader <header>' (optionally with -Name), or pipe machine objects into Get-CTXAPI_Machine to pass them through."
        }

        if ($PSCmdlet.ParameterSetName -in @('ApiAll', 'ApiByName')) {
            if (-not (Test-CTXAPI_Header -APIHeader $APIHeader)) {
                Test-CTXAPI_Header -APIHeader $APIHeader -AutoRenew | Out-Null
            } else {
                Write-Verbose "[$(Get-Date -Format HH:mm:ss) APIHEADER] Header still valid"
            }
        }
    }

    process {
        switch ($PSCmdlet.ParameterSetName) {
            'PassThru' {
                # Common pattern: Set-* cmdlets already return machine objects; allow pass-through.
                Write-Output $InputObject
            }

            'ApiAll' {
                if ($PSCmdlet.MyInvocation.ExpectingInput) {
                    throw 'Get-CTXAPI_Machine: Pipeline input was provided, but no -Name filter is available in this parameter set. Use -APIHeader with -Name, or omit pipeline input.'
                }
            }

            'ApiByName' {
                foreach ($n in $Name) {
                    if ([string]::IsNullOrWhiteSpace($n)) {
                        continue
                    }

                    $nameRequestUri = [string]::Format('https://api.cloud.com/cvad/manage/Machines/{0}', $n)
                    try {
                        Write-Verbose "Retrieving machine details for: $n"
                        $nameResponse = Invoke-RestMethod -Uri $nameRequestUri -Method GET -Headers $APIHeader.headers
                        $results.Add($nameResponse)
                    } catch {
                        Write-Warning "Failed to retrieve machine details for: $n."
                    }
                }
            }
        }
    }

    end {
        switch ($PSCmdlet.ParameterSetName) {
            'ApiByName' {
                return $results
            }

            'ApiAll' {
                Write-Verbose 'No Name filter applied; retrieving all machines.'
                $requestUri = 'https://api.cloud.com/cvad/manage/Machines?limit=1000'
                return (Get-CTXAPIDatapages -APIHeader $APIHeader -uri $requestUri)
            }

            default {
                # PassThru writes output in process.
            }
        }
    }
} #end Function
