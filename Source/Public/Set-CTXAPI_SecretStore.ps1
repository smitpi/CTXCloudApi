
<#PSScriptInfo

.VERSION 1.0.0

.GUID cdfb5404-4936-4c04-95f1-dec99294d7b3

.AUTHOR Pierre Smit

.COMPANYNAME iOCO Tech

.COPYRIGHT

.TAGS CTX

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Created [24/04/2021_07:26] Initital Script Creating

.PRIVATEDATA

#>

<# 

.DESCRIPTION 
 Integrates module with a local ms secret store 

#> 

Param()

Function Set-CTXAPI_SecretStore {
	PARAM(
		[Parameter(Mandatory = $true, Position = 0)]
		[ValidateScript( { (Test-Path $_) })]
		[string]$FilePath)

	$module = Get-Module -Name Microsoft.PowerShell.SecretManagement -ListAvailable | Select-Object -First 1
	if ([bool]$module -eq $false) {
		Write-Color -Text 'Installing module: ','SecretManagement' -Color yellow,green
		Install-Module Microsoft.PowerShell.SecretManagement, Microsoft.PowerShell.SecretStore -AllowClobber -Scope CurrentUser
	} else {
		Write-Color -Text 'Using installed module path: ',$module.ModuleBase -Color yellow,green
	}

	$vault = Get-SecretVault -Name CTXAPIStore -ErrorAction SilentlyContinue
	if ([bool]$vault -eq $false) {
		Register-SecretVault -Name CTXAPIStore -ModuleName Microsoft.PowerShell.SecretStore
		$Password = Read-Host 'Password ' -AsSecureString
		$Password | Export-Clixml -Path "$FilePath\CTXAPI.xml" -Depth 3 -Force	
		Write-Host "Password file $FilePath\CTXAPI.xml created "
		try {
			Set-SecretStoreConfiguration -Scope CurrentUser -Authentication Password -PasswordTimeout 3600 -Interaction None -Confirm:$false
		} catch { Set-SecretStorePassword -Password $Password -NewPassword $Password
			Write-Warning 'SecretStoreConfiguration already set' }
	}
	$password = Import-Clixml -Path "$FilePath\CTXAPI.xml"
	Unlock-SecretStore -Password $password

	$ClientName = Read-Host 'Client Name '
	$CustomerId = Read-Host 'CustomerId '	 
	$clientid = Read-Host 'clientid '
	$clientsecret = Read-Host 'clientsecret '

	$data = @{
		ClientName = $ClientName.ToString()
		CustomerId = $CustomerId.ToString()
		clientid   = $clientid.ToString()	
	}

	
	Set-Secret -Name $ClientName -Secret $clientsecret -Metadata $data -Vault CTXAPIStore

} #end Function
