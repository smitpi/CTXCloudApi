# CTXCloudApi

# SYNOPSIS
Wrapper for Citrix Cloud CVAD API. You dont require the installed SDK anymore and manage your clients cloud infrastructure from anywhere. Start with Connect-CTXAPI to connect, then run other reports

# DESCRIPTION
Wrapper for Citrix Cloud CVAD API. You dont require the installed SDK anymore and manage your clients cloud infrastructure from anywhere. Start with Connect-CTXAPI to connect, then run other reports

# FUNCTION SYNOPSIS
## Connect-CTXAPI
Connect to the cloud and create needed api headers
## Get-CTXAPI_Applications
Return details about published apps
## Get-CTXAPI_CloudConnectors
Details about current Cloud Connectors
## Get-CTXAPI_CloudServices
Return details about cloud services and subscription
## Get-CTXAPI_ConfigAudit
Reports on system config
## Get-CTXAPI_ConfigLog
Get high level configuration changes in the last x days.
## Get-CTXAPI_ConnectionReport
Creates Connection report
## Get-CTXAPI_DeliveryGroups
Return details about Delivery Groups
## Get-CTXAPI_FailureReport
Reports on failures in the last x hours.
## Get-CTXAPI_HealthCheck
Show useful information for daily health check
## Get-CTXAPI_Hypervisors
Return details about hosting (hypervisor)
## Get-CTXAPI_LowLevelOperations
Return details about low lever config change (More detailed)
## Get-CTXAPI_MachineCatalogs
Return details about machine catalogs
## Get-CTXAPI_Machines
Return details about vda machines
## Get-CTXAPI_MonitorData
Collect Monitoring OData for other reports
## Get-CTXAPI_ResourceLocations
Get cloud Resource Locations
## Get-CTXAPI_ResourceUtilization
Resource utilization in the last x hours
## Get-CTXAPI_Sessions
Return details about current sessions
## Get-CTXAPI_SiteDetails
Return details about your farm / site
## Get-CTXAPI_Tests
Run Built in Citrix cloud tests
## Get-CTXAPI_VDAUptime
Uses Registration date to calculate uptime
## Get-CTXAPI_Zone
Get zone details


# NOTES
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
## HTML Reports
When creating a HTML report:
- The logo can be changed by replacing the variable 
  - `$Global:Logourl` ='URL to your logo'
- The colors of the report can be changed, by replacing:
  - `$global:colour1` = '# number of color'
  - `$global:colour2` = '# number of color'
- Or permanently replace it by editing the following file
  - `<Module base>\Private\Reports-Variables.ps1`


# SEE ALSO
https://github.com/smitpi/CTXCloudApi

