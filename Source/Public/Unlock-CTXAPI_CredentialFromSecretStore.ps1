
<#PSScriptInfo

.VERSION 1.0.0

.GUID e68d19a3-3991-42f3-9d86-01f4abe16d65

.AUTHOR  Pierre Smit

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
Created [28/05/2021_15:43] Initital Script Creating

.PRIVATEDATA

#> 



<# 

.DESCRIPTION 
Get api logon details from ms secret store

#> 

Param()


Function Unlock-CTXAPI_CredentialFromSecretStore {
	PARAM(
		[Parameter(Mandatory = $true, Position = 0)]
		[ValidateScript( { (Test-Path $_) -and ((Get-Item $_).name -eq 'CTXAPI.xml') })]
		[string]$FilePath,
		[Parameter(Mandatory = $true, Position = 1)]
		[ValidateNotNull()]
		[ValidateNotNullOrEmpty()]
		[string]$ClientName)

	$password = Import-Clixml -Path $FilePath
	Unlock-SecretStore -Password $password

	$Global:CustomerId = ((Get-SecretInfo -Name $ClientName -Vault CTXAPIStore).Metadata).CustomerId
	$Global:clientid = ((Get-SecretInfo -Name $ClientName -Vault CTXAPIStore).Metadata).clientid
	$Global:ClientName = ((Get-SecretInfo -Name $ClientName -Vault CTXAPIStore).Metadata).ClientName
	$Global:clientsecret = Get-Secret -Name $ClientName -Vault CTXAPIStore -AsPlainText

	Write-Color -Text 'Using the following details' -Color DarkYellow -LinesAfter 1
	Write-Color -Text 'Client Name :', $ClientName -Color Yellow,red
	Write-Color -Text 'CustomerID :', $CustomerId -Color Yellow,Cyan
	Write-Color -Text 'clientid :', $clientid -Color Yellow,Cyan
	Write-Color -Text 'clientsecret :', $clientsecret -Color Yellow,Cyan


} #end Function
