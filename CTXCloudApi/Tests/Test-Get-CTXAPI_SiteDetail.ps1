Describe 'Get-CTXAPI_SiteDetail' {
    It 'Should return site detail objects' {
        $header = Connect-CTXAPI -ApiUrl 'https://api.cloud.com' -Username 'test' -Password 'test'
        $site = Get-CTXAPI_SiteDetail -APIHeader $header
        $site | Should -Not -BeNullOrEmpty
    }
}
