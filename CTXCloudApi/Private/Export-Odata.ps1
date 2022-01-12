Function Export-Odata {
    [CmdletBinding()]
    [OutputType([System.Object[]])]
    param(
        [string]$URI,
        [Hashtable]$headers)

    $data = @()
    $NextLink = $URI

    Write-Color -Text 'Fetching :',$URI.split('?')[0].split('\')[1] -Color Yellow,Cyan -ShowTime -DateTimeFormat HH:mm:ss -NoNewLine
    $APItimer.Restart()
    While ($Null -ne $NextLink) {
        $tmp = Invoke-WebRequest -Uri $NextLink -Headers $headers | ConvertFrom-Json
        $tmp.Value | ForEach-Object { $data += $_ }
        $NextLink = $tmp.'@odata.NextLink'
    }
    [String]$seconds = '[' + ($APItimer.elapsed.seconds).ToString() + 'sec]'
    Write-Color $seconds -Color Red
    return $data


} #end Function
