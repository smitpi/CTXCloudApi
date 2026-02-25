function Get-CTXAPIDatapages {
	[Cmdletbinding()]
	[OutputType([System.Collections.Generic.List[PSObject]])]
	param(
		[Parameter(Mandatory = $true)]
		$APIHeader,
		[Parameter(Mandatory = $true)]
		[string]$uri
	)
	$uriObj = [Uri]($URI -replace '\\', '/')
	$resourceName = $uriObj.Segments[-1].TrimEnd('/')
	
	[System.Collections.generic.List[PSObject]]$ReturnObject = @()
	Write-Verbose "[$(Get-Date -Format HH:mm:ss)] [$($resourceName)] Requesting initial page: $uri"
	$response = Invoke-RestMethod -Uri $uri -Method GET -Headers $APIHeader.headers
	Write-Verbose "[$(Get-Date -Format HH:mm:ss)] [$($resourceName)] Received $($response.Items.Count) items from initial page"
	$response.Items | ForEach-Object {
		$ReturnObject.Add($_)
	}

	if ($response.PSObject.Properties['ContinuationToken']) {
		$ContinuationToken = $response.ContinuationToken
		Write-Verbose "[$(Get-Date -Format HH:mm:ss)] [$($resourceName)] Continuation token found"
	} else {
		$ContinuationToken = $null
		Write-Verbose "[$(Get-Date -Format HH:mm:ss)] [$($resourceName)] No continuation token found."
	}

	while (-not [string]::IsNullOrEmpty($ContinuationToken)) {
		$requestUriContinue = $uri + '&continuationtoken=' + $ContinuationToken
		Write-Verbose "[$(Get-Date -Format HH:mm:ss)] [$($resourceName)] Requesting next page"
		$responsePage = Invoke-RestMethod -Uri $requestUriContinue -Method GET -Headers $APIHeader.headers

		if ($responsePage.PSObject.Properties['Items']) {
			Write-Verbose "[$(Get-Date -Format HH:mm:ss)] [$($resourceName)] Received $($responsePage.Items.Count) items from continuation page."
			$responsePage.Items | ForEach-Object {
				$ReturnObject.Add($_)
			}
		} else {
			Write-Verbose "[$(Get-Date -Format HH:mm:ss)] [$($resourceName)] No items found in continuation page."
		}

		if ($responsePage.PSObject.Properties['ContinuationToken'] -and -not [string]::IsNullOrEmpty($responsePage.ContinuationToken)) {
			$ContinuationToken = $responsePage.ContinuationToken
			Write-Verbose "[$(Get-Date -Format HH:mm:ss)] [$($resourceName)] Next continuation token: $ContinuationToken"
		} else {
			$ContinuationToken = $null
			Write-Verbose "[$(Get-Date -Format HH:mm:ss)] [$($resourceName)] No further continuation token found."
		}
	}
	Write-Verbose "[$(Get-Date -Format HH:mm:ss)] [$($resourceName)] Returning $($ReturnObject.Count) total items."
	return $ReturnObject

} #end function