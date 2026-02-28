Describe 'Get-CTXAPI_MachineCatalog' {
    BeforeAll {
        $header = [pscustomobject]@{ PSTypeName = 'CTXAPIHeaderObject'; TokenExpireAt = (Get-Date).AddHours(1); CTXAPI = [pscustomobject]@{}; headers = @{} }
    }
    BeforeEach {
        Mock Test-CTXAPI_Header { param($APIHeader) $APIHeader }
        Mock Get-CTXAPIDatapages { @([pscustomobject]@{ Id = 'c1'; Name = 'Catalog1' }) }
    }
    It 'Should return machine catalog objects' {
        $catalogs = Get-CTXAPI_MachineCatalog -APIHeader $header
        $catalogs | Should -Not -BeNullOrEmpty
    }
}
