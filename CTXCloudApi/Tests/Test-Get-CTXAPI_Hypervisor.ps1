Describe 'Get-CTXAPI_Hypervisor' {
    It 'Should return hypervisor objects' {
        $header = Connect-CTXAPI -ApiUrl 'https://api.cloud.com' -Username 'test' -Password 'test'
        $hypervisors = Get-CTXAPI_Hypervisor -APIHeader $header
        $hypervisors | Should -Not -BeNullOrEmpty
    }
}
