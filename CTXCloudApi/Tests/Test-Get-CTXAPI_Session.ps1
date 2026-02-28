Describe 'Get-CTXAPI_Session' {
    BeforeAll {
        $header = [pscustomobject]@{ PSTypeName = 'CTXAPIHeaderObject'; TokenExpireAt = (Get-Date).AddHours(1); CTXAPI = [pscustomobject]@{}; headers = @{} }
    }
    BeforeEach {
        Mock Test-CTXAPI_Header { param($APIHeader) $APIHeader }
        Mock Get-CTXAPIDatapages { @([pscustomobject]@{ Id = 'sess1' }) }
    }
    It 'Should return session objects' {
        $sessions = Get-CTXAPI_Session -APIHeader $header
        $sessions | Should -Not -BeNullOrEmpty
    }
}
