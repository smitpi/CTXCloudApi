Describe 'Set-CTXAPI_MachinePowerState' {
    It 'Should perform power action on machine' {
        # Replace with actual test logic and mock
        $header = Connect-CTXAPI -ApiUrl 'https://api.cloud.com' -Username 'test' -Password 'test'
        $result = Set-CTXAPI_MachinePowerState -APIHeader $header -Name 'TestMachine' -Action 'Start'
        $result | Should -Not -BeNullOrEmpty
    }
}
