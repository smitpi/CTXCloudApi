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
        $request = Invoke-RestMethod -Method Get -Uri $NextLink -Headers $headers

        # Safely add items from 'value' if present
        $valueProp = $request.PSObject.Properties['value']
        if ($null -ne $valueProp -and $null -ne $valueProp.Value) {
            foreach ($item in $valueProp.Value) { $MonitorDataObject.Add($item) }
        }

        # Safely get nextLink (case-insensitive) if present
        $nextLinkProp = ($request.PSObject.Properties | Where-Object { $_.Name -ieq '@odata.nextLink' })
        if ($null -ne $nextLinkProp -and -not [string]::IsNullOrEmpty($nextLinkProp.Value)) { $NextLink = $nextLinkProp.Value }
        else { $NextLink = $null }
    }
    [String]$seconds = '[' + ([math]::Round($localTimer.Elapsed.TotalSeconds)).ToString() + ' sec]'
    Write-Color $seconds -Color Red
    return $MonitorDataObject

}
