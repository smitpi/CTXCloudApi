## Description
Wrapper for Citrix Cloud CVAD API. You dont require the installed SDK anymore and manage your clients cloud infrastructure from anywhere. 
    Start with Connect-CTXAPI to connect, then run other reports.
    Or run Get-Help CTXCloudApi for other instructions

## Getting Started
- `Install-Module -Name CTXCloudApi -Verbose`
- `Import-Module CTXCloudApi -Verbose -Force`
- `Get-Command -Module CTXCloudApi`

## Functions
- [Connect-CTXAPI](Connect-CTXAPI.md) -- Connect to the cloud and create needed api headers
- [Get-CTXAPI_Applications](Get-CTXAPI_Applications.md) -- Return details about published apps
- [Get-CTXAPI_CloudConnectors](Get-CTXAPI_CloudConnectors.md) -- Details about current Cloud Connectors
- [Get-CTXAPI_CloudServices](Get-CTXAPI_CloudServices.md) -- Return details about cloud services and subscription
- [Get-CTXAPI_ConfigAudit](Get-CTXAPI_ConfigAudit.md) -- Reports on system config
- [Get-CTXAPI_ConfigLog](Get-CTXAPI_ConfigLog.md) -- Get high level configuration changes in the last x days.
- [Get-CTXAPI_ConnectionReport](Get-CTXAPI_ConnectionReport.md) -- Creates Connection report
- [Get-CTXAPI_DeliveryGroups](Get-CTXAPI_DeliveryGroups.md) -- Return details about Delivery Groups
- [Get-CTXAPI_FailureReport](Get-CTXAPI_FailureReport.md) -- Reports on failures in the last x hours.
- [Get-CTXAPI_HealthCheck](Get-CTXAPI_HealthCheck.md) -- Show useful information for daily health check
- [Get-CTXAPI_Hypervisors](Get-CTXAPI_Hypervisors.md) -- Return details about hosting (hypervisor)
- [Get-CTXAPI_LowLevelOperations](Get-CTXAPI_LowLevelOperations.md) -- Return details about low lever config change (More detailed)
- [Get-CTXAPI_MachineCatalogs](Get-CTXAPI_MachineCatalogs.md) -- Return details about machine catalogs
- [Get-CTXAPI_Machines](Get-CTXAPI_Machines.md) -- Return details about vda machines
- [Get-CTXAPI_MonitorData](Get-CTXAPI_MonitorData.md) -- Collect Monitoring OData for other reports
- [Get-CTXAPI_ResourceLocations](Get-CTXAPI_ResourceLocations.md) -- Get cloud Resource Locations
- [Get-CTXAPI_ResourceUtilization](Get-CTXAPI_ResourceUtilization.md) -- Resource utilization in the last x hours
- [Get-CTXAPI_Sessions](Get-CTXAPI_Sessions.md) -- Return details about current sessions
- [Get-CTXAPI_SiteDetails](Get-CTXAPI_SiteDetails.md) -- Return details about your farm / site
- [Get-CTXAPI_Tests](Get-CTXAPI_Tests.md) -- Run Built in Citrix cloud tests
- [Get-CTXAPI_VDAUptime](Get-CTXAPI_VDAUptime.md) -- Uses Registration date to calculate uptime
- [Get-CTXAPI_Zone](Get-CTXAPI_Zone.md) -- Get zone details
- [Set-CTXAPI_ReportColors](Set-CTXAPI_ReportColors.md) -- Set the color and logo for HTML Reports
- [Test-CTXAPI_Headers](Test-CTXAPI_Headers.md) -- Checks that the connection is still valid, and the token hasnt expired


