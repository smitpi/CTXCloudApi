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
 
## PS Controller Scripts
 
## Functions
- [`Connect-CTXAPI`](https://smitpi.github.io/CTXCloudApi/Connect-CTXAPI) -- Connects to Citrix Cloud and creates required API headers.
- [`Get-CTXAPI_Application`](https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Application) -- Returns details about published applications (handles pagination).
- [`Get-CTXAPI_CloudService`](https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_CloudService) -- Returns details about cloud services and subscription.
- [`Get-CTXAPI_ConfigLog`](https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_ConfigLog) -- Returns high-level configuration changes in the last X days.
- [`Get-CTXAPI_DeliveryGroup`](https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_DeliveryGroup) -- Returns details about Delivery Groups (handles pagination).
- [`Get-CTXAPI_Hypervisor`](https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Hypervisor) -- Returns details about hosting (hypervisor) connections (handles pagination).
- [`Get-CTXAPI_LowLevelOperation`](https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_LowLevelOperation) -- Returns details about low-level configuration changes (more detailed).
- [`Get-CTXAPI_Machine`](https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Machine) -- Returns details about VDA machines (handles pagination).
- [`Get-CTXAPI_MachineCatalog`](https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_MachineCatalog) -- Returns details about Machine Catalogs (handles pagination).
- [`Get-CTXAPI_MonitorData`](https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_MonitorData) -- Collect Monitoring OData for other reports.
- [`Get-CTXAPI_ResourceLocation`](https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_ResourceLocation) -- Returns cloud Resource Locations.
- [`Get-CTXAPI_Session`](https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Session) -- Returns details about current sessions (handles pagination).
- [`Get-CTXAPI_SiteDetail`](https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_SiteDetail) -- Returns details about your CVAD site.
- [`Get-CTXAPI_VDAUptime`](https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_VDAUptime) -- 
Get-CTXAPI_VDAUptime [-APIHeader] <CTXAPIHeaderObject> [[-Export] <string>] [[-ReportPath] <DirectoryInfo>] [<CommonParameters>]

- [`Get-CTXAPI_Zone`](https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Zone) -- Returns Zone details (handles pagination).
- [`New-CTXAPI_Machine`](https://smitpi.github.io/CTXCloudApi/New-CTXAPI_Machine) -- Creates and adds new machines to a Citrix Cloud Delivery Group.
- [`New-CTXAPI_Report`](https://smitpi.github.io/CTXCloudApi/New-CTXAPI_Report) -- Generate Citrix Cloud monitoring reports in multiple formats (Host, Excel, HTML).
- [`Set-CTXAPI_MachineMaintenanceMode`](https://smitpi.github.io/CTXCloudApi/Set-CTXAPI_MachineMaintenanceMode) -- Enables or disables Maintenance Mode for Citrix machines via CTX API, with an optional reason.
- [`Set-CTXAPI_MachinePowerState`](https://smitpi.github.io/CTXCloudApi/Set-CTXAPI_MachinePowerState) -- Starts, shuts down, restarts, or logs off Citrix machines via CTX API.
