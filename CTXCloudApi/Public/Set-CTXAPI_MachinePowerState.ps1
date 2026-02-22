
<#PSScriptInfo

.VERSION 0.1.0

.GUID d6f75dce-2fe6-41f4-bce4-2289bcb3365d

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
Created [22/02/2026_14:02] Initial Script

.PRIVATEDATA

#>

<# 
<#
.SYNOPSIS
Starts, shuts down, restarts, or logs off Citrix Cloud machines.

.DESCRIPTION
This function performs power actions (Start, Shutdown, Restart, Logoff) on one or more machines in Citrix Cloud using the CTXCloudApi module. Supports verbose output for detailed process tracking.

.PARAMETER APIHeader
The authentication header object returned by Connect-CTXAPI, required for all API calls.

.PARAMETER Name
The name, DNS name, or ID of the machine(s) to target for the power action.

.PARAMETER Action
The power action to perform. Valid values: Start, Shutdown, Restart, Logoff.

.EXAMPLE
Set-CTXAPI_MachinePowerState -APIHeader $header -Name "CTXPRD01" -Action Start -Verbose

Starts the machine named "CTXPRD01" and shows verbose output.

.EXAMPLE
Set-CTXAPI_MachinePowerState -APIHeader $header -Name "CTXPRD01","CTXPRD02" -Action Shutdown

Shuts down multiple machines.

.NOTES

.LINK
https://smitpi.github.io/CTXCloudApi/Set-CTXAPI_MachinePowerState
#>

#TODO - Test pipeline options

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
		[string]$Action
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
		if ($PSBoundParameters.ContainsKey('Action')) {
			Write-Verbose "Action specified: $Action"
			switch ($Action) {
				'Start' { $endpoint = 'start' }
				'Shutdown' { $endpoint = 'shutdown' }
				'Restart' { $endpoint = 'reboot' }
				'Logoff' { $endpoint = 'logoff' }
			}
			Write-Verbose "API endpoint resolved: $endpoint"
		} else {
			Write-Warning 'No action specified. Please provide an action using the -Action parameter (Start, Shutdown, Restart, Logoff).'
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
					Write-Verbose "Performed action '$Action' on machine '$($machine.DnsName)' (ID: $($machine.Id))"
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
