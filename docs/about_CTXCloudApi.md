# CTXCloudApi
## about_CTXCloudApi

# SHORT DESCRIPTION
Wrapper for Citrix Cloud CVAD API. You dont require the installed SDK anymore and manage your clients cloud infrastructure from anywhere. Start with Connect-CTXAPI to connect, then run other reports

# LONG DESCRIPTION
Wrapper for Citrix Cloud CVAD API. You dont require the installed SDK anymore and manage your clients cloud infrastructure from anywhere. Start with Connect-CTXAPI to connect, then run other reports
 
Connect-CTXAPI - Connect to the cloud and create needed api headers
Get-CTXAPI_Applications - Return details about published apps
Get-CTXAPI_CloudConnectors - Details about current Cloud Connectors
Get-CTXAPI_CloudServices - Return details about cloud services and subscription
Get-CTXAPI_ConfigAudit - Reports on system config
Get-CTXAPI_ConfigLog - Get high level configuration changes in the last x days.
Get-CTXAPI_ConnectionReport - Creates Connection report
Get-CTXAPI_DeliveryGroups - Return details about Delivery Groups
Get-CTXAPI_FailureReport - Reports on failures in the last x hours.
Get-CTXAPI_HealthCheck - Show useful information for daily health check
Get-CTXAPI_Hypervisors - Return details about hosting (hypervisor)
Get-CTXAPI_LowLevelOperations - Return details about low lever config change (More detailed)
Get-CTXAPI_MachineCatalogs - Return details about machine catalogs
Get-CTXAPI_Machines - Return details about vda machines
Get-CTXAPI_MonitorData - Collect Monitoring OData for other reports
Get-CTXAPI_ResourceLocations - Get cloud Resource Locations
Get-CTXAPI_ResourceUtilization - Resource utilization in the last x hours
Get-CTXAPI_Sessions - Return details about current sessions
Get-CTXAPI_SiteDetails - Return details about your farm / site
Get-CTXAPI_Tests - Run Built in Citrix cloud tests
Get-CTXAPI_VDAUptime - Uses Registration date to calculate uptime
Get-CTXAPI_Zone - Get zone details


# EXAMPLES

-------------------------- EXAMPLE 1 --------------------------

PS C:\>$splat = @{

Customer_Id = "xxx"
	Client_Id = "xxx-xxx-xxx-xxx"
	Client_Secret = "yyyyyy=="
	Customer_Name = 'HomeLab'
}
$APIHeader = Connect-CTXAPI @splat





-------------------------- EXAMPLE 1 --------------------------

PS C:\>Get-CTXAPI_Applications -APIHeader $APIHeader







-------------------------- EXAMPLE 1 --------------------------

PS C:\>Get-CTXAPI_CloudConnectors -APIHeader $APIHeader







-------------------------- EXAMPLE 1 --------------------------

PS C:\>Get-CTXAPI_CloudServices -APIHeader $APIHeader







-------------------------- EXAMPLE 1 --------------------------

PS C:\>Get-CTXAPI_ConfigAudit -APIHeader $APIHeader -Export Excel -ReportPath C:\Temp







-------------------------- EXAMPLE 1 --------------------------

PS C:\>Get-CTXAPI_ConfigLog -APIHeader $APIHeader -Days 15







-------------------------- EXAMPLE 1 --------------------------

PS C:\>Get-CTXAPI_ConnectionReport -MonitorData $MonitorData -Export HTML -ReportPath c:\temp







-------------------------- EXAMPLE 1 --------------------------

PS C:\>Get-CTXAPI_DeliveryGroup -APIHeader $APIHeader







-------------------------- EXAMPLE 1 --------------------------

PS C:\>Get-CTXAPI_FailureReport -MonitorData $MonitorData -FailureType Connection







-------------------------- EXAMPLE 1 --------------------------

PS C:\>Get-CTXAPI_HealthCheck -APIHeader $APIHeader -region eu -ReportPath C:\Temp







-------------------------- EXAMPLE 1 --------------------------

PS C:\>Get-CTXAPI_Hypervisor -APIHeader $APIHeader







-------------------------- EXAMPLE 1 --------------------------

PS C:\>$ConfigLog = Get-CTXAPI_ConfigLog -APIHeader $APIHeader -Days 7

$LowLevelOperations = Get-CTXAPI_LowLevelOperations -APIHeader $APIHeader -HighLevelID $ConfigLog[0].id





-------------------------- EXAMPLE 1 --------------------------

PS C:\>$MachineCatalogs = Get-CTXAPI_MachineCatalogs -APIHeader $APIHeader







-------------------------- EXAMPLE 1 --------------------------

PS C:\>$machines = Get-CTXAPI_Machines -APIHeader $APIHeader







-------------------------- EXAMPLE 1 --------------------------

PS C:\>$MonitorData = Get-CTXAPI_MonitorData -APIHeader $APIHeader -region eu -hours 24







-------------------------- EXAMPLE 1 --------------------------

PS C:\>Get-CTXAPI_ResourceLocation -APIHeader $APIHeader







-------------------------- EXAMPLE 1 --------------------------

PS C:\>Get-CTXAPI_ResourceUtilization -MonitorData $MonitorData -Export excel -ReportPath C:\temp\







-------------------------- EXAMPLE 1 --------------------------

PS C:\>Get-CTXAPI_Session -APIHeader $APIHeader







-------------------------- EXAMPLE 1 --------------------------

PS C:\>Get-CTXAPI_SiteDetail -APIHeader $APIHeader







-------------------------- EXAMPLE 1 --------------------------

PS C:\>Get-CTXAPI_Tests -APIHeader $APIHeader -SiteTest -HypervisorsTest -DeliveryGroupsTest -MachineCatalogsTest -Export HTML -ReportPath C:\temp







-------------------------- EXAMPLE 1 --------------------------

PS C:\>Get-CTXAPI_VDAUptime -APIHeader $APIHeader -Export excel -ReportPath C:\temp\







-------------------------- EXAMPLE 1 --------------------------

PS C:\>Get-CTXAPI_Zone -APIHeader $APIHeader











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


# SEE ALSO
https://github.com/smitpi/CTXCloudApi

