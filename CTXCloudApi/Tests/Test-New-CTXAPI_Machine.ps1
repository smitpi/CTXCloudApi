Describe 'New-CTXAPI_Machine' {
    BeforeAll {
        $header = [pscustomobject]@{ PSTypeName = 'CTXAPIHeaderObject'; TokenExpireAt = (Get-Date).AddHours(1); CTXAPI = [pscustomobject]@{}; headers = @{} }
    }
    BeforeEach {
        Mock Test-CTXAPI_Header { param($APIHeader) $APIHeader }
        Mock Get-CTXAPI_MachineCatalog { [pscustomobject]@{ Id = 'cat1'; Name = 'TestCatalog'; FullName = 'TestCatalog'; ProvisioningScheme = [pscustomobject]@{ MachineAccountCreationRules = @() } } }
        Mock Get-CTXAPI_DeliveryGroup { [pscustomobject]@{ Id = 'dg1'; Name = 'TestGroup' } }
        Mock Get-CTXAPI_Machine { @() }
        Mock Invoke-RestMethod { throw 'Invoke-RestMethod should not be called under -WhatIf in this test.' }
    }
    It 'Should support -WhatIf without calling the API' {
        $result = New-CTXAPI_Machine -APIHeader $header -MachineCatalogName 'TestCatalog' -DeliveryGroupName 'TestGroup' -AmountOfMachines 1 -WhatIf
        $result | Should -BeNullOrEmpty
    }
}
