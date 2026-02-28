Describe 'Get-CTXAPI_ResourceUtilization' {
	It 'Should not be exported (removed cmdlet)' {
		Get-Command -Name 'Get-CTXAPI_ResourceUtilization' -ErrorAction SilentlyContinue | Should -BeNullOrEmpty
	}
}
