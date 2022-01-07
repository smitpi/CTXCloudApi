
<#PSScriptInfo

.VERSION 0.1.3

.GUID f17c5fba-37fb-4230-a529-812470428a3a

.AUTHOR Pierre Smit

.COMPANYNAME iOCO Tech

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

Function Connect-CTXAPI {
    [Cmdletbinding()]
    PARAM(
        [Parameter(Mandatory = $true)]
        [string]$Customer_Id,
        [Parameter(Mandatory = $true)]
        [string]$Client_Id,
        [Parameter(Mandatory = $true)]
        [string]$Client_Secret,
        [Parameter(Mandatory = $true)]
        [string]$Customer_Name
    )

    $body = @{
        grant_type    = 'client_credentials'
        client_id     = $Client_Id
        client_secret = $Client_Secret
    }

    $headers = @{
        Authorization       = "CwsAuth Bearer=$((Invoke-RestMethod -Method Post -Uri 'https://api-us.cloud.com/cctrustoauth2/root/tokens/clients' -Body $body).access_token)"
        'Citrix-CustomerId' = $Customer_Id
        Accept              = 'application/json'
    }
    $headers.Add('Citrix-InstanceId', (Invoke-RestMethod 'https://api-us.cloud.com/cvadapis/me' -Headers $headers).customers.sites.id)

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
