Describe 'Connect-CTXAPI' {
	Mock Connect-CTXAPI { return @{ headers = @{ Authorization = 'Bearer token' } } }
	It 'Should connect and return a valid header object' {
		$result = Connect-CTXAPI -Customer_Id $PrdCustomerID -Client_Id $Client_Id -Client_Secret $Client_Secret -Customer_Name Rabobank
		$result | Should Not BeNullOrEmpty
		$result | Should BeOfType Hashtable
		if (-not $result.ContainsKey('headers')) {
			throw "Result should have a 'headers' property."
		}
	}
}
