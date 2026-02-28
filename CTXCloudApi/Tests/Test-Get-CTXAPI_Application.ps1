Describe 'Get-CTXAPI_Application' {
	BeforeAll {
		$header = [pscustomobject]@{ PSTypeName = 'CTXAPIHeaderObject'; TokenExpireAt = (Get-Date).AddHours(1); CTXAPI = [pscustomobject]@{}; headers = @{} }
	}

	BeforeEach {
		Mock Test-CTXAPI_Header { param($APIHeader) $APIHeader }
	}

	It 'Should return application objects' {
		Mock Get-CTXAPIDatapages { @([pscustomobject]@{ Name = 'App1' }, [pscustomobject]@{ Name = 'App2' }) }
		$apps = Get-CTXAPI_Application -APIHeader $header
		$apps | Should -Not -BeNullOrEmpty
		$apps[0].Name | Should -Not -BeNullOrEmpty
	}

	It 'Should handle empty response' {
		Mock Get-CTXAPIDatapages { @() }
		$apps = Get-CTXAPI_Application -APIHeader $header
		$apps | Should -BeNullOrEmpty
	}

	It 'Should bubble API failure' {
		Mock Get-CTXAPIDatapages { throw 'API failure' }
		{ Get-CTXAPI_Application -APIHeader $header } | Should -Throw 'API failure'
	}

	It 'Should handle invalid input' {
		{ Get-CTXAPI_Application -APIHeader $null } | Should -Throw
	}
}
