function Export-Odata {
    [OutputType([System.Object[]])]
    param(
        [string]$URI,
        [Hashtable]$headers)

    [System.Collections.generic.List[PSObject]]$MonitorDataObject = @()
    $NextLink = $URI

    $uriObj = [Uri]($URI -replace '\\', '/')
    $resourceName = $uriObj.Segments[-1].TrimEnd('/')
    Write-Verbose "[$(Get-Date -Format HH:mm:ss)] Exporting OData resource: $resourceName"
    while (-not([string]::IsNullOrEmpty($NextLink))) {
            Write-Verbose "[$(Get-Date -Format HH:mm:ss)] Fetching next page..."
        try {
            $request = Invoke-RestMethod -Method Get -Uri $NextLink -Headers $headers -ErrorAction Stop
        } catch {
            Write-Error "[$(Get-Date -Format HH:mm:ss)] Failed to fetch data: $_"
            break
        }

        if ($null -eq $request) { break }

        # Detect OData error payloads and stop paging
        $errorProp = $null
        if ($request -is [object] -and $null -ne $request.PSObject) {
            $errorProp = $request.PSObject.Properties['error']
        }
        if ($null -ne $errorProp) {
            Write-Error "[$(Get-Date -Format HH:mm:ss)] Failed to fetch data: $_"
            break
        }

        # Safely add items from 'value' if present
        $valueProp = $null
        if ($request -is [object] -and $null -ne $request.PSObject -and $null -ne $request.PSObject.Properties) {
            $valueProp = $request.PSObject.Properties['value']
        }
        if ($null -ne $valueProp -and $null -ne $valueProp.Value) {
            foreach ($item in $valueProp.Value) { $MonitorDataObject.Add($item) }
        }

        # Safely get nextLink (case-insensitive) if present
        $nextLinkProp = $null
        if ($request -is [object] -and $null -ne $request.PSObject -and $null -ne $request.PSObject.Properties) {
            $nextLinkProp = ($request.PSObject.Properties | Where-Object { $_.Name -ieq '@odata.nextLink' })
        }
        if ($null -ne $nextLinkProp -and -not [string]::IsNullOrEmpty($nextLinkProp.Value)) { $NextLink = $nextLinkProp.Value }
        else { $NextLink = $null }
    }
    return $MonitorDataObject

}
