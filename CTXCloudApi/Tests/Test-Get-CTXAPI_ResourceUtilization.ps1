Describe 'Get-CTXAPI_ResourceUtilization' {
    It 'Should return resource utilization objects' {
        $header = Connect-CTXAPI -ApiUrl 'https://api.cloud.com' -Username 'test' -Password 'test'
        $util = Get-CTXAPI_ResourceUtilization -APIHeader $header
        $util | Should -Not -BeNullOrEmpty
    }
}
