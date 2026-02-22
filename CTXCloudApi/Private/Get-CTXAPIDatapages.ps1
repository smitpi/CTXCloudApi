function Get-CTXAPIDatapages {
	[Cmdletbinding()]
	[OutputType([System.Collections.Generic.List[PSObject]])]
	param(
		[Parameter(Mandatory = $true)]
		$APIHeader,
		[Parameter(Mandatory = $true)]
		[string]$uri
	)

	[System.Collections.generic.List[PSObject]]$ReturnObject = @()
	Write-Verbose "Requesting initial page: $uri"
	$response = Invoke-RestMethod -Uri $uri -Method GET -Headers $APIHeader.headers
	Write-Verbose ('Received {0} items from initial page.' -f ($response.Items.Count))
	$response.Items | ForEach-Object {
		$ReturnObject.Add($_)
	}

	if ($response.PSObject.Properties['ContinuationToken']) {
		$ContinuationToken = $response.ContinuationToken
		Write-Verbose "Continuation token found: $ContinuationToken"
	} else {
		$ContinuationToken = $null
		Write-Verbose 'No continuation token found.'
	}

	while (-not [string]::IsNullOrEmpty($ContinuationToken)) {
		$requestUriContinue = $uri + '&continuationtoken=' + $ContinuationToken
		Write-Verbose "Requesting next page: $requestUriContinue"
		$responsePage = Invoke-RestMethod -Uri $requestUriContinue -Method GET -Headers $APIHeader.headers

		if ($responsePage.PSObject.Properties['Items']) {
			Write-Verbose ('Received {0} items from continuation page.' -f ($responsePage.Items.Count))
			$responsePage.Items | ForEach-Object {
				$ReturnObject.Add($_)
			}
		} else {
			Write-Verbose 'No items found in continuation page.'
		}

		if ($responsePage.PSObject.Properties['ContinuationToken'] -and -not [string]::IsNullOrEmpty($responsePage.ContinuationToken)) {
			$ContinuationToken = $responsePage.ContinuationToken
			Write-Verbose "Next continuation token: $ContinuationToken"
		} else {
			$ContinuationToken = $null
			Write-Verbose 'No further continuation token found.'
		}
	}
	Write-Verbose ('Returning {0} total items.' -f $ReturnObject.Count)
	return $ReturnObject

} #end function