<#PSScriptInfo

.VERSION 0.1.2

.GUID e20e1814-58e5-47c1-a7ae-5a74c364b9b2

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
Created [03/11/2021_19:35] Initial Script Creating
Updated [06/11/2021_16:49] Using the new api
Updated [14/11/2021_07:05] Added more functions

.PRIVATEDATA

#> 

#Requires -Module ImportExcel
#Requires -Module PSWriteHTML



<#

.DESCRIPTION 
Run Built in Citrix cloud tests

#>

<#
.SYNOPSIS
Run Built in Citrix cloud tests

.DESCRIPTION
Run Built in Citrix cloud tests

.PARAMETER APIHeader
Use Connect-CTXAPI to create headers

.PARAMETER SiteTest
Perform Site test

.PARAMETER HypervisorsTest
Perform the Hypervisors Test

.PARAMETER DeliveryGroupsTest
Perform the Delivery Groups Test

.PARAMETER MachineCatalogsTest
Perform the Machine Catalogs Test

.PARAMETER Export
In what format to export the reports.

.PARAMETER ReportPath
Destination folder for the exported report.

.EXAMPLE
Get-CTXAPI_Tests -APIHeader $APIHeader -SiteTest -HypervisorsTest -DeliveryGroupsTest -MachineCatalogsTest -Export HTML -ReportPath C:\temp

#>
# .ExternalHelp  CTXCloudApi-help.xml
Function Get-CTXAPI_Tests {
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
    [System.Collections.ArrayList]$Sum = @()
    if ($SiteTest) {
        try {
            Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) [Processing] Site Tests"
            try {
                Invoke-RestMethod "https://api.cloud.com/cvad/manage/Sites/$($APIHeader.headers.'Citrix-InstanceId')/`$test?async=true" -Headers $APIHeader.headers -Method Post -ContentType 'application/json'
            }
            catch { Write-Warning "Site Sum Test -- $($_.Exception.Message)" }
            try {
                $SiteTestResult = (Invoke-RestMethod "https://api.cloud.com/cvad/manage/Sites/$($APIHeader.headers.'Citrix-InstanceId')/TestReport" -Headers $APIHeader.headers).TestResults
            }
            catch { Write-Warning "Site Result Test -- $($_.Exception.Message)" }
            if ([bool]$SiteTestResult) { $data.AddRange($SiteTestResult) }
            Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) [Completed] Site Tests"
        }
        catch { Write-Warning $($_.Exception.Message) }
    }

    if ($HypervisorsTest) {
        try {
            Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) [Processing] Hypervisor Tests"
            $HypSum = Get-CTXAPI_Hypervisors -APIHeader $APIHeader | ForEach-Object {
                try {
                    Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) [Processing] $($_.name)"
                    Invoke-RestMethod "https://api.cloud.com/cvad/manage/hypervisors/$($_.id)/`$test" -Headers $APIHeader.headers -Method Post -ContentType 'application/json' | ForEach-Object { [PSCustomObject]@{
                            Test        = 'Hypervisor'
                            Name        = $_.Hypervisor.Name
                            NumPassed   = $_.NumPassed
                            NumWarnings = $_.NumWarnings
                            NumFailures = $_.NumFailures
                        }
                    }
                }
                catch { Write-Warning "Hypervisor Sum Test -- $($_.Exception.Message)" }
            }
            $HypResult = Get-CTXAPI_Hypervisors -APIHeader $APIHeader | ForEach-Object { 
                try {
                    Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) [Processing] $($_.name)"
                (Invoke-RestMethod "https://api.cloud.com/cvad/manage/hypervisors/$($_.id)/TestReport" -Headers $APIHeader.headers).TestResults 
                }
                catch { Write-Warning "Hypervisor Result Test -- $($_.Exception.Message)" }
            }
            if ([bool]$HypSum) { $sum.AddRange($HypSum) }
            if ([bool]$HypResult) { $data.AddRange($HypResult) }
            Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) [Completed] Hypervisor Tests"
        }
        catch { Write-Warning $($_.Exception.Message) }
    }

    if ($DeliveryGroupsTest) {
        try {
            Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) [Processing] DeliveryGroups Tests"
            $DeliverySum = Get-CTXAPI_DeliveryGroups -APIHeader $APIHeader | ForEach-Object {
                try {
                    Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) [Processing] $($_.name)"
                    Invoke-RestMethod "https://api.cloud.com/cvad/manage/DeliveryGroups/$($_.id)/`$test" -Headers $APIHeader.headers -Method Post -ContentType 'application/json' | ForEach-Object { [PSCustomObject]@{
                            Test        = 'DeliveryGroup'
                            Name        = $_.DeliveryGroup.Name
                            NumPassed   = $_.NumPassed
                            NumWarnings = $_.NumWarnings
                            NumFailures = $_.NumFailures
                        }
                    }
                }
                catch { Write-Warning "DeliveryGroups Sum Test -- $($_.Exception.Message)" }
            }
            $DeliveryResult = Get-CTXAPI_DeliveryGroups -APIHeader $APIHeader | ForEach-Object { 
                try {
                    Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) [Processing] $($_.name)"
                (Invoke-RestMethod "https://api.cloud.com/cvad/manage/DeliveryGroups/$($_.id)/TestReport" -Headers $APIHeader.headers).TestResults 
                }
                catch { Write-Warning "DeliveryGroups Result Test -- $($_.Exception.Message)" }
            }
            if ([bool]$DeliverySum) { $sum.AddRange($DeliverySum) }
            if ([bool]$DeliveryResult) { $data.AddRange($DeliveryResult) }
            Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) [Completed] DeliveryGroups Tests"
        }
        catch { Write-Warning $($_.Exception.Message) }
    }

    if ($MachineCatalogsTest) {
        try {
            Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) [Processing] MachineCatalogs Tests"
            $MachineCatalogsSum = Get-CTXAPI_MachineCatalogs -APIHeader $APIHeader | ForEach-Object {
                try {
                    Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) [Processing] $($_.name)"
                    Invoke-RestMethod "https://api.cloud.com/cvad/manage/MachineCatalogs/$($_.id)/`$test" -Headers $APIHeader.headers -Method Post -ContentType 'application/json' | ForEach-Object { [PSCustomObject]@{
                            Test        = 'MachineCatalog'
                            Name        = $_.MachineCatalog.Name
                            NumPassed   = $_.NumPassed
                            NumWarnings = $_.NumWarnings
                            NumFailures = $_.NumFailures
                        }
                    }
                }
                catch { Write-Warning "MachineCatalogs Sum Test -- $($_.Exception.Message)" }
            }
            $MachineCatalogsResult = Get-CTXAPI_MachineCatalogs -APIHeader $APIHeader | ForEach-Object { 
                try {
                    Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) [Processing] $($_.name)"
                (Invoke-RestMethod "https://api.cloud.com/cvad/manage/MachineCatalogs/$($_.id)/TestReport" -Headers $APIHeader.headers).TestResults 
                }
                catch { Write-Warning "MachineCatalogs Result Test -- $($_.Exception.Message)" }
            }
            if ([bool]$MachineCatalogsSum) { $sum.AddRange($MachineCatalogsSum) }
            if ([bool]$MachineCatalogsResult) { $data.AddRange($MachineCatalogsResult) }
            Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) [Completed] MachineCatalogs Tests"
        }
        catch { Write-Warning $($_.Exception.Message) }
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
    $expandedddata = $expandedddata | Sort-Object -Unique -Property Test, TestComponentTarget

    $Alldata = @{
        FatalError = $expandedddata | Where-Object { $_.Serverity -like 'FatalError' } | Group-Object -Property TestServiceTarget | Select-Object Name, Count | Sort-Object count -Descending
        Error      = $expandedddata | Where-Object { $_.Serverity -like 'Error' } | Group-Object -Property TestServiceTarget | Select-Object Name, Count | Sort-Object count -Descending
        Alldata    = $expandedddata
        Summary    = $Sum
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
            New-HTMLLogo -RightLogoString $CTXAPI_LogoURL
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
    if ($Export -eq 'Host') { $Alldata }


} #end Function
