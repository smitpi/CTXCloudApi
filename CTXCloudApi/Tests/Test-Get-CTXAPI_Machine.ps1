Describe 'Get-CTXAPI_Machine' {
    It 'Should return machine objects' {
        # Replace with actual test logic and mock
        $header = Connect-CTXAPI -ApiUrl 'https://api.cloud.com' -Username 'test' -Password 'test'
        $machines = Get-CTXAPI_Machine -APIHeader $header
        $machines | Should -Not -BeNullOrEmpty
        $machines[0] | Should -HaveProperty 'MachineCatalog'
    }
}
