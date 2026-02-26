function Calc-Avg {
	param( 
		[long]$Duration,
		[int]$Count
	) 

	if ($Count -gt 0) { 
		$calc = $Duration / [double]$Count
		return [math]::Round($calc)
	} else { return $null } 
}