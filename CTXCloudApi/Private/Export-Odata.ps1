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
    
#     [System.Collections.generic.List[PSObject]]$MonitorDataObject = @()
#     $NextLink = $URI

#     $VerbosePreference = 'Continue'

#     # Preflight: validate and prepare request headers (clone to avoid side effects)
#     # if (-not $headers -or -not ($headers -is [hashtable])) { throw 'Headers hashtable is required (e.g. from Connect-CTXAPI).' }
#     # $authHeader = $headers['Authorization']
#     # if ([string]::IsNullOrWhiteSpace($authHeader)) { throw "Authorization header is missing. Ensure you pass the headers from Connect-CTXAPI (e.g. -headers $api.headers)." }
#     # $reqHeaders = @{}
#     # foreach ($k in $headers.Keys) { $reqHeaders[$k] = $headers[$k] }
#     # if (-not $reqHeaders.ContainsKey('Accept')) { $reqHeaders['Accept'] = 'application/json' }

#     $uriObj = [Uri]($URI -replace '\\', '/')
#     $resourceName = $uriObj.Segments[-1].TrimEnd('/')
#     Write-Color -Text 'Fetching :', $resourceName -Color Yellow, Cyan -ShowTime -DateTimeFormat HH:mm:ss -NoNewLine
#     $localTimer = [Diagnostics.Stopwatch]::StartNew()
#     while (-not([string]::IsNullOrEmpty($NextLink))) {
#         Write-Verbose "Collecting data from $NextLink"
#         try {
#             $request = Invoke-RestMethod -Method Get -Uri $NextLink -Headers $headers -ErrorAction Stop
#         } catch {
#             $resp = $_.Exception.Response
#             if ($null -ne $resp) {
#                 $status = $resp.StatusCode
#                 $reason = $resp.ReasonPhrase
#                 $body = $null
#                 try { $body = $resp.Content.ReadAsStringAsync().Result } catch {}
#                 Write-Warning "Request failed: $status $reason"
#                 if ($body) { Write-Verbose "Response body: $body" }
#             } else {
#                 Write-Warning "Request failed: $($_.Exception.Message)"
#             }
#             break
#         }

#         # Safely add items from 'value' if present
#         $valueProp = $request.PSObject.Properties['value']
#         if ($null -ne $valueProp -and $null -ne $valueProp.Value) {
#             foreach ($item in $valueProp.Value) { $MonitorDataObject.Add($item) }
#         } else {
#             Write-Verbose "No 'value' array in response for $NextLink"
#         }

#         # Handle both '@odata.nextLink' and '@odata.NextLink' without throwing when absent
#         $nextLinkProp = ($request.PSObject.Properties | Where-Object { $_.Name -ieq '@odata.nextLink' })
#         if ($null -ne $nextLinkProp -and -not [string]::IsNullOrEmpty($nextLinkProp.Value)) {
#             $NextLink = $nextLinkProp.Value
#         } else {
#             $NextLink = $null
#         }
#     }
#     [String]$seconds = '[' + ([math]::Round($localTimer.Elapsed.TotalSeconds)).ToString() + ' sec]'
#     Write-Color $seconds -Color Red
#     return $MonitorDataObject


# } #end Function



# function GetMachinesInSiteWithPaging {
#     param (
#         [Parameter(Mandatory = $true)]
#         [string] $customerid,
#         [Parameter(Mandatory = $true)]
#         [string] $siteid,
#         [Parameter(Mandatory = $true)]
#         [string] $bearerToken
#     )
#     $requestUri = 'https://[DdcServerAddress]/cvad/manage/Machines?limit=1000'
#     $headers = @{
#         'Accept'            = 'application/json';
#         'Authorization'     = "CWSAuth Bearer=$bearerToken";
#         'Citrix-CustomerId' = $customerid;
#         'Citrix-InstanceId' = $siteid;
#     }

#     $response = Invoke-RestMethod -Uri $requestUri -Method GET -Headers $headers

#     while ($response.ContinuationToken -ne $null) {
#         $requestUriContinue = $requestUri + '&continuationtoken=' + $response.ContinuationToken
#         $responsePage = Invoke-RestMethod -Uri $requestUriContinue -Method GET -Headers $headers
#         $response.Items += $responsePage.Items
#         $response.ContinuationToken = $responsePage.ContinuationToken
#     }

#     return $response
# }

# $customerid = 'customer1'
# $siteid = '61603f15-cdf9-4c7f-99ff-91636601a795'
# $bearerToken = 'ey1..'
# $response = GetMachinesInSiteWithPaging $customerid $siteid $bearerToken
 


# $region = 'eu'
# $past = ((Get-Date).AddHours(-24)).ToString('yyyy-MM-ddTHH:mm:ss.ffffZ')
# $now = (Get-Date).ToString('yyyy-MM-ddTHH:mm:ss.ffffZ')

# $uri = "https://api-$region.cloud.com/monitorodata/SessionMetrics?$apply=filter(CollectedDate ge $past and CollectedDate le $now )"
# $rr = Invoke-RestMethod -Uri $uri -Headers $api.headers -Verbose

