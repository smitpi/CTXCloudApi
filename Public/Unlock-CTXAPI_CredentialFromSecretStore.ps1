
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
		[Parameter(Position = 0)]
		[ValidateScript( { (Test-Path $_) -and ((Get-Item $_).Extension -eq ".xml") })]
		[string]$FilePath = (Get-Item $profile).DirectoryName + "\config\CTXAPI.xml", 
		[Parameter(Mandatory = $true, Position = 1,ParameterSetName = 'client')]
		[ValidateNotNull()]
		[ValidateNotNullOrEmpty()]
		[string]$ClientName,
		[Parameter(Mandatory = $false, Position = 2,ParameterSetName = 'export')]
		[Switch]$Export = $false,
		[Parameter(Mandatory = $false, Position = 3,ParameterSetName = 'export')]
		[ValidateScript( { (Test-Path $_) })]
		[string]$ExportPath = $env:temp)

	$password = Import-Clixml -Path $FilePath
	Unlock-SecretStore -Password $password

	if ($Export -eq $true) {
		$Details = @()
		Get-SecretInfo | ForEach-Object {
			$Details += [PSCustomObject]@{
				ClientName   = $_.Name
				CustomerId   = ((Get-SecretInfo -Name $_.Name -Vault CTXAPIStore).Metadata).CustomerId
				clientid     = ((Get-SecretInfo -Name $_.Name -Vault CTXAPIStore).Metadata).clientid
				clientsecret = Get-Secret -Name $_.Name -Vault CTXAPIStore -AsPlainText
			}
		}
		$Details | Export-Excel -Path ($ExportPath + '\ClienApi-' + (Get-Date -Format yyyy.MM.dd-HH.mm) + '.xlsx') -AutoSize -Show
		$Details
		

	} else {
		$Global:CustomerId = ((Get-SecretInfo -Name $ClientName -Vault CTXAPIStore).Metadata).CustomerId
		$Global:clientid = ((Get-SecretInfo -Name $ClientName -Vault CTXAPIStore).Metadata).clientid
		$Global:ClientName = ((Get-SecretInfo -Name $ClientName -Vault CTXAPIStore).Metadata).ClientName
		$Global:clientsecret = Get-Secret -Name $ClientName -Vault CTXAPIStore -AsPlainText

		Write-Color -Text 'Using the following details' -Color DarkYellow -LinesAfter 1
		Write-Color -Text 'Client Name :', $ClientName -Color Yellow,red
		Write-Color -Text 'CustomerID :', $CustomerId -Color Yellow,Cyan
		Write-Color -Text 'clientid :', $clientid -Color Yellow,Cyan
		Write-Color -Text 'clientsecret :', $clientsecret -Color Yellow,Cyan
	}
} #end Function
