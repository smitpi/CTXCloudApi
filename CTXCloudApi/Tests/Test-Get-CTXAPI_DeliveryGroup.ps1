Describe 'Get-CTXAPI_DeliveryGroup' {
    BeforeAll {
        $header = [pscustomobject]@{ PSTypeName = 'CTXAPIHeaderObject'; TokenExpireAt = (Get-Date).AddHours(1); CTXAPI = [pscustomobject]@{}; headers = @{} }
    }
    BeforeEach {
        Mock Test-CTXAPI_Header { param($APIHeader) $APIHeader }
        Mock Get-CTXAPIDatapages { @([pscustomobject]@{ Name = 'DG1' }) }
    }
    It 'Should return delivery group objects' {
        $groups = Get-CTXAPI_DeliveryGroup -APIHeader $header
        $groups | Should -Not -BeNullOrEmpty
    }
}
