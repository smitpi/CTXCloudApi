# CTXCloudApi
## Getting Started
- You will need access to the Citrix Cloud API. Follow [Get API Access](https://developer.cloud.com/getting-started/docs/overview) to gain access.
- `Install-Module -Name CTXCloudApi -Verbose`
- `Import-Module CTXCloudApi -Verbose -Force`
- `Get-Command -Module CTXCloudApi`
- Run `Connect-CTXAPI` with the details obtained from above. This connect and create the needed headers for other commands.

## Example 1:

```powershell
$splat = @{
	Customer_Id = "xxx"
	Client_Id = "xxx-xxx-xxx-xxx"
	Client_Secret = "yyyyyy=="
	Customer_Name = 'HomeLab'
}
$APIHeader = Connect-CTXAPI @splat
Get-CTXAPI_HealthCheck -APIHeader $APIHeader -region eu -ReportPath C:\Temp\
```
 
## Functions
- [Connect-CTXAPI](https://smitpi.github.io/CTXCloudApi/#Connect-CTXAPI) -- Connect to the cloud and create needed api headers
- [Get-CTXAPI_Application](https://smitpi.github.io/CTXCloudApi/#Get-CTXAPI_Application) -- Return details about published apps
- [Get-CTXAPI_CloudConnector](https://smitpi.github.io/CTXCloudApi/#Get-CTXAPI_CloudConnector) -- Details about current Cloud Connectors
- [Get-CTXAPI_CloudService](https://smitpi.github.io/CTXCloudApi/#Get-CTXAPI_CloudService) -- Return details about cloud services and subscription
- [Get-CTXAPI_ConfigAudit](https://smitpi.github.io/CTXCloudApi/#Get-CTXAPI_ConfigAudit) -- Reports on system config.
- [Get-CTXAPI_ConfigLog](https://smitpi.github.io/CTXCloudApi/#Get-CTXAPI_ConfigLog) -- Get high level configuration changes in the last x days.
- [Get-CTXAPI_ConnectionReport](https://smitpi.github.io/CTXCloudApi/#Get-CTXAPI_ConnectionReport) -- Creates Connection report
- [Get-CTXAPI_DeliveryGroup](https://smitpi.github.io/CTXCloudApi/#Get-CTXAPI_DeliveryGroup) -- Return details about Delivery Groups
- [Get-CTXAPI_FailureReport](https://smitpi.github.io/CTXCloudApi/#Get-CTXAPI_FailureReport) -- Reports on failures in the last x hours.
- [Get-CTXAPI_HealthCheck](https://smitpi.github.io/CTXCloudApi/#Get-CTXAPI_HealthCheck) -- Show useful information for daily health check
- [Get-CTXAPI_Hypervisor](https://smitpi.github.io/CTXCloudApi/#Get-CTXAPI_Hypervisor) -- Return details about hosting (hypervisor)
- [Get-CTXAPI_LowLevelOperation](https://smitpi.github.io/CTXCloudApi/#Get-CTXAPI_LowLevelOperation) -- Return details about low lever config change (More detailed)
- [Get-CTXAPI_Machine](https://smitpi.github.io/CTXCloudApi/#Get-CTXAPI_Machine) -- Return details about vda machines
- [Get-CTXAPI_MachineCatalog](https://smitpi.github.io/CTXCloudApi/#Get-CTXAPI_MachineCatalog) -- Return details about machine catalogs
- [Get-CTXAPI_MonitorData](https://smitpi.github.io/CTXCloudApi/#Get-CTXAPI_MonitorData) -- Collect Monitoring OData for other reports
- [Get-CTXAPI_ResourceLocation](https://smitpi.github.io/CTXCloudApi/#Get-CTXAPI_ResourceLocation) -- Get cloud Resource Locations
- [Get-CTXAPI_ResourceUtilization](https://smitpi.github.io/CTXCloudApi/#Get-CTXAPI_ResourceUtilization) -- Resource utilization in the last x hours
- [Get-CTXAPI_Session](https://smitpi.github.io/CTXCloudApi/#Get-CTXAPI_Session) -- Return details about current sessions
- [Get-CTXAPI_SiteDetail](https://smitpi.github.io/CTXCloudApi/#Get-CTXAPI_SiteDetail) -- Return details about your farm / site
- [Get-CTXAPI_Test](https://smitpi.github.io/CTXCloudApi/#Get-CTXAPI_Test) -- Run Built in Citrix cloud tests
- [Get-CTXAPI_VDAUptime](https://smitpi.github.io/CTXCloudApi/#Get-CTXAPI_VDAUptime) -- Uses Registration date to calculate uptime
- [Get-CTXAPI_Zone](https://smitpi.github.io/CTXCloudApi/#Get-CTXAPI_Zone) -- Get zone details
- [Set-CTXAPI_ReportColour](https://smitpi.github.io/CTXCloudApi/#Set-CTXAPI_ReportColour) -- Set the colour and logo for HTML Reports
- [Test-CTXAPI_Header](https://smitpi.github.io/CTXCloudApi/#Test-CTXAPI_Header) -- Checks that the connection is still valid, and the token hasn't expired.
