
<#PSScriptInfo

.VERSION 0.1.0

.GUID eada9ddb-93d9-481d-8dd3-d7f034f5e27e

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
Created [23/02/2026_09:03] Initial Script

.PRIVATEDATA

#>

<# 

.DESCRIPTION 
 Starts or shutdown machines. 

#> 


<#
.SYNOPSIS
Starts, shuts down, restarts, or logs off Citrix machines via CTX API.

.DESCRIPTION
This function allows you to remotely control the power state of Citrix machines using the CTX API. You can start, shut down, restart, or log off one or more machines by specifying their name, DNS name, or ID.

.PARAMETER APIHeader
The CTX API authentication header object (type CTXAPIHeaderObject) required for API calls.

.PARAMETER Name
The name, DNS name, or ID of the Citrix Machine(s) to target. Accepts an array of strings.

.PARAMETER PowerAction
The desired power action to perform. Valid values: Start, Shutdown, Restart, Logoff.

.EXAMPLE
Set-CTXAPI_MachinePowerState -APIHeader $header -Name "CTX-Machine01" -PowerAction Start
Starts the specified Citrix Machine.

.EXAMPLE
Set-CTXAPI_MachinePowerState -APIHeader $header -Name "CTX-Machine01","CTX-Machine02" -PowerAction Shutdown
Shuts down multiple Citrix Machines.

.INPUTS


.OUTPUTS
System.Object[]. Returns the API response objects for each machine processed.

.NOTES

#>
function Set-CTXAPI_MachinePowerState {
	[Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Set-CTXAPI_MachinePowerState')]
	[OutputType([System.Object[]])]
	#region Parameter
	param(
		[Parameter(Position = 0, Mandatory)]
		[PSTypeName('CTXAPIHeaderObject')]$APIHeader,
		[Parameter(ValueFromPipeline,
			ValueFromPipelineByPropertyName,
			ValueFromRemainingArguments)]
		[Alias('DNSName', 'Id')]
		[string[]]$Name,
		[ValidateSet('Start', 'Shutdown', 'Restart', 'Logoff')]
		[string]$PowerAction
	)
	#endregion
	begin {
		Write-Verbose "[$(Get-Date -Format HH:mm:ss) BEGIN] Starting $($myinvocation.mycommand)"
		[System.Collections.generic.List[PSObject]]$Machines = @()
		[System.Collections.generic.List[PSObject]]$ResultObject = @()
		Write-Verbose "Retrieving machines matching: $Name"
		try {
			Get-CTXAPI_Machine -APIHeader $APIHeader | Where-Object {($_.name -in $Name) -or ($_.id -in $name) -or ($_.DNSname -in $name)} | ForEach-Object { $Machines.Add($_) }
			Write-Verbose ('Found {0} machines to process.' -f $Machines.Count)
		} catch {
			Write-Warning "Error retrieving machines - $_.Exception.Message"
		}        
		if ($PSBoundParameters.ContainsKey('PowerAction')) {
			Write-Verbose "Action specified: $PowerAction"
			switch ($PowerAction) {
				'Start' { $endpoint = 'start' }
				'Shutdown' { $endpoint = 'shutdown' }
				'Restart' { $endpoint = 'reboot' }
				'Logoff' { $endpoint = 'logoff' }
			}
			Write-Verbose "API endpoint resolved: $endpoint"
		} else {
			Write-Warning 'No action specified. Please provide an action using the -PowerAction parameter (Start, Shutdown, Restart, Logoff).'
		}
	} #End Begin
	process {
		foreach ($machine in $Machines) {
			Write-Verbose "Processing machine: $($machine.DnsName) (ID: $($machine.Id))"
			try {
				$baseuri = [string]::Format('https://api.cloud.com/cvad/manage/Machines/{0}/${1}', $($machine.Name), $endpoint)
				Write-Verbose "Calling API: $baseuri"
				try {
					$apiResult = Invoke-RestMethod -Uri $baseuri -Method POST -Headers $APIHeader.headers
					Write-Verbose "API call result: $($apiResult | ConvertTo-Json -Depth 3)"
					$ResultObject.Add($apiResult)
					Write-Verbose "Performed action '$PowerAction' on machine '$($machine.DnsName)' (ID: $($machine.Id))"
				} catch {
					Write-Warning "API call failed for machine '$($machine.DnsName)' - $_.Exception.Message"
				}
			} catch {
				Write-Warning "Error processing machine '$($machine.DnsName)' - $_.Exception.Message"
			}
		}
	}#Process
	end {
		Write-Verbose "[$(Get-Date -Format HH:mm:ss) END] Complete"
		return $ResultObject
	}#End End
} #end Function
