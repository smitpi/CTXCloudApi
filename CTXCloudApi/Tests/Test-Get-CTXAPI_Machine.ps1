Describe 'Get-CTXAPI_Machine' {
    BeforeAll {
        $header = [pscustomobject]@{ PSTypeName = 'CTXAPIHeaderObject'; TokenExpireAt = (Get-Date).AddHours(1); CTXAPI = [pscustomobject]@{}; headers = @{} }
    }
    BeforeEach {
        Mock Test-CTXAPI_Header { param($APIHeader) $APIHeader }
        Mock Get-CTXAPIDatapages { @([pscustomobject]@{ Id = 'm1'; Name = 'M1'; MachineCatalog = [pscustomobject]@{ Id = 'c1' } }) }
    }
    It 'Should return machine objects' {
        $machines = Get-CTXAPI_Machine -APIHeader $header
        $machines | Should -Not -BeNullOrEmpty
        $machines[0] | Should -HaveProperty 'MachineCatalog'
    }
}
