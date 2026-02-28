Describe 'Get-CTXAPI_MonitorData' {
	BeforeAll {
		$header = [pscustomobject]@{ PSTypeName = 'CTXAPIHeaderObject'; TokenExpireAt = (Get-Date).AddHours(1); CTXAPI = [pscustomobject]@{}; headers = @{} }
	}
	BeforeEach {
		Mock Test-CTXAPI_Header { param($APIHeader) $APIHeader }
		Mock Export-Odata { @([pscustomobject]@{ Id = 's1' }) }
	}
	It 'Should return monitor data objects (Sessions only)' {
		$monitor = Get-CTXAPI_MonitorData -APIHeader $header -LastHours 1 -MonitorDetails Sessions
		$monitor | Should -Not -BeNullOrEmpty
		$monitor.PSTypeNames | Should -Contain 'CTXMonitorData'
		$monitor | Should -HaveProperty 'Sessions'
	}
}
