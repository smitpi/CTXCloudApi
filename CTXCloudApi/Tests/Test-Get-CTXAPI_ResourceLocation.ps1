Describe 'Get-CTXAPI_ResourceLocation' {
    BeforeAll {
        $header = [pscustomobject]@{ PSTypeName = 'CTXAPIHeaderObject'; TokenExpireAt = (Get-Date).AddHours(1); CTXAPI = [pscustomobject]@{}; headers = @{} }
    }
    BeforeEach {
        Mock Test-CTXAPI_Header { param($APIHeader) $APIHeader }
        Mock Get-CTXAPIDatapages { @([pscustomobject]@{ Name = 'RL1' }) }
    }
    It 'Should return resource location objects' {
        $locations = Get-CTXAPI_ResourceLocation -APIHeader $header
        $locations | Should -Not -BeNullOrEmpty
    }
}
