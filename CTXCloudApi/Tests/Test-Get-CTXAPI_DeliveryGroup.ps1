Describe 'Get-CTXAPI_DeliveryGroup' {
    It 'Should return delivery group objects' {
        $header = Connect-CTXAPI -ApiUrl 'https://api.cloud.com' -Username 'test' -Password 'test'
        $groups = Get-CTXAPI_DeliveryGroup -APIHeader $header
        $groups | Should -Not -BeNullOrEmpty
    }
}
