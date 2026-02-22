Describe 'Get-CTXAPI_ConfigLog' {
    It 'Should return config log objects' {
        $header = Connect-CTXAPI -ApiUrl 'https://api.cloud.com' -Username 'test' -Password 'test'
        $log = Get-CTXAPI_ConfigLog -APIHeader $header
        $log | Should -Not -BeNullOrEmpty
    }
}
