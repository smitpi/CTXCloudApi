Describe 'Get-CTXAPI_Hypervisor' {
    BeforeAll {
        $header = [pscustomobject]@{ PSTypeName = 'CTXAPIHeaderObject'; TokenExpireAt = (Get-Date).AddHours(1); CTXAPI = [pscustomobject]@{}; headers = @{} }
    }
    BeforeEach {
        Mock Test-CTXAPI_Header { param($APIHeader) $APIHeader }
        Mock Get-CTXAPIDatapages { @([pscustomobject]@{ Name = 'Hyp1' }) }
    }
    It 'Should return hypervisor objects' {
        $hypervisors = Get-CTXAPI_Hypervisor -APIHeader $header
        $hypervisors | Should -Not -BeNullOrEmpty
    }
}
