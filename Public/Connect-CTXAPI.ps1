
<#PSScriptInfo

.VERSION 0.1.1

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
Updated [03/11/2021_19:17] Info Upate

.PRIVATEDATA

#> 



<#

.DESCRIPTION 
Connect to the cloud and create needed api headers

#>


Function Connect-CTXAPI {
<#
.SYNOPSIS
Connect to the cloud and create needed api headers

.DESCRIPTION
Connect to the cloud and create needed api headers

.PARAMETER Customer_Id
From Citrix Cloud

.PARAMETER client_id
From Citrix Cloud

.PARAMETER client_secret
From Citrix Cloud

.PARAMETER CustomerName
From Citrix Cloud

.EXAMPLE
Connect-CTXAPI
#>
	[Cmdletbinding()]
	PARAM(
		[Parameter(Mandatory = $true)]
		[string]$Customer_Id,
		[Parameter(Mandatory = $true)]
		[string]$client_id,
		[Parameter(Mandatory = $true)]
		[string]$client_secret,
		[Parameter(Mandatory = $true)]
		[string]$CustomerName
	)

	$body = @{
		grant_type    = 'client_credentials'
		client_id     = $client_id
		client_secret = $client_secret
	}

	$headers = @{
		Authorization       = "CwsAuth Bearer=$((Invoke-RestMethod -Method Post -Uri 'https://api-us.cloud.com/cctrustoauth2/root/tokens/clients' -Body $body).access_token)"
		'Citrix-CustomerId' = $Customer_Id
		Accept              = 'application/json'
	}
	$headers.Add('Citrix-InstanceId', (Invoke-RestMethod 'https://api-us.cloud.com/cvadapis/me' -Headers $headers).customers.sites.id)

	$myObject = [PSCustomObject]@{
		PSTypeName   = 'CTXAPIHeaderObject'
		CustomerName = $CustomerName
		headers      = $headers
	}
	$myObject
} #end Function
