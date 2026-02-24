function Convert-UTCtoLocal { 
	[OutputType([datetime])]
	param( 
		[parameter(Mandatory = $true)] 
		[datetime] $Time 
	)

	# $strCurrentTimeZone = (Get-WmiObject win32_timezone).StandardName 
	# $TZ = [System.TimeZoneInfo]::FindSystemTimeZoneById($strCurrentTimeZone) 
	# $UTCTime = ([DateTime]$Time).ToUniversalTime()
	# $LocalTime = [System.TimeZoneInfo]::ConvertTimeFromUtc($UTCTime, $TZ)
	# return $LocalTime

	$utc = [datetime]::SpecifyKind($Time, [DateTimeKind]::Utc)
	$local = $utc.ToLocalTime()

	return $local

}