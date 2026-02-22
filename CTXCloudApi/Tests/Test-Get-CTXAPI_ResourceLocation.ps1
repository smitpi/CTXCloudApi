Describe 'Get-CTXAPI_ResourceLocation' {
    It 'Should return resource location objects' {
        $header = Connect-CTXAPI -ApiUrl 'https://api.cloud.com' -Username 'test' -Password 'test'
        $locations = Get-CTXAPI_ResourceLocation -APIHeader $header
        $locations | Should -Not -BeNullOrEmpty
    }
}
