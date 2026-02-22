Describe 'Get-CTXAPI_MonitorData' {
	It 'Should return monitor data objects' {
		$header = Connect-CTXAPI -ApiUrl 'https://api.cloud.com' -Username 'test' -Password 'test'
		$monitor = Get-CTXAPI_MonitorData -APIHeader $header
		$monitor | Should -Not -BeNullOrEmpty
	}
}
