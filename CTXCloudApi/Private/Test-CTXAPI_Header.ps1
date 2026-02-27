
<#PSScriptInfo

.VERSION 1.1.8

.GUID d87929c1-2616-47b9-8d67-f268794e9d11

.AUTHOR Pierre Smit

.COMPANYNAME Private

.COPYRIGHT

.TAGS

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES


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
Test-CTXAPI_Header -APIHeader $APIHeader -AutoRenew

#>

function Test-CTXAPI_Header {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Test-CTXAPI_Header')]
    [Alias('Test-CTXAPI_Headers')]
    [OutputType([System.Boolean])]
    param(
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
            Get-Variable | Where-Object { $_.value -like '*TokenExpireAt=*' -and $_.Name -notlike 'APItmp' } | Set-Variable -Value $APItmp -Force -Scope Script
            return $true
        } else { return $false }
    } else { return $true }


} #end Function
