    Function Export-Odata {
        [OutputType([System.Object[]])]
        param(
            [string]$URI,
            [Hashtable]$headers)

        [System.Collections.generic.List[PSObject]]$MonitorDataObject = @()
        $NextLink = $URI

        Write-Color -Text 'Fetching :', $URI.split('?')[0].split('\')[1] -Color Yellow, Cyan -ShowTime -DateTimeFormat HH:mm:ss -NoNewLine
        $APItimer.Restart()
        While (-not([string]::IsNullOrEmpty($NextLink))) {
            $request = Invoke-RestMethod -Method Get -Uri $NextLink -Headers $headers
            $request.Value | ForEach-Object { $MonitorDataObject.Add($_) }
            
            if (-not([string]::IsNullOrEmpty($request.'@odata.NextLink'))) {$NextLink = $request.'@odata.NextLink'}
            else {$NextLink = $null}
        }
        [String]$seconds = '[' + ($APItimer.elapsed.seconds).ToString() + 'sec]'
        Write-Color $seconds -Color Red
        return $MonitorDataObject


    } #end Function
