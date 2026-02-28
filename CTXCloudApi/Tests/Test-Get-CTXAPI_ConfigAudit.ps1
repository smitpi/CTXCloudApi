Describe 'Get-CTXAPI_ConfigAudit' {
	It 'Should not be exported (removed cmdlet)' {
		Get-Command -name 'Get-CTXAPI_ConfigAudit' -ErrorAction SilentlyContinue | Should -BeNullOrEmpty
	}
}
