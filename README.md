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
- [Get-CTXAPI_ConfigAudit](https://smitpi.github.io/CTXCloudApi/#Get-CTXAPI_ConfigAudit) -- Reports on system config
- [Get-CTXAPI_ConfigLog](https://smitpi.github.io/CTXCloudApi/#Get-CTXAPI_ConfigLog) -- Get high level configuration changes in the last x days.
- [Get-CTXAPI_ConnectionReport](https://smitpi.github.io/CTXCloudApi/#Get-CTXAPI_ConnectionReport) -- Creates Connection report
- [Get-CTXAPI_FailureReport](https://smitpi.github.io/CTXCloudApi/#Get-CTXAPI_FailureReport) -- Reports on failures in the last x hours.
- [Get-CTXAPI_HealthCheck](https://smitpi.github.io/CTXCloudApi/#Get-CTXAPI_HealthCheck) -- Show useful information for daily health check
- [Get-CTXAPI_MonitorData](https://smitpi.github.io/CTXCloudApi/#Get-CTXAPI_MonitorData) -- Collect Monitoring OData for other reports
- [Get-CTXAPI_ResourceUtilization](https://smitpi.github.io/CTXCloudApi/#Get-CTXAPI_ResourceUtilization) -- Resource utilization in the last x hours
- [Get-CTXAPI_VDAUptime](https://smitpi.github.io/CTXCloudApi/#Get-CTXAPI_VDAUptime) -- Uses Registration date to calculate uptime
- [Get-CTXAPI_Zone](https://smitpi.github.io/CTXCloudApi/#Get-CTXAPI_Zone) -- Get zone details
