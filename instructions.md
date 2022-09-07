# CTXCloudApi
 
## Description
A wrapper for Citrix Cloud CVAD API. You do not require the installed SDK anymore. With this module you can manage your clients cloud infrastructure from anywhere. Start with the Connect-CTXAPI function to connect, it will create the needed headers for the other functions.
 
## Getting Started
- Install from PowerShell Gallery [PS Gallery](https://www.powershellgallery.com/packages/CTXCloudApi)
```
Install-Module -Name CTXCloudApi -Verbose
```
- or from GitHub [GitHub Repo](https://github.com/smitpi/CTXCloudApi)
```
git clone https://github.com/smitpi/CTXCloudApi (Join-Path (get-item (Join-Path (Get-Item $profile).Directory 'Modules')).FullName -ChildPath CTXCloudApi)
```
- Then import the module into your session
```
Import-Module CTXCloudApi -Verbose -Force
```
- or run these commands for more help and details.
```
Get-Command -Module CTXCloudApi
Get-Help about_CTXCloudApi
```
Documentation can be found at: [Github_Pages](https://smitpi.github.io/CTXCloudApi)
