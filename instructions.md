# CTXCloudApi
 
## Description
CTXCloudApi is a PowerShell module for Citrix DaaS (CVAD) Manage & Monitor OData APIs. It eliminates the need for the Citrix SDK and provides a single, secure connection via `Connect-CTXAPI`, after which you can manage and query applications, delivery groups, machine catalogs, hypervisors, sessions, and monitoring data across Citrix Cloud tenants. The module includes robust reporting and export options (Excel/HTML) to support inventory, uptime, failures, utilization, and configuration audits.
## Getting Started
- Install from PowerShell Gallery [PS Gallery](https://www.powershellgallery.com/packages/CTXCloudApi)
```
Install-Module -Name CTXCloudApi -Verbose
```
- or run this script to install from GitHub [GitHub Repo](https://github.com/smitpi/CTXCloudApi)
```
$CurrentLocation = Get-Item .
$ModuleDestination = (Join-Path (Get-Item (Join-Path (Get-Item $profile).Directory 'Modules')).FullName -ChildPath CTXCloudApi)
git clone --depth 1 https://github.com/smitpi/CTXCloudApi $ModuleDestination 2>&1 | Write-Host -ForegroundColor Yellow
Set-Location $ModuleDestination
git filter-branch --prune-empty --subdirectory-filter Output HEAD 2>&1 | Write-Host -ForegroundColor Yellow
Set-Location $CurrentLocation
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
