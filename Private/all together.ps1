$machinecat = Get-CTXAPI_MachineCatalogs -CustomerId $CustomerId -SiteId $siteid -ApiToken $apitoken
$delgroups = Get-CTXAPI_DeliveryGroups -CustomerId $CustomerId -SiteId $siteid -ApiToken $apitoken

$machines = Get-CTXAPI_Machines -CustomerId $CustomerId -SiteId $siteid -ApiToken $apitoken
$apps = Get-CTXAPI_Applications -CustomerId $CustomerId -SiteId $siteid -ApiToken $apitoken
$sessions = Get-CTXAPI_Sessions -CustomerId $CustomerId -SiteId $siteid -ApiToken $apitoken