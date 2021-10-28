
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
Created [06/10/2021_21:23] Initital Script Creating
Updated [07/10/2021_13:28] Script info updated for module

.PRIVATEDATA

#> 



<# 

.DESCRIPTION 
Return details about published apps

#> 

Param()
#.ExternalHelp CTXCloudApi-help.xml
Function Get-CTXAPI_Tests {
    [Cmdletbinding()]
    [OutputType([System.Collections.Hashtable])]
    PARAM(
        [PSTypeName(CTXAPIHeaderObject)]$APIHeader
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

    $data = @()

    if ($SiteTest) {

        Write-Color 'Requesting Site Tests' -Color DarkYellow -ShowTime
        Invoke-RestMethod -Uri "https://api.cloud.com/cvad/manage/Sites/$($APIHeader.headers.'Citrix-InstanceId')/`$test" -Method Post -Headers $APIHeader.headers -ContentType application/json
        Write-Color 'Sleeping for',' 60sec' -Color Cyan,Yellow -ShowTime
        Start-Sleep 60
        Write-Color 'Retrieving test results' -Color Cyan -ShowTime -NoNewLine
        $data += (Invoke-RestMethod -Uri "https://api.cloud.com/cvad/manage/Sites/$($APIHeader.headers.'Citrix-InstanceId')/TestReport" -Method get -Headers $APIHeader.headers).TestResults


        Write-Color 'Complete' -Color Green -ShowTime
    }

    ## TODO I need to fix these urls.
    
    if ($HypervisorsTest) {
        Write-Color 'Requesting hypervisors Tests' -Color DarkYellow -ShowTime
        (Invoke-RestMethod "https://api.cloud.com/cvadapis/$siteid/hypervisors" -Headers $headers).items.id | ForEach-Object { Invoke-RestMethod "https://api.cloud.com/cvadapis/$siteid/hypervisors/$_/`$test" -Method Post -Headers $headers -ContentType 'application/json' }
        (Invoke-RestMethod -Uri 'https://api.cloud.com/cvad/manage/hypervisors/' -Method get -Headers $APIHeader.headers).items | ForEach-Object { Invoke-RestMethod -Uri "https://api.cloud.com/cvad/manage/hypervisors/38750ad8-66cb-4438-9c14-17fc64a1e71c/`$test" -Method post -Headers $APIHeader.headers -ContentType 'application/json' }
        Write-Color 'Sleeping for',' 60sec' -Color Cyan,Yellow -ShowTime
        Start-Sleep 60
        Write-Color 'Retrieving test results' -Color Cyan -ShowTime -NoNewLine
        $data += (Invoke-RestMethod "https://api.cloud.com/cvadapis/$siteid/hypervisors" -Headers $headers).items.id | ForEach-Object { (Invoke-RestMethod "https://api.cloud.com/cvadapis/$siteid/hypervisors/$_/TestReport" -Headers $headers).TestResults }
        Write-Color 'Complete' -Color Green -ShowTime
    }

    if ($DeliveryGroupsTest) {
        Write-Color 'Requesting DeliveryGroups Tests' -Color DarkYellow -ShowTime
        (Invoke-RestMethod "https://api.cloud.com/cvadapis/$siteid/DeliveryGroups" -Headers $headers).items.id | ForEach-Object { Invoke-RestMethod "https://api.cloud.com/cvadapis/$siteid/DeliveryGroups/$_/`$test" -Method Post -Headers $headers -ContentType 'application/json' }
        Write-Color 'Sleeping for',' 60sec' -Color Cyan,Yellow -ShowTime
        Start-Sleep 60
        Write-Color 'Retrieving test results' -Color Cyan -ShowTime -NoNewLine
        $data += (Invoke-RestMethod "https://api.cloud.com/cvadapis/$siteid/DeliveryGroups" -Headers $headers).items.id | ForEach-Object { (Invoke-RestMethod "https://api.cloud.com/cvadapis/$siteid/DeliveryGroups/$_/TestReport" -Headers $headers -Verbose).TestResults }
        Write-Color 'Complete' -Color Green -ShowTime
    }

    if ($MachineCatalogsTest) {
        Write-Color 'Requesting MachineCatalogs Tests' -Color DarkYellow -ShowTime
        (Invoke-RestMethod "https://api.cloud.com/cvadapis/$siteid/MachineCatalogs" -Headers $headers).items.id | ForEach-Object { Invoke-RestMethod "https://api.cloud.com/cvadapis/$siteid/MachineCatalogs/$_/`$test" -Method Post -Headers $headers -ContentType 'application/json' }
        Write-Color 'Sleeping for',' 60sec' -Color Cyan,Yellow -ShowTime
        Start-Sleep 60
        Write-Color 'Retrieving test results' -Color Cyan -ShowTime -NoNewLine
        $data += (Invoke-RestMethod "https://api.cloud.com/cvadapis/$siteid/MachineCatalogs" -Headers $headers).items.id | ForEach-Object { (Invoke-RestMethod "https://api.cloud.com/cvadapis/$siteid/MachineCatalogs/$_/TestReport" -Headers $headers -Verbose).TestResults }
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
        FatalError = $expandedddata | Where-Object { $_.Serverity -like 'FatalError' } | Group-Object -Property TestServiceTarget | Select-Object Name,Count | Sort-Object count -Descending
        Error      = $expandedddata | Where-Object { $_.Serverity -like 'Error' } | Group-Object -Property TestServiceTarget | Select-Object Name,Count | Sort-Object count -Descending
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
    if ($Export -eq 'Host') { $Alldata }


} #end Function
