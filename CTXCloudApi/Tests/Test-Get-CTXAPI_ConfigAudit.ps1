Describe 'Get-CTXAPI_ConfigAudit' {
	Mock Get-CTXAPI_ConfigAudit { return @( @{ Id = 1 }, @{ Id = 2 } ) }
	It 'Should return config audit objects' {
		$header = @{ headers = @{ Authorization = 'Bearer token' } }
		$header.PSObject.TypeNames.Insert(0, 'CTXAPIHeaderObject')
		$audit = Get-CTXAPI_ConfigAudit -APIHeader $header
		$audit | Should Not BeNullOrEmpty
		$audit[0].Id | Should Not BeNullOrEmpty
	}

	Mock Get-CTXAPI_ConfigAudit { return @() } -ParameterFilter { $APIHeader.headers.Authorization -eq 'fail' }
	It 'Should handle empty response' {
		$header = @{ headers = @{ Authorization = 'fail' } }
		$header.PSObject.TypeNames.Insert(0, 'CTXAPIHeaderObject')
		$audit = Get-CTXAPI_ConfigAudit -APIHeader $header
		$audit | Should BeNullOrEmpty
	}

	Mock Get-CTXAPI_ConfigAudit { throw 'API failure' } -ParameterFilter { $APIHeader.headers.Authorization -eq 'error' }
	It 'Should handle API failure' {
		$header = @{ headers = @{ Authorization = 'error' } }
		$header.PSObject.TypeNames.Insert(0, 'CTXAPIHeaderObject')
		{ Get-CTXAPI_ConfigAudit -APIHeader $header } | Should Throw 'API failure'
	}

	It 'Should handle invalid input' {
		{ Get-CTXAPI_ConfigAudit -APIHeader $null } | Should Throw
	}
}
