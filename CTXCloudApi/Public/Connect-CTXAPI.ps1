
<#PSScriptInfo

.VERSION 1.1.8

.GUID 653b6442-7227-4f3f-b3be-5fd6cc7ab527

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
 Connects to Citrix Cloud and creates required API headers. 

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

.EXAMPLE
Read-Host -AsSecureString -Prompt "Enter Citrix API Secret" | Export-Clixml -Path "C:\Temp\CTX_Secret.xml"
$SecureSecret = Import-Clixml -Path "C:\Secure\CTX_Secret.xml"
#>

function Connect-CTXAPI {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Connect-CTXAPI')]
    param(
        [Parameter(Mandatory)]
        [string]$Customer_Id,
        [Parameter(Mandatory)]
        [string]$Client_Id,
        [Parameter(Mandatory)]
        [securestring]$Client_Secret,
        [Parameter(Mandatory)]
        [string]$Customer_Name
    )

    $PlainSecret = [System.Net.NetworkCredential]::new('', $Client_Secret).Password


    $body = @{
        grant_type    = 'client_credentials'
        client_id     = $Client_Id
        client_secret = $PlainSecret
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
