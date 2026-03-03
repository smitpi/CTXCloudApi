


Import-Module "C:\Users\ladmin\Dropbox\#Profile\Documents\PowerShell\ProdModules\CTXCloudApi\CTXCloudApi\CTXCloudApi.psm1" -Force -Verbose
$SecureSecret = Import-Clixml -Path "C:\Secure\CTX_Secret.xml"

$api = Connect-CTXAPI -Customer_Id $PrdCustomerID -Client_Id $Client_Id -Client_Secret $Client_Secret -Customer_Name Rabobankprd
$mon = Get-CTXAPI_MonitorData -APIHeader $api -LastHours 6 -MonitorDetails All -verbose
$app = Get-CTXAPI_Application -APIHeader $api
$dl = Get-CTXAPI_DeliveryGroup -APIHeader $api -verbose
$hyp = Get-CTXAPI_Hypervisor -APIHeader $api
$mac = Get-CTXAPI_Machine -APIHeader $api
Get-CTXAPI_Machine -APIHeader $api -Name 1LABCTXPRD7355
$cat = Get-CTXAPI_MachineCatalog -APIHeader $api
$session = Get-CTXAPI_Session -APIHeader $api
$site = Get-CTXAPI_SiteDetail -APIHeader $api
$zone = Get-CTXAPI_Zone -APIHeader $api

$action = Set-CTXAPI_MachinePowerState -APIHeader $api -Name 1LABCTXPRD7355 -Action Shutdown
Set-CTXAPI_MachineMaintenanceMode -APIHeader $api -Name 1LABCTXPRD7355 -InMaintenanceMode $true 

Set-CTXAPI_MachineMaintenanceMode -APIHeader $api -Name 1LABCTXPRD7355 -InMaintenanceMode $false | Get-CTXAPI_Machine -APIHeader $api

New-CTXAPI_Report


Get-CTXAPI_CloudService -APIHeader $api
Get-CTXAPI_LowLevelOperation -APIHeader $api
Get-CTXAPI_ConfigLog -APIHeader $api -Days 7
$loc = Get-CTXAPI_ResourceLocation -APIHeader $api
