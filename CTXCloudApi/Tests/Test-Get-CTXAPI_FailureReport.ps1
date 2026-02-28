Describe 'Get-CTXAPI_FailureReport' {
	It 'Should not be exported (removed cmdlet)' {
		Get-Command -Name 'Get-CTXAPI_FailureReport' -ErrorAction SilentlyContinue | Should -BeNullOrEmpty
	}
}
