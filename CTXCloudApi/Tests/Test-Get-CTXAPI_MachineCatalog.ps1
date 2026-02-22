Describe 'Get-CTXAPI_MachineCatalog' {
    It 'Should return machine catalog objects' {
        $header = Connect-CTXAPI -ApiUrl 'https://api.cloud.com' -Username 'test' -Password 'test'
        $catalogs = Get-CTXAPI_MachineCatalog -APIHeader $header
        $catalogs | Should -Not -BeNullOrEmpty
    }
}
