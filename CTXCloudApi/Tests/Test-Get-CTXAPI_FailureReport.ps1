Describe 'Get-CTXAPI_FailureReport' {
    It 'Should return failure report objects' {
        $header = Connect-CTXAPI -ApiUrl 'https://api.cloud.com' -Username 'test' -Password 'test'
        $failures = Get-CTXAPI_FailureReport -APIHeader $header
        $failures | Should -Not -BeNullOrEmpty
    }
}
