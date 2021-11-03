---
Module Name: CTXCloudApi
Module Guid: 8eb35bf0-e1d3-4b42-9285-d8010a1c13a7
Download Help Link:
help Version: 0.1.17
Locale: en-US
---

# CTXCloudApi Module
## Description
Wrapper for Citrix Cloud API
- HTML Reports 	
- When creating a HTML report: 
- The logo can be changed by replacing the variable  	
  $Global:Logourl ='' 
  - The colors of the report can be changed, by replacing: 		
  - $global:colour1 = '#061820' 		
  - $global:colour2 = '#FFD400' 	
  - Or permanently replace it by editing the following file 	
  - \<Module base\>\Private\Reports-Variables.ps1

## CTXCloudApi Cmdlets
### [Connect-CTXAPI](Connect-CTXAPI.md)
Connect to the cloud and create needed api headers

### [Get-CTXAPI_Applications](Get-CTXAPI_Applications.md)
Returns a list of published Apps

### [Get-CTXAPI_CloudServices](Get-CTXAPI_CloudServices.md)
Client's Subscription details, and what features are enabled

### [Get-CTXAPI_ConfigAudit](Get-CTXAPI_ConfigAudit.md)
Reports on machine catalog, delivery groups and published desktops

### [Get-CTXAPI_ConfigLog](Get-CTXAPI_ConfigLog.md)
reports on changes in the environment

### [Get-CTXAPI_ConfigLog](Get-CTXAPI_ConfigLog.md)
reports on changes in the environment

### [Get-CTXAPI_DeliveryGroups](Get-CTXAPI_DeliveryGroups.md)
Return details of all delivery groups

### [Get-CTXAPI_DeliveryGroups](Get-CTXAPI_DeliveryGroups.md)
Return details of all delivery groups

### [Get-CTXAPI_DeliveryGroups](Get-CTXAPI_DeliveryGroups.md)
Return details of all delivery groups

### [Get-CTXAPI_Hypervisors](Get-CTXAPI_Hypervisors.md)
Returns details about the hosting connection

### [Get-CTXAPI_LowLevelOperations](Get-CTXAPI_LowLevelOperations.md)
Retrieves detailed logs  administrator actions, from the Get-CTXAPI_ConfigLog function

### [Get-CTXAPI_MachineCatalogs](Get-CTXAPI_MachineCatalogs.md)
Return details about machine catalogs

### [Get-CTXAPI_Machines](Get-CTXAPI_Machines.md)
Details about VDA devices

### [Get-CTXAPI_MonitorData](Get-CTXAPI_MonitorData.md)
Get the data from odata

### [Get-CTXAPI_ResourceLocation](Get-CTXAPI_ResourceLocation.md)
Details about the resource locations

### [Get-CTXAPI_ResourceLocation](Get-CTXAPI_ResourceLocation.md)
Details about the resource locations

### [Get-CTXAPI_Sessions](Get-CTXAPI_Sessions.md)
Reports on user sessions

### [Get-CTXAPI_SiteDetails](Get-CTXAPI_SiteDetails.md)
Retrieve Site / Farm details

### [Get-CTXAPI_SiteDetails](Get-CTXAPI_SiteDetails.md)
Retrieve Site / Farm details

### [Get-CTXAPI_SiteDetails](Get-CTXAPI_SiteDetails.md)
Retrieve Site / Farm details

### [Get-CTXAPI_Zones](Get-CTXAPI_Zones.md)
Get zone details from api

