Describe 'Get-CTXAPI_Zone' {
    It 'Should return zone objects' {
        $header = Connect-CTXAPI -ApiUrl 'https://api.cloud.com' -Username 'test' -Password 'test'
        $zones = Get-CTXAPI_Zone -APIHeader $header
        $zones | Should -Not -BeNullOrEmpty
    }
}
