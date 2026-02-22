Describe 'Get-CTXAPI_ConnectionReport' {
    It 'Should return connection report objects' {
        $header = Connect-CTXAPI -ApiUrl 'https://api.cloud.com' -Username 'test' -Password 'test'
        $report = Get-CTXAPI_ConnectionReport -APIHeader $header
        $report | Should -Not -BeNullOrEmpty
    }
}
