Describe 'Get-CTXAPI_CloudService' {
    BeforeAll {
        $header = [pscustomobject]@{ PSTypeName = 'CTXAPIHeaderObject'; TokenExpireAt = (Get-Date).AddHours(1); CTXAPI = [pscustomobject]@{}; headers = @{} }
    }
    BeforeEach {
        Mock Test-CTXAPI_Header { param($APIHeader) $APIHeader }
        Mock Get-CTXAPIDatapages { @([pscustomobject]@{ Name = 'CloudService1' }) }
    }
    It 'Should return cloud service objects' {
        $services = Get-CTXAPI_CloudService -APIHeader $header
        $services | Should -Not -BeNullOrEmpty
    }
}
