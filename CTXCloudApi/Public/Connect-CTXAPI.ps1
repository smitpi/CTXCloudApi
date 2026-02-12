
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
Connect to the cloud and create needed api headers

.DESCRIPTION
Connect to the cloud and create needed api headers

.PARAMETER Customer_Id
From Citrix Cloud

.PARAMETER Client_Id
From Citrix Cloud

.PARAMETER Client_Secret
From Citrix Cloud

.PARAMETER Customer_Name
Name of your Company, or what you want to call your connection

.EXAMPLE
$splat = @{
	Customer_Id = "xxx"
	Client_Id = "xxx-xxx-xxx-xxx"
	Client_Secret = "yyyyyy=="
	Customer_Name = 'HomeLab'
}
$APIHeader = Connect-CTXAPI @splat

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


#     function Get-BearerToken {
#         ## https://developer.cloud.com/citrix-cloud/citrix-cloud-api-overview/docs/get-started-with-citrix-cloud-apis#bearer_token_tab_oauth_2.0_flow
#         param (
#             [Parameter(Mandatory = $true)][string]
#             $Client_Id,
#             [Parameter(Mandatory = $true)][string]
#             $Client_Secret
#         )
#         [string]$bearerToken = $null
#         [hashtable]$body = @{
#             'grant_type'    = 'client_credentials'
#             'client_id'     = $Client_Id
#             'client_secret' = $Client_Secret
#         }
    
#         $response = $null
#         try {
#             $startRequestTime = [datetime]::Now
#             Write-Verbose -Message "$($startRequestTime.ToString('G')): sending auth request"
#             $response = Invoke-RestMethod -Uri 'https://api.cloud.com/cctrustoauth2/root/tokens/clients' -Method POST -Body $body
#             $endRequestTime = [datetime]::Now
#         } catch {
#             $endRequestTime = [datetime]::Now
#             throw $_
#         }

#         if ( $null -ne $response ) {
#             $bearerToken = "CwsAuth Bearer=$($response | Select-Object -ExpandProperty access_token)"
#             Write-Verbose -Message "$($startRequestTime.ToString('G')): auth seems ok"
#         }
#         ## else will have output error
#         $bearerToken ## return    
#     }


#     [hashtable]$params = @{}

#     if ( -not $PSBoundParameters[ 'authtoken' ] ) {
#         if ( -not [string]::IsNullOrEmpty( $Client_Id ) ) {
#             ## don't use Remote PS SDK or use -Client_Id and -clientSecret
#             $authtoken = Get-BearerToken -Client_Id $Client_Id -Client_Secret $Client_Secret
#         } else {
#             throw 'Please specify -Client_Id and -Client_Secret'
#         }
#         if ( -not $? -or [string]::IsNullOrEmpty( $authtoken ) ) {
#             throw "Failed to get authentication token for customer id $Customer_Id"
#         }
#     }
#     $params.Add( 'Headers' , @{ 'Citrix-CustomerId' = $Customer_Id ; 'Authorization' = $authtoken ; 'Accept-Encoding' = 'gzip' ; 'User-Agent' = 'Powershell-Citrix-Monitor' } )
#     return $params
# }