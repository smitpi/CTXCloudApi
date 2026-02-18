function Export-Odata {
    [OutputType([System.Object[]])]
    param(
        [string]$URI,
        [Hashtable]$headers)



        
    [System.Collections.generic.List[PSObject]]$MonitorDataObject = @()
    $NextLink = $URI

    $uriObj = [Uri]($URI -replace '\\', '/')
    $resourceName = $uriObj.Segments[-1].TrimEnd('/')
    Write-Color -Text 'Fetching :', $resourceName -Color Yellow, Cyan -ShowTime -DateTimeFormat HH:mm:ss -NoNewLine
    $localTimer = [Diagnostics.Stopwatch]::StartNew()
    while (-not([string]::IsNullOrEmpty($NextLink))) {
        try {
            $request = Invoke-RestMethod -Method Get -Uri $NextLink -Headers $headers -ErrorAction Stop
        } catch {
            Write-Color -Text ' ERROR ', $_.Exception.Message -Color Red, Yellow -ShowTime -DateTimeFormat HH:mm:ss
            break
        }

        if ($null -eq $request) { break }

        # Detect OData error payloads and stop paging
        $errorProp = $null
        if ($request -is [object] -and $null -ne $request.PSObject) {
            $errorProp = $request.PSObject.Properties['error']
        }
        if ($null -ne $errorProp) {
            $msg = $errorProp.Value.PSObject.Properties['message']
            Write-Color -Text ' OData error: ', ($msg.Value) -Color Red, Yellow -ShowTime -DateTimeFormat HH:mm:ss
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
    [String]$seconds = '[' + ([math]::Round($localTimer.Elapsed.TotalSeconds)).ToString() + ' sec]'
    Write-Color $seconds -Color Red
    return $MonitorDataObject

}
