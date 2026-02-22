function Convert-UTCtoLocal { 
	param( 
		[parameter(Mandatory=$true)] 
		[String] $Time 
	)

	$strCurrentTimeZone = (Get-WmiObject win32_timezone).StandardName 
	$TZ = [System.TimeZoneInfo]::FindSystemTimeZoneById($strCurrentTimeZone) 
	$UTCTime = ([DateTime]$Time).ToUniversalTime()
	$LocalTime = [System.TimeZoneInfo]::ConvertTimeFromUtc($UTCTime, $TZ)
	return $LocalTime
}