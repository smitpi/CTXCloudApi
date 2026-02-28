Describe 'Get-CTXAPI_VDAUptime' {
	It 'Should not be exported (removed cmdlet)' {
		Get-Command -Name 'Get-CTXAPI_VDAUptime' -ErrorAction SilentlyContinue | Should -BeNullOrEmpty
	}
}
