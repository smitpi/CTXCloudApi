function Calc-Avg {
	param( 
		[long]$Duration,
		[int]$Count,
		[Switch]$ToSeconds =$false
	) 

	if ($Count -gt 0) { 
		$calc = $Duration / [double]$Count
		if ($ToSeconds) {
			return [math]::Round($calc / 1000)
		} else {
			return [math]::Round($calc)
		}
	} else { return $null } 
}
