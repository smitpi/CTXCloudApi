Describe 'New-CTXAPI_Machine' {
    It 'Should create new machines and add to delivery group' {
        # Replace with actual test logic and mock
        $header = Connect-CTXAPI -ApiUrl 'https://api.cloud.com' -Username 'test' -Password 'test'
        $result = New-CTXAPI_Machine -APIHeader $header -MachineCatalogName 'TestCatalog' -DeliveryGroupName 'TestGroup' -AmountOfMachines 1
        $result | Should -Not -BeNullOrEmpty
    }
}
