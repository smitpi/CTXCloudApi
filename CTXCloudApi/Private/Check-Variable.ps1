function Check-Variable {
	[CmdletBinding()]
	param (
		$VariableName
	)
	if ([string]::IsNullOrEmpty($VariableName)) {
		Write-Verbose "[$(Get-Date -Format HH:mm:ss)] [Check-Variable]  Variable is null or empty. Returning null."
		return $null
	} else {
		$Type = ($VariableName.GetType()).Name
		if ($Type -eq 'DateTime') {
			Write-Verbose "[$(Get-Date -Format HH:mm:ss)] [Check-Variable]  Variable is of type DateTime. Converting to local time."
			$out = Convert-UTCtoLocal -Time $VariableName
			return $out
		} else {
			Write-Verbose "[$(Get-Date -Format HH:mm:ss)] [Check-Variable]  Variable is not of type DateTime. Returning original value."
			return $VariableName
		}
	}
}
