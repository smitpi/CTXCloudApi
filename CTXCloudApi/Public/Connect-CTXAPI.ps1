
<#PSScriptInfo

.VERSION 0.1.3

.GUID f17c5fba-37fb-4230-a529-812470428a3a

.AUTHOR Pierre Smit

.COMPANYNAME HTPCZA Tech

.COPYRIGHT

.TAGS ctx ps

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Created [27/10/2021_12:52] Initial Script Creating
Updated [03/11/2021_19:17] Info Update
Updated [06/11/2021_16:48] Using the new api
Updated [14/11/2021_07:05] Added more functions

.PRIVATEDATA

#>







<#

.DESCRIPTION
Connect to the cloud and create needed api headers

#>

<#
.SYNOPSIS
Connects to Citrix Cloud and creates required API headers.

.DESCRIPTION
Authenticates against Citrix Cloud using `Client_Id` and `Client_Secret`, resolves the CVAD `Citrix-InstanceId`, and constructs headers for subsequent CTXCloudApi requests. Returns a `CTXAPIHeaderObject` containing `CustomerName`, `TokenExpireAt` (about 1 hour), `CTXAPI` (ids), and `headers`.

.PARAMETER Customer_Id
Citrix Customer ID (GUID) from the Citrix Cloud console.

.PARAMETER Client_Id
OAuth Client ID created under Citrix Cloud API access.

.PARAMETER Client_Secret
OAuth Client Secret for the above Client ID.

.PARAMETER Customer_Name
Display name used in reports/filenames to identify this connection.

.EXAMPLE
$splat = @{
	Customer_Id = "xxx"
	Client_Id = "xxx-xxx-xxx-xxx"
	Client_Secret = "yyyyyy=="
	Customer_Name = 'HomeLab'
}
$APIHeader = Connect-CTXAPI @splat

.EXAMPLE
Connect-CTXAPI -Customer_Id "xxx" -Client_Id "xxx-xxx" -Client_Secret "yyyyyy==" -Customer_Name "Prod"
Creates and returns a `CTXAPIHeaderObject`. Store it in a variable (e.g., `$APIHeader`) and pass to other cmdlets.

.INPUTS
None. Parameters are not accepted from the pipeline.

.OUTPUTS
CTXAPIHeaderObject. Contains authentication headers and context for CTXCloudApi cmdlets.

.LINK
https://smitpi.github.io/CTXCloudApi/Connect-CTXAPI

.NOTES
The access token typically expires in ~1 hour. Re-run Connect-CTXAPI to refresh headers when needed.

#>

function Connect-CTXAPI {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Connect-CTXAPI')]
    param(
        [Parameter(Mandatory)]
        [string]$Customer_Id,
        [Parameter(Mandatory)]
        [string]$Client_Id,
        [Parameter(Mandatory)]
        [string]$Client_Secret,
        [Parameter(Mandatory)]
        [string]$Customer_Name
    )

    $body = @{
        grant_type    = 'client_credentials'
        client_id     = $Client_Id
        client_secret = $Client_Secret
    }

    $headers = @{
        Authorization       = "CwsAuth Bearer=$((Invoke-RestMethod -Method Post -Uri 'https://api.cloud.com/cctrustoauth2/root/tokens/clients' -Body $body).access_token)"
        'Citrix-CustomerId' = $Customer_Id
        Accept              = 'application/json'
    }
    $headers.Add('Citrix-InstanceId', (Invoke-RestMethod 'https://api.cloud.com/cvadapis/me' -Headers $headers).customers.sites.id)
    $headers.Add('User-Agent', 'Powershell-Citrix-Monitor')
    $headers.Add('Accept-Encoding', 'gzip')
    $headers.Add('Content-Type', 'application/json')

    $CTXApi = @()
    $CTXApi = [PSCustomObject]@{
        Customer_Id   = $Customer_Id
        Client_Id     = $Client_Id
        Client_Secret = $Client_Secret
    }

    $myObject = [PSCustomObject]@{
        PSTypeName    = 'CTXAPIHeaderObject'
        CustomerName  = $Customer_Name
        TokenExpireAt = Get-Date (Get-Date).AddHours(1)
        CTXAPI        = $CTXApi
        headers       = $headers
    }
    $myObject
} #end Function
