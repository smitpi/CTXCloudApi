
<#PSScriptInfo

.VERSION 1.0.0

.GUID 46687284-ec4b-4a37-baa8-a18178864af8

.AUTHOR Pierre Smit

.COMPANYNAME iOCO Tech

.COPYRIGHT

.TAGS ctx

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Created [06/10/2021_21:23] Initital Script Creating

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
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$CustomerId,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$SiteId,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ApiToken,
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


    $headers = @{
        Authorization       = "CwsAuth Bearer=$($ApiToken)"
        'Citrix-CustomerId' = $customerId
        Accept              = 'application/json'
    }

    $data = @()

    if ($SiteTest) {
        Write-Color 'Requesting Site Tests' -Color DarkYellow -ShowTime
        Invoke-WebRequest ([string]::Format("https://api-us.cloud.com/cvadapis/sites/{0}/`$test", $siteid)) -Method Post -Headers $headers -ContentType 'application/json' -ErrorAction SilentlyContinue
        Write-Color 'Sleeping for',' 60sec' -Color Cyan,Yellow -ShowTime
        Start-Sleep 60
        Write-Color 'Retrieving test results' -Color Cyan -ShowTime -NoNewLine
        $data += (Invoke-RestMethod "https://api-us.cloud.com/cvadapis/sites/$siteid/TestReport" -Headers $headers).TestResults
        Write-Color 'Complete' -Color Green -ShowTime
    }

    if ($HypervisorsTest) {
        Write-Color 'Requesting hypervisors Tests' -Color DarkYellow -ShowTime
        (Invoke-RestMethod "https://api.cloud.com/cvadapis/$siteid/hypervisors" -Headers $headers).items.id | ForEach-Object { Invoke-RestMethod "https://api.cloud.com/cvadapis/$siteid/hypervisors/$_/`$test" -Method Post -Headers $headers -ContentType 'application/json' }
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
