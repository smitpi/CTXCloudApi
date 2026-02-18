



$api = Connect-CTXAPI -Customer_Id $CustomerID -Client_Id $apiKey -Client_Secret $secretKey -Customer_Name Rabobankprd
$mon = Get-CTXAPI_MonitorData -APIHeader $api -LastHours 4 -MonitorDetails All -verbose
Get-CTXAPI_Application -APIHeader $api
Get-CTXAPI_ConfigAudit -APIHeader $api  -Export HTML -ReportPath C:\Temp -Verbose
Get-CTXAPI_ConnectionReport -APIHeader $api -MonitorData $mon -Export Excel -ReportPath C:\Temp -Verbose
Get-CTXAPI_DeliveryGroup -APIHeader $api -verbose
Get-CTXAPI_FailureReport -APIHeader $api -MonitorData $mon -FailureType Connection -Export Excel -ReportPath C:\Temp
Get-CTXAPI_FailureReport -APIHeader $api -MonitorData $mon -FailureType Machine -Export Excel -ReportPath C:\Temp
Get-CTXAPI_Hypervisor -APIHeader $api
Get-CTXAPI_Machine -APIHeader $api
Get-CTXAPI_MachineCatalog -APIHeader $api
Get-CTXAPI_ResourceLocation -APIHeader $api
Get-CTXAPI_ResourceUtilization -APIHeader $api -MonitorData $mon -Export HTML -ReportPath C:\Temp -Verbose
Get-CTXAPI_Session -APIHeader $api
Get-CTXAPI_SiteDetail -APIHeader $api
Get-CTXAPI_VDAUptime -APIHeader $api
Get-CTXAPI_Zone -APIHeader $api
Test-CTXAPI_Header -APIHeader $api -AutoRenew

Get-CTXAPI_CloudService -APIHeader $api
Get-CTXAPI_LowLevelOperation -APIHeader $api
Get-CTXAPI_ConfigLog -APIHeader $api -Days 7