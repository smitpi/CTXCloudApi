Describe 'Get-CTXAPI_Zone' {
    BeforeAll {
        $header = [pscustomobject]@{ PSTypeName = 'CTXAPIHeaderObject'; TokenExpireAt = (Get-Date).AddHours(1); CTXAPI = [pscustomobject]@{}; headers = @{} }
    }
    BeforeEach {
        Mock Test-CTXAPI_Header { param($APIHeader) $APIHeader }
        Mock Get-CTXAPIDatapages { @([pscustomobject]@{ Name = 'Zone1' }) }
    }
    It 'Should return zone objects' {
        $zones = Get-CTXAPI_Zone -APIHeader $header
        $zones | Should -Not -BeNullOrEmpty
    }
}
