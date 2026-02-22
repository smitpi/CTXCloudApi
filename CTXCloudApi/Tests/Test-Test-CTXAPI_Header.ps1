Describe 'Test-CTXAPI_Header' {
    It 'Should validate API header' {
        $header = Connect-CTXAPI -ApiUrl 'https://api.cloud.com' -Username 'test' -Password 'test'
        $result = Test-CTXAPI_Header -APIHeader $header
        $result | Should -BeTrue
    }
}
