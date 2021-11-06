
<#PSScriptInfo

.VERSION 1.0.1

.GUID f8a1aed0-09c4-4853-b310-9c6e87818f26

.AUTHOR Pierre Smit

.COMPANYNAME iOCO Tech

.COPYRIGHT

.TAGS citrix

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Created [05/05/2021_09:09] Initital Script Creating
Updated [05/05/2021_14:32] Manifest

.PRIVATEDATA

#>

#Requires -Module PSWriteColor

<#

.DESCRIPTION
Export multiple pages from odata

#>

Param()

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
