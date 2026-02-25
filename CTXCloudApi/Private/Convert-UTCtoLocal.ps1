function Convert-UTCtoLocal { 
	[OutputType([datetime])]
	param( 
		[parameter(Mandatory = $true)] 
		[datetime] $Time 
	)

	$utc = [datetime]::SpecifyKind($Time, [DateTimeKind]::Utc)
	$local = $utc.ToLocalTime()

	return $local

}