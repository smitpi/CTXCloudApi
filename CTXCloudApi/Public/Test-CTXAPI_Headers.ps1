
<#PSScriptInfo

.VERSION 0.1.1

.GUID b8005a47-3bde-42fe-bbf7-b12bda147ad2

.AUTHOR Pierre Smit

.COMPANYNAME iOCO Tech

.COPYRIGHT

.TAGS ctx ps

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Created [13/11/2021_23:35] Initial Script Creating
Updated [14/11/2021_07:05] Added more functions

.PRIVATEDATA

#>




<#

.DESCRIPTION
Checks that the connection is still valid, and the token hasn't expired.

#>


<#
.SYNOPSIS
Checks that the connection is still valid, and the token hasn't expired.

.DESCRIPTION
Checks that the connection is still valid, and the token hasn't expired.

.PARAMETER APIHeader
Use Connect-CTXAPI to create headers.

.PARAMETER AutoRenew
If the token has expired, it will connect and renew the variable.

.EXAMPLE
Test-CTXAPI_Headers -APIHeader $APIHeader -AutoRenew

#>

Function Test-CTXAPI_Header {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Test-CTXAPI_Header')]
    [OutputType([System.Boolean[]])]
    PARAM(
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader,
        [switch]$AutoRenew = $false
    )

    $timeleft = [math]::Truncate(($APIHeader.TokenExpireAt - (Get-Date)).totalminutes)
    Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) [Processing] Time Left in min: $($timeleft)"
    if ($timeleft -lt 0) {
        Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) [Processing] Token Update Needed"
        if ($AutoRenew) {
            Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) [Processing] Updating Token"
            $APItmp = Connect-CTXAPI -Customer_Id $APIHeader.CTXAPI.Customer_Id -Client_Id $APIHeader.CTXAPI.Client_Id -Client_Secret $APIHeader.CTXAPI.Client_Secret -Customer_Name $APIHeader.CustomerName
            Get-Variable | Where-Object { $_.value -like '*TokenExpireAt=*' -and $_.Name -notlike 'APItmp' } | Set-Variable -Value $APItmp -Force -Scope global
            return $true
        }
        else { return $false }
    }
    else { return $true }


} #end Function
