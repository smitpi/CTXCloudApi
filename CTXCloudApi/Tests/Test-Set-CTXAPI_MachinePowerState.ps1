Describe 'Set-CTXAPI_MachinePowerState' {
    BeforeAll {
        $header = [pscustomobject]@{ PSTypeName = 'CTXAPIHeaderObject'; TokenExpireAt = (Get-Date).AddHours(1); CTXAPI = [pscustomobject]@{}; headers = @{} }
    }
    BeforeEach {
        Mock Test-CTXAPI_Header { param($APIHeader) $APIHeader }
        Mock Get-CTXAPI_Machine { @([pscustomobject]@{ Id = 'm1'; Name = 'TestMachine'; DnsName = 'TestMachine' }) }
        Mock Invoke-RestMethod { throw 'Invoke-RestMethod should not be called under -WhatIf in this test.' }
    }
    It 'Should support -WhatIf (no API call)' {
        $result = Set-CTXAPI_MachinePowerState -APIHeader $header -Name 'TestMachine' -PowerAction Start -WhatIf
        $result | Should -BeNullOrEmpty
    }
}
