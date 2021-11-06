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
```
The logo can be changed by replacing the variable 
  - `$Global:Logourl` ='URL to your logo'
The colors of the report can be changed, by replacing:
  - `$global:colour1` = '# number of color'
  - `$global:colour2` = '# number of color'
Or permanently replace it by editing the following file
  - `<Module base>\Private\Reports-Variables.ps1`
```