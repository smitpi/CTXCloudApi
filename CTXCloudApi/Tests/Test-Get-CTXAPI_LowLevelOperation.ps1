Describe 'Get-CTXAPI_LowLevelOperation' {
    BeforeAll {
        $header = [pscustomobject]@{ PSTypeName = 'CTXAPIHeaderObject'; TokenExpireAt = (Get-Date).AddHours(1); CTXAPI = [pscustomobject]@{}; headers = @{} }
    }
    BeforeEach {
        Mock Test-CTXAPI_Header { param($APIHeader) $APIHeader }
        Mock Get-CTXAPIDatapages { @([pscustomobject]@{ Id = 'op1'; State = 'Done' }) }
    }
    It 'Should return low level operation objects' {
        $ops = Get-CTXAPI_LowLevelOperation -APIHeader $header
        $ops | Should -Not -BeNullOrEmpty
    }
}
