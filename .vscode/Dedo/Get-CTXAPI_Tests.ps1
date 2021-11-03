
<#PSScriptInfo

.VERSION 1.1.1

.GUID 46687284-ec4b-4a37-baa8-a18178864af8

.AUTHOR Pierre Smit

.COMPANYNAME iOCO Tech

.COPYRIGHT

.TAGS api ctx

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Created [06/10/2021_21:23] Initial Script Creating
Updated [07/10/2021_13:28] Script info updated for module

.PRIVATEDATA

#>



<#

.DESCRIPTION
Return details about published apps

#>

Param()
#.ExternalHelp CTXCloudApi-help.xml
Function Get-CTXAPI_Test {
    <#
.SYNOPSIS
Run Built in Citrix cloud tests

.DESCRIPTION
Run Built in Citrix cloud tests

.PARAMETER APIHeader
Use Connect-CTXAPI to create headers

.PARAMETER SiteTest
Perform tests on the whole site

.PARAMETER HypervisorsTest
Perform tests on the host connection

.PARAMETER DeliveryGroupsTest
Perform tests on the Delivery groups

.PARAMETER MachineCatalogsTest
Perform tests on the machine catalogs

.PARAMETER Export
Export format

.PARAMETER ReportPath
Report path

.EXAMPLE
Get-CTXAPI_Tests -APIHeader $APIHeader -SiteTest -HypervisorsTest -DeliveryGroupsTest -MachineCatalogsTest -Export HTML -ReportPath C:\Temp

.NOTES
General notes
#>
    [Cmdletbinding()]
    [OutputType([System.Collections.Hashtable])]
    PARAM(
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader,
        [switch]$SiteTest = $false,
        [switch]$HypervisorsTest = $false,
        [switch]$DeliveryGroupsTest = $false,
        [switch]$MachineCatalogsTest = $false,
        [Parameter(Mandatory = $false)]
        [ValidateSet('Excel', 'HTML')]
        [string]$Export = 'Host',
        [Parameter(Mandatory = $false)]
        [ValidateScript( { (Test-Path $_) })]
        [string]$ReportPath = $env:temp
				)

    [System.Collections.ArrayList]$data = @()

    if ($SiteTest) {
        Write-Color 'Retrieving test results' -Color Cyan -ShowTime -NoNewLine
        $SiteTestSum = Invoke-RestMethod "https://api.cloud.com/cvad/manage/Sites/$($APIHeader.headers.'Citrix-InstanceId')/`$test?async=true" -Headers $APIHeader.headers -Method Post -ContentType 'application/json'
        $SiteTestResult = (Invoke-RestMethod "https://api.cloud.com/cvad/manage/Sites/$($APIHeader.headers.'Citrix-InstanceId')/TestReport" -Headers $APIHeader.headers).TestResults
        $data.AddRange($SiteTestResult)
        Write-Color 'Complete' -Color Green -ShowTime
    }

    if ($HypervisorsTest) {
        Write-Color 'Getting hypervisors test results' -Color Cyan -ShowTime -NoNewLine
        $HypSum = (Get-CTXAPI_Hypervisors -APIHeader $APIHeader).id | ForEach-Object { Invoke-RestMethod "https://api.cloud.com/cvad/manage/hypervisors/$_/`$test" -Headers $APIHeader.headers -Method Post -ContentType 'application/json' }
        $HypResult = (Get-CTXAPI_Hypervisors -APIHeader $APIHeader).id | ForEach-Object { (Invoke-RestMethod "https://api.cloud.com/cvad/manage/hypervisors/$_/TestReport" -Headers $APIHeader.headers).TestResults }
        $data.AddRange($HypResult)
        Write-Color 'Complete' -Color Green -ShowTime
    }

    if ($DeliveryGroupsTest) {
        Write-Color 'Getting DeliveryGroups test results' -Color Cyan -ShowTime -NoNewLine
        $DeliverySum = (Get-CTXAPI_DeliveryGroups -APIHeader $APIHeader).id | ForEach-Object { Invoke-RestMethod "https://api.cloud.com/cvad/manage/DeliveryGroups/$_/`$test" -Headers $APIHeader.headers -Method Post -ContentType 'application/json' }
        $DeliveryResult = (Get-CTXAPI_DeliveryGroups -APIHeader $APIHeader).id | ForEach-Object { (Invoke-RestMethod 'https://api.cloud.com/cvad/manage/DeliveryGroups/b77c0864-609f-4e57-b93e-aeee2ec91323/TestReport' -Headers $APIHeader.headers).TestResults }
        $data.AddRange($DeliveryResult)
        Write-Color 'Complete' -Color Green -ShowTime
    }

    if ($MachineCatalogsTest) {
        Write-Color 'Getting MachineCatalogs test results' -Color Cyan -ShowTime -NoNewLine
        $MachineCatalogsSum = (Get-CTXAPI_MachineCatalogs -APIHeader $APIHeader).id | ForEach-Object { Invoke-RestMethod "https://api.cloud.com/cvad/manage/MachineCatalogs/$_/`$test" -Headers $APIHeader.headers -Method Post -ContentType 'application/json' }
        $MachineCatalogsResult = (Get-CTXAPI_MachineCatalogs -APIHeader $APIHeader).id | ForEach-Object { (Invoke-RestMethod "https://api.cloud.com/cvad/manage/MachineCatalogs/$_/TestReport" -Headers $APIHeader.headers).TestResults }
        $data.AddRange($MachineCatalogsResult)
        Write-Color 'Complete' -Color Green -ShowTime
    }

    $expandedddata = @()
    foreach ($top in $data) {
        foreach ($item in $top.TestComponents) {
            $expandedddata += [PSCustomObject]@{
                Test                 = $top.TestName
                TestDescription      = $top.TestDescription
                TestScope            = $top.TestScope
                TestServiceTarget    = $top.TestServiceTarget
                TestComponentStatus  = $top.TestComponentStatus
                FormattedTestEndTime = $top.FormattedTestEndTime
                TestComponentTarget  = $item.TestComponentTarget
                Explanation          = $item.ResultDetails[0].Explanation
                Serverity            = $item.ResultDetails[0].Serverity
                Action               = $item.ResultDetails[0].Action
            }
        }
    }

    $Alldata = @{
        FatalError = $expandedddata | Where-Object { $_.Serverity -like 'FatalError' } | Group-Object -Property TestServiceTarget | Select-Object Name, Count | Sort-Object count -Descending
        Error      = $expandedddata | Where-Object { $_.Serverity -like 'Error' } | Group-Object -Property TestServiceTarget | Select-Object Name, Count | Sort-Object count -Descending
        Alldata    = $expandedddata
    }


    if ($Export -eq 'Excel') {
        $Alldata.FatalError | Export-Excel -Path ($ReportPath + '\Tests-' + (Get-Date -Format yyyy.MM.dd-HH.mm) + '.xlsx') -AutoSize -AutoFilter -WorksheetName FatalError
        $Alldata.Error | Export-Excel -Path ($ReportPath + '\Tests-' + (Get-Date -Format yyyy.MM.dd-HH.mm) + '.xlsx') -AutoSize -AutoFilter -WorksheetName error
        $Alldata.Alldata | Export-Excel -Path ($ReportPath + '\Tests-' + (Get-Date -Format yyyy.MM.dd-HH.mm) + '.xlsx') -AutoSize -AutoFilter -WorksheetName Alldata -Show
    }
    if ($Export -eq 'HTML') {
        [string]$HTMLReportname = $ReportPath + '\Tests-' + (Get-Date -Format yyyy.MM.dd-HH.mm) + '.html'
        $HeadingText = $CustomerId + ' | Report | ' + (Get-Date -Format dd) + ' ' + (Get-Date -Format MMMM) + ',' + (Get-Date -Format yyyy) + ' ' + (Get-Date -Format HH:mm)
        New-HTML -TitleText "$CustomerId Report" -FilePath $HTMLReportname -ShowHTML {
            New-HTMLLogo -RightLogoString $logourl
            New-HTMLHeading -Heading h1 -HeadingText $HeadingText -Color Black
            New-HTMLSection @SectionSettings -Content {
                New-HTMLSection -HeaderText 'Fatal Errors' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $Alldata.FatalError }
                New-HTMLSection -HeaderText 'Errors' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $Alldata.Error }
            }
            New-HTMLSection @SectionSettings -Content {
                New-HTMLSection -HeaderText 'Alldata' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $alldata.Alldata }
            }
        }
    }
    if ($Export -eq 'Host') {
        $SiteTestSum
        $HypSum
        $DeliverySum
        $MachineCatalogsSum
    }


} #end Function
