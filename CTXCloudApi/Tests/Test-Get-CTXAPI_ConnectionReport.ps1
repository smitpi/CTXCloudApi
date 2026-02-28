Describe 'Get-CTXAPI_ConnectionReport' {
	It 'Should not be exported (removed cmdlet)' {
		Get-Command -Name 'Get-CTXAPI_ConnectionReport' -ErrorAction SilentlyContinue | Should -BeNullOrEmpty
	}
}
