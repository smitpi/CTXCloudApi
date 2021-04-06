# CTXCloudApi
## Getting Started
- You will need access to the Citrix Cloud API. Follow [Get API Access](https://developer.cloud.com/getting-started/docs/overview) to gain access.
- `Install-Module -Name CTXCloudApi -Verbose`
- `Import-Module CTXCloudApi -Verbose -Force`
- `Get-Command -Module CTXCloudApi`
- Run `Get-CTXAPI_Token` to get your token, and then `Get-CTXAPI_Siteid` to get site id (add them to a variable, for later use).

## Example:
  - `$Customerid = 'OompaLoompa'`
  - `$token = Get-CTXAPI_Token -client_id <clientid> -client_secret <clientsecret>`
  - `$siteid = Get-CTXAPI_Siteid -CustomerId $Customerid -ApiToken $token`
- To get a list of all the applications:
  - `Get-CTXAPI_Applications -CustomerId $Customerid -SiteId $siteid -ApiToken $token`

