Describe 'Test-CTXAPI_Header' {
    BeforeAll {
        $secureSecret = ConvertTo-SecureString 'dummy' -AsPlainText -Force
    }

    It 'Should return true when token not expired' {
        $header = [pscustomobject]@{
            PSTypeName    = 'CTXAPIHeaderObject'
            CustomerName  = 'Test'
            TokenExpireAt = (Get-Date).AddMinutes(30)
            CTXAPI        = [pscustomobject]@{ Customer_Id = 'cust'; Client_Id = 'client'; Client_Secret = $secureSecret }
            headers       = @{}
        }
        $result = Test-CTXAPI_Header -APIHeader $header
        $result | Should -BeTrue
    }

    It 'Should PassThru the same header when token not expired' {
        $header = [pscustomobject]@{
            PSTypeName    = 'CTXAPIHeaderObject'
            CustomerName  = 'Test'
            TokenExpireAt = (Get-Date).AddMinutes(30)
            CTXAPI        = [pscustomobject]@{ Customer_Id = 'cust'; Client_Id = 'client'; Client_Secret = $secureSecret }
            headers       = @{}
        }
        $result = Test-CTXAPI_Header -APIHeader $header -PassThru
        $result.PSTypeNames | Should -Contain 'CTXAPIHeaderObject'
        $result.TokenExpireAt | Should -Be $header.TokenExpireAt
    }

    It 'Should AutoRenew and PassThru a renewed header when expired' {
        $expired = [pscustomobject]@{
            PSTypeName    = 'CTXAPIHeaderObject'
            CustomerName  = 'Test'
            TokenExpireAt = (Get-Date).AddMinutes(-5)
            CTXAPI        = [pscustomobject]@{ Customer_Id = 'cust'; Client_Id = 'client'; Client_Secret = $secureSecret }
            headers       = @{}
        }
        Mock Connect-CTXAPI {
            return [pscustomobject]@{
                PSTypeName    = 'CTXAPIHeaderObject'
                CustomerName  = 'Test'
                TokenExpireAt = (Get-Date).AddMinutes(45)
                CTXAPI        = [pscustomobject]@{ Customer_Id = 'cust'; Client_Id = 'client'; Client_Secret = $secureSecret }
                headers       = @{}
            }
        }

        $result = Test-CTXAPI_Header -APIHeader $expired -AutoRenew -PassThru
        $result.TokenExpireAt | Should -BeGreaterThan (Get-Date)
    }
}
