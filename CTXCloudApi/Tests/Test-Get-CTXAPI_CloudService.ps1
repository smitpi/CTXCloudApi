Describe 'Get-CTXAPI_CloudService' {
    It 'Should return cloud service objects' {
        $header = Connect-CTXAPI -ApiUrl 'https://api.cloud.com' -Username 'test' -Password 'test'
        $services = Get-CTXAPI_CloudService -APIHeader $header
        $services | Should -Not -BeNullOrEmpty
    }
}
