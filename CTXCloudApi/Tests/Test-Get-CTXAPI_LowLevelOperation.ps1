Describe 'Get-CTXAPI_LowLevelOperation' {
    It 'Should return low level operation objects' {
        $header = Connect-CTXAPI -ApiUrl 'https://api.cloud.com' -Username 'test' -Password 'test'
        $ops = Get-CTXAPI_LowLevelOperation -APIHeader $header
        $ops | Should -Not -BeNullOrEmpty
    }
}
