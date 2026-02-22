Describe 'Get-CTXAPI_Session' {
    It 'Should return session objects' {
        $header = Connect-CTXAPI -ApiUrl 'https://api.cloud.com' -Username 'test' -Password 'test'
        $sessions = Get-CTXAPI_Session -APIHeader $header
        $sessions | Should -Not -BeNullOrEmpty
    }
}
