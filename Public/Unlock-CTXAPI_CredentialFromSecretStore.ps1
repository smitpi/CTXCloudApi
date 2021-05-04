
<#PSScriptInfo

.VERSION 1.0.0

.GUID d2e6e808-e5fc-45d6-942d-3df754591008

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
Created [24/04/2021_08:30] Initital Script Creating

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
		[string]$PasswordFilePath,
		[Parameter(Mandatory = $true, Position = 1)]
		[ValidateNotNull()]
		[ValidateNotNullOrEmpty()]
		[string]$CustomerId)

	$password = Import-Clixml -Path $PasswordFilePath
	Unlock-SecretStore -Password $password

	$Global:CustomerId = $CustomerId
	$Global:clientid = ((Get-SecretInfo -Name $CustomerId -Vault CTXAPIStore).Metadata).clientid
	$Global:clientsecret = Get-Secret -Name $CustomerId -Vault CTXAPIStore -AsPlainText

	Write-Color -Text "Using the following details" -Color DarkYellow -LinesAfter 1
    Write-Color -Text "CustomerID :", $CustomerId -Color Yellow,Cyan
    Write-Color -Text "clientid :", $clientid -Color Yellow,Cyan
    Write-Color -Text "clientsecret :", $clientsecret -Color Yellow,Cyan


} #end Function
