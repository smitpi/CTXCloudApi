Describe 'Get-CTXAPI_VDAUptime' {
    It 'Should return VDA uptime objects' {
        $header = Connect-CTXAPI -ApiUrl 'https://api.cloud.com' -Username 'test' -Password 'test'
        $uptime = Get-CTXAPI_VDAUptime -APIHeader $header
        $uptime | Should -Not -BeNullOrEmpty
    }
}
