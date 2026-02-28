Describe 'Get-CTXAPI_ConfigLog' {
    BeforeAll {
        $header = [pscustomobject]@{ PSTypeName = 'CTXAPIHeaderObject'; TokenExpireAt = (Get-Date).AddHours(1); CTXAPI = [pscustomobject]@{}; headers = @{} }
    }
    BeforeEach {
        Mock Test-CTXAPI_Header { param($APIHeader) $APIHeader }
        Mock Get-CTXAPIDatapages { @([pscustomobject]@{ Id = '1'; Description = 'Change' }) }
    }
    It 'Should return config log objects' {
        $log = Get-CTXAPI_ConfigLog -APIHeader $header
        $log | Should -Not -BeNullOrEmpty
    }
}
