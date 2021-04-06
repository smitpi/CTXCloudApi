# CTXCloudApi
## Getting started
- Download and extract the module
- Browse to the module
- `Import-Module .\CTXCloudApi.psm1 -Verbose -Force`
- Run `Get-CTXAPI_Token` to get your token, and then `Get-CTXAPI_Siteid` to get site id (add them to a variable , to use later).
  - `$Customerid = 'OompaLoompa'`
  - `$token = Get-CTXAPI_Token -client_id <clientid> -client_secret <clientsecret>`
  - `$siteid = Get-CTXAPI_Siteid -CustomerId $Customerid -ApiToken $token`
- `Get-CTXAPI_Applications -CustomerId $Customerid -SiteId $siteid -ApiToken $token` This will list all the applications

