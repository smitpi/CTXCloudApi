Describe 'Connect-CTXAPI' {
	BeforeAll {
		$secureSecret = ConvertTo-SecureString 'dummy' -AsPlainText -Force
	}

	BeforeEach {
		Mock Invoke-RestMethod {
			param(
				[string]$Uri,
				[hashtable]$Headers,
				[string]$Method,
				$Body
			)
			if ($Uri -eq 'https://api.cloud.com/cctrustoauth2/root/tokens/clients') {
				return [pscustomobject]@{ access_token = 'token123'; expires_in = 3600 }
			}
			if ($Uri -eq 'https://api.cloud.com/cvadapis/me') {
				return [pscustomobject]@{ customers = [pscustomobject]@{ sites = [pscustomobject]@{ id = 'instance-1' } } }
			}
			throw "Unexpected Invoke-RestMethod call: $Uri"
		}
	}

	It 'Should return a CTXAPIHeaderObject with required headers' {
		$result = Connect-CTXAPI -Customer_Id 'cust-1' -Client_Id 'client-1' -Client_Secret $secureSecret -Customer_Name 'TestTenant'
		$result | Should -Not -BeNullOrEmpty
		$result.PSTypeNames | Should -Contain 'CTXAPIHeaderObject'
		$result | Should -HaveProperty 'headers'
		$result.headers.Authorization | Should -Match 'CwsAuth Bearer='
		$result.headers.'Citrix-CustomerId' | Should -Be 'cust-1'
		$result.headers.'Citrix-InstanceId' | Should -Be 'instance-1'
		$result.TokenExpireAt | Should -BeOfType ([datetime])
	}
}
