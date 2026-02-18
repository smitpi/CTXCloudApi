# CTXCloudApi
 
## Description
A wrapper for Citrix Cloud CVAD API. You do not require the installed SDK anymore. With this module you can manage your clients cloud infrastructure from anywhere. Start with the Connect-CTXAPI function to connect, it will create the needed headers for the other functions.
 
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
 
## PS Controller Scripts
- .git
- .github
- .vscode
- CTXCloudApi
- docs
- Output
- Removed
- .whitesource
- instructions.md
- LICENSE
 
## Functions
- [`Connect-CTXAPI`](https://smitpi.github.io/CTXCloudApi/Connect-CTXAPI) -- Connects to Citrix Cloud and creates required API headers.
- [`Get-CTXAPI_Application`](https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Application) -- Returns details about published applications (handles pagination).
- [`Get-CTXAPI_CloudService`](https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_CloudService) -- Returns details about cloud services and subscription.
- [`Get-CTXAPI_ConfigAudit`](https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_ConfigAudit) -- Reports on system config.
- [`Get-CTXAPI_ConfigLog`](https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_ConfigLog) -- Returns high-level configuration changes in the last X days.
- [`Get-CTXAPI_ConnectionReport`](https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_ConnectionReport) -- Creates a connection report from CVAD Monitor data.
- [`Get-CTXAPI_DeliveryGroup`](https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_DeliveryGroup) -- Returns details about Delivery Groups (handles pagination).
- [`Get-CTXAPI_FailureReport`](https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_FailureReport) -- Reports on connection or machine failures in the last X hours.
- [`Get-CTXAPI_Hypervisor`](https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Hypervisor) -- Returns details about hosting (hypervisor) connections (handles pagination).
- [`Get-CTXAPI_LowLevelOperation`](https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_LowLevelOperation) -- Returns details about low-level configuration changes (more detailed).
- [`Get-CTXAPI_Machine`](https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Machine) -- Returns details about VDA machines (handles pagination).
- [`Get-CTXAPI_MachineCatalog`](https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_MachineCatalog) -- Returns details about Machine Catalogs (handles pagination).
- [`Get-CTXAPI_MonitorData`](https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_MonitorData) -- Collect Monitoring OData for other reports.
- [`Get-CTXAPI_ResourceLocation`](https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_ResourceLocation) -- Returns cloud Resource Locations.
- [`Get-CTXAPI_ResourceUtilization`](https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_ResourceUtilization) -- Resource utilization in the last X hours.
- [`Get-CTXAPI_Session`](https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Session) -- Returns details about current sessions (handles pagination).
- [`Get-CTXAPI_SiteDetail`](https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_SiteDetail) -- Returns details about your CVAD site.
- [`Get-CTXAPI_VDAUptime`](https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_VDAUptime) -- Calculate VDA uptime and export or return results.
- [`Get-CTXAPI_Zone`](https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Zone) -- Returns Zone details (handles pagination).
- [`Test-CTXAPI_Header`](https://smitpi.github.io/CTXCloudApi/Test-CTXAPI_Header) -- Checks that the connection is still valid, and the token hasn't expired.
