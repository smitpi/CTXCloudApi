Describe 'Get-CTXAPI_Application' {
	Mock Get-CTXAPI_Application { return @( @{ Name = 'App1' }, @{ Name = 'App2' } ) }
	It 'Should return application objects' {
		$header = @{ headers = @{ Authorization = 'Bearer token' } }
		$header.PSObject.TypeNames.Insert(0, 'CTXAPIHeaderObject')
		$apps = Get-CTXAPI_Application -APIHeader $header
		$apps | Should Not BeNullOrEmpty
		$apps[0].Name | Should Not BeNullOrEmpty
	}

	Mock Get-CTXAPI_Application { return @() } -ParameterFilter { $APIHeader.headers.Authorization -eq 'fail' }
	It 'Should handle empty response' {
		$header = @{ headers = @{ Authorization = 'fail' } }
		$header.PSObject.TypeNames.Insert(0, 'CTXAPIHeaderObject')
		$apps = Get-CTXAPI_Application -APIHeader $header
		$apps | Should BeNullOrEmpty
	}

	Mock Get-CTXAPI_Application { throw 'API failure' } -ParameterFilter { $APIHeader.headers.Authorization -eq 'error' }
	It 'Should handle API failure' {
		$header = @{ headers = @{ Authorization = 'error' } }
		$header.PSObject.TypeNames.Insert(0, 'CTXAPIHeaderObject')
		{ Get-CTXAPI_Application -APIHeader $header } | Should Throw 'API failure'
	}

	It 'Should handle invalid input' {
		{ Get-CTXAPI_Application -APIHeader $null } | Should Throw
	}
}
