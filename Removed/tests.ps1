


Import-Module "C:\Users\ladmin\Dropbox\#Profile\Documents\PowerShell\ProdModules\CTXCloudApi\CTXCloudApi\CTXCloudApi.psm1" -Force -Verbose

$api = Connect-CTXAPI -Customer_Id $PrdCustomerID -Client_Id $Client_Id -Client_Secret $Client_Secret -Customer_Name Rabobankprd
$mon = Get-CTXAPI_MonitorData -APIHeader $api -LastHours 4 -MonitorDetails All -verbose
$app = Get-CTXAPI_Application -APIHeader $api
$config = Get-CTXAPI_ConfigAudit -APIHeader $api # not working
$connection = Get-CTXAPI_ConnectionReport -APIHeader $api -MonitorData $mon
$dl = Get-CTXAPI_DeliveryGroup -APIHeader $api -verbose
$connection = Get-CTXAPI_FailureReport -APIHeader $api -MonitorData $mon -FailureType Connection
$machinefail = Get-CTXAPI_FailureReport -APIHeader $api -MonitorData $mon -FailureType Machine
$hyp = Get-CTXAPI_Hypervisor -APIHeader $api
$mac = Get-CTXAPI_Machine -APIHeader $api
$cat = Get-CTXAPI_MachineCatalog -APIHeader $api
$util = Get-CTXAPI_ResourceUtilization -APIHeader $api -MonitorData $mon
$session = Get-CTXAPI_Session -APIHeader $api
$site = Get-CTXAPI_SiteDetail -APIHeader $api
$uptime = Get-CTXAPI_VDAUptime -APIHeader $api -Verbose
$zone = Get-CTXAPI_Zone -APIHeader $api
Test-CTXAPI_Header -APIHeader $api -AutoRenew
$action = Set-CTXAPI_MachinePowerState -APIHeader $api -Name 1LABCTXPRD7355 -Action Shutdown

Get-CTXAPI_CloudService -APIHeader $api
Get-CTXAPI_LowLevelOperation -APIHeader $api
Get-CTXAPI_ConfigLog -APIHeader $api -Days 7
$loc = Get-CTXAPI_ResourceLocation -APIHeader $api
