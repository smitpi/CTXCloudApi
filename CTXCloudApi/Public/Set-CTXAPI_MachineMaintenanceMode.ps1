
<#PSScriptInfo

.VERSION 0.1.0

.GUID ed5ad668-660d-4927-b0d5-39c4b186c502

.AUTHOR Pierre Smit

.COMPANYNAME HTPCZA Tech

.COPYRIGHT

.TAGS ps ctx

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Created [27/02/2026_20:37] Initial Script

.PRIVATEDATA

#>

<# 

.DESCRIPTION 
 Set a machines maintenance mode. 

#> 


<#
.SYNOPSIS
Enables or disables Maintenance Mode for Citrix machines via CTX API, with an optional reason.

.DESCRIPTION
This function allows you to remotely toggle the Maintenance Mode state of Citrix machines using the CTX API. You can modify one or more machines by specifying their name, DNS name, or ID.

.PARAMETER APIHeader
The CTX API authentication header object (type CTXAPIHeaderObject) required for API calls.

.PARAMETER Name
The name, DNS name, or ID of the Citrix Machine(s) to target. Accepts an array of strings.

.PARAMETER InMaintenanceMode
Boolean value to set the maintenance mode state ($true to enable, $false to disable).

.PARAMETER Reason
An optional string to define the reason for enabling maintenance mode. This is visible in Citrix Studio and helps other administrators understand why the machine is unavailable.

.EXAMPLE
Set-CTXAPI_MachineMaintenanceMode -APIHeader $header -Name "CTX-Machine01" -InMaintenanceMode $true -Reason "Ticket INC-12345: RAM upgrade"
Places the specified Citrix Machine into maintenance mode with an audit reason.

.INPUTS
System.String[]

.OUTPUTS
System.Object[]
Returns the API response objects for each machine processed.
#>
function Set-CTXAPI_MachineMaintenanceMode {
	[Cmdletbinding(DefaultParameterSetName = 'Set1', HelpURI = 'https://smitpi.github.io/CTXCloudApi/Set-CTXAPI_MachineMaintenanceMode')]
	[OutputType([System.Object[]])]
	#region Parameter
	#region Parameter
	param(
		[Parameter(Position = 0, Mandatory)]
		[PSTypeName('CTXAPIHeaderObject')]$APIHeader,
       
		[Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, Mandatory)]
		[Alias('DNSName', 'Id')]
		[string[]]$Name,
       
		[Parameter(Mandatory)]
		[bool]$InMaintenanceMode
	)
	#endregion
	begin {
		if (-not(Test-CTXAPI_Header -APIHeader $APIHeader)) {Test-CTXAPI_Header -APIHeader $APIHeader -AutoRenew}
		else {	Write-Verbose "[$(Get-Date -Format HH:mm:ss) APIHEADER] Header still valid"}

		Write-Verbose "[$(Get-Date -Format HH:mm:ss) BEGIN] Starting $($myinvocation.mycommand)"
		[System.Collections.generic.List[PSObject]]$Machines = @()
		[System.Collections.generic.List[PSObject]]$ResultObject = @()
		Write-Verbose "Retrieving machines matching: $($Name -join ', ')"
       
		try {
			Get-CTXAPI_Machine -APIHeader $APIHeader |
				Where-Object {($_.Name -in $Name) -or ($_.Id -in $Name) -or ($_.DnsName -in $Name)} |
					ForEach-Object { $Machines.Add($_) }
           
			Write-Verbose ('Found {0} machines to process.' -f $Machines.Count)
		} catch {
			Write-Warning "Error retrieving machines - $_.Exception.Message"
		}
       
		# Build the JSON payload required for the PATCH request
		$body = @{
			InMaintenanceMode = $InMaintenanceMode
		}

	} #End Begin
   
	process {
		foreach ($machine in $Machines) {
			Write-Verbose "Processing machine: $($machine.DnsName) (ID: $($machine.Id))"
			try {
				# The update endpoint requires a PATCH method directed at the specific machine ID
				$baseuri = [string]::Format('https://api.cloud.com/cvad/manage/Machines/{0}', $machine.Id)
				Write-Verbose "Calling API: $baseuri with method PATCH"
               
				$apiResult = Invoke-RestMethod -Uri $baseuri -Method PATCH -Headers $APIHeader.headers -Body ($body | ConvertTo-Json -Depth 3 )
               
				Write-Verbose "API call result: $($apiResult | ConvertTo-Json -Depth 3)"
				$ResultObject.Add($apiResult)
				Write-Verbose "Successfully set InMaintenanceMode to '$InMaintenanceMode' on machine '$($machine.DnsName)' (ID: $($machine.Id))"
			
			} catch {
				Write-Warning "API call failed for machine '$($machine.DnsName)' - $_.Exception.Message"
			}
		}
	} #End Process
   
	end {
		Write-Verbose "[$(Get-Date -Format HH:mm:ss) END] Complete"
		return $ResultObject
	} #End End
} #end Function
