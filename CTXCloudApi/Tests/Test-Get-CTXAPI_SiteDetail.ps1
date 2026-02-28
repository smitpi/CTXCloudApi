Describe 'Get-CTXAPI_SiteDetail' {
    BeforeAll {
        $header = [pscustomobject]@{ PSTypeName = 'CTXAPIHeaderObject'; TokenExpireAt = (Get-Date).AddHours(1); CTXAPI = [pscustomobject]@{}; headers = @{ 'Citrix-InstanceId' = 'instance-1' } }
    }
    BeforeEach {
        Mock Test-CTXAPI_Header { param($APIHeader) $APIHeader }
        Mock Invoke-RestMethod { [pscustomobject]@{ Id = 'site1'; Name = 'Site' } }
    }
    It 'Should return site detail objects' {
        $site = Get-CTXAPI_SiteDetail -APIHeader $header
        $site | Should -Not -BeNullOrEmpty
        $site | Should -HaveProperty 'Id'
    }
}
