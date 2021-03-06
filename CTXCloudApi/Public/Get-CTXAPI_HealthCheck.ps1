
<#PSScriptInfo

.VERSION 1.1.5

.GUID 9d297a8a-96ab-467a-ba68-f162937cc868

.AUTHOR Pierre Smit

.COMPANYNAME HTPCZA Tech

.COPYRIGHT

.TAGS api Citrix ctx cvad ps

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Created [28/05/2021_15:41] Initial Script Creating
Updated [05/10/2021_21:22] Module Info Updated
Updated [07/10/2021_13:28] Script info updated for module
Updated [03/11/2021_19:17] Info Update
Updated [06/11/2021_16:48] Using the new api
Updated [14/11/2021_07:05] Added more functions

.PRIVATEDATA

#>

#Requires -Module ImportExcel
#Requires -Module PSWriteHTML
#Requires -Module PSWriteColor



<#

.DESCRIPTION
Run report to show useful information

#>




<#
.SYNOPSIS
Show useful information for daily health check

.DESCRIPTION
Show useful information for daily health check

.PARAMETER APIHeader
Use Connect-CTXAPI to create headers

.PARAMETER region
Your Cloud instance hosted region.

.PARAMETER ReportPath
Destination folder for the exported report.

.EXAMPLE
Get-CTXAPI_HealthCheck -APIHeader $APIHeader -region eu -ReportPath C:\Temp

#>

Function Get-CTXAPI_HealthCheck {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_HealthCheck')]
    PARAM(
        [Parameter(Mandatory = $true)]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('us', 'eu', 'ap-s')]
        [string]$region,
        [ValidateScript( { (Test-Path $_) })]
        [string]$ReportPath = $env:temp
    )
    #######################
    #region Get data
    #######################

    Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) [Processing] Config Log"
    $configlog = Get-CTXAPI_ConfigLog -APIHeader $APIHeader -Days 7 | Group-Object -Property text | Select-Object count, name | Sort-Object -Property count -Descending | Select-Object -First 5

    Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) [Processing] Delivery Groups"
    $DeliveryGroups = Get-CTXAPI_DeliveryGroups -APIHeader $APIHeader | Select-Object Name, DeliveryType, DesktopsAvailable, DesktopsDisconnected, DesktopsFaulted, DesktopsNeverRegistered, DesktopsUnregistered, InMaintenanceMode, IsBroken, RegisteredMachines, SessionCount

    $MonitorData = Get-CTXAPI_MonitorData -APIHeader $APIHeader -region $region -hours 24

    Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) [Processing] Connection Report"
    $ConnectionReport = Get-CTXAPI_ConnectionReport -MonitorData $MonitorData
    $connectionRTT = $ConnectionReport | Sort-Object -Property AVG_ICA_RTT -Descending -Unique | Select-Object -First 5 FullName, ClientVersion, ClientAddress, AVG_ICA_RTT
    $connectionLogon = $ConnectionReport | Sort-Object -Property LogOnDuration -Descending -Unique | Select-Object -First 5 FullName, ClientVersion, ClientAddress, LogOnDuration

    Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) [Processing] Resource Utilization"
    $ResourceUtilization = Get-CTXAPI_ResourceUtilization -MonitorData $MonitorData

    Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) [Processing] Failure Report"
    $ConnectionFailureReport = Get-CTXAPI_FailureReport -MonitorData $MonitorData -FailureType Connection
    $MachineFailureReport = Get-CTXAPI_FailureReport -MonitorData $MonitorData -FailureType Machine | Select-Object Name, IP, OSType, FailureStartDate, FailureEndDate, FaultState


    Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) [Processing] Sessions"
    $sessions = Get-CTXAPI_Sessions -APIHeader $APIHeader
    $sessioncount = [PSCustomObject]@{
        Connected         = ($sessions | Where-Object { $_.state -like 'active' }).count
        Disconnected      = ($sessions | Where-Object { $_.state -like 'Disconnected' }).count
        ConnectionFailure = $ConnectionFailureReport.count
        MachineFailure    = $MachineFailureReport.count
    }

    Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) Machines"
    $vdauptime = Get-CTXAPI_VDAUptime -APIHeader $APIHeader
    # $machinecount = [PSCustomObject]@{
    #     Inmaintenance = ($vdauptime | Where-Object { $_.InMaintenanceMode -like 'true' }).count
    #     DesktopCount  = ($vdauptime | Where-Object { $_.OSType -like 'Windows 10' }).count
    #     ServerCount   = ($vdauptime | Where-Object { $_.OSType -notlike 'Windows 10' }).count
    #     AgentVersions = ($vdauptime | Group-Object -Property AgentVersion).count
    #     NeedsReboot   = ($vdauptime | Where-Object { $_.days -gt 7 }).count
    # }

    Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) Cloud Connectors"
    $Locations = Get-CTXAPI_ResourceLocations -APIHeader $APIHeader
    $CConnector = Get-CTXAPI_CloudConnectors -APIHeader $APIHeader | ForEach-Object {
        $loc = $_.location
        [PSCustomObject]@{
            fqdn            = $_.fqdn
            location        = ($Locations | Where-Object { $_.id -like $loc }).name
            status          = $_.status
            currentVersion  = $_.currentVersion
            versionState    = $_.versionState
            lastContactDate = (Get-Date ([datetime]$_.lastContactDate) -Format 'yyyy-MM-dd HH:mm')
            inMaintenance   = $_.inMaintenance
        }
    }

    Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) Cloud Site Tests"
    $testResult = Get-CTXAPI_Tests -APIHeader $APIHeader -SiteTest -HypervisorsTest -DeliveryGroupsTest -MachineCatalogsTest
    $testReport = $testResult.Alldata | Where-Object { $_.Serverity -notlike $null } | Sort-Object -Property TestScope
    #endregion

    #######################
    #region Building HTML the report
    #######################
    Write-Verbose "$((Get-Date -Format HH:mm:ss).ToString()) [Proccessing] Building HTML Page"
    [string]$HTMLReportname = $ReportPath + "\XD_HealthChecks-$($APIHeader.CustomerName)-" + (Get-Date -Format yyyy.MM.dd-HH.mm) + '.html'

    $HeadingText = $($APIHeader.CustomerName) + ' | Report | ' + (Get-Date -Format dd) + ' ' + (Get-Date -Format MMMM) + ',' + (Get-Date -Format yyyy) + ' ' + (Get-Date -Format HH:mm)

    New-HTML -TitleText "$CustomerId Report" -FilePath $HTMLReportname -ShowHTML {
        New-HTMLLogo -RightLogoString $CTXAPI_LogoURL
        New-HTMLHeading -Heading h1 -HeadingText $HeadingText -Color Black
        New-HTMLSection @SectionSettings -Content {
            New-HTMLSection -HeaderText 'Session States' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $sessioncount }
        }
        New-HTMLSection @SectionSettings -Content {
            New-HTMLSection -HeaderText 'Cloud Connectors' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $CConnector }
            New-HTMLSection -HeaderText 'Test Summary' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $testResult.Summary }
        }
        New-HTMLSection @SectionSettings -Content {
            New-HTMLSection -HeaderText 'Test Result: Fatal Errors' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $testResult.FatalError }
            New-HTMLSection -HeaderText 'Test Result: Errors' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $testResult.Error }
        }
        New-HTMLSection @SectionSettings -Content {
            New-HTMLSection -HeaderText 'Test Result: Detailed' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $testReport }
        }
        New-HTMLSection @SectionSettings -Content {
            New-HTMLSection -HeaderText 'Top 5 RTT Sessions' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $connectionRTT }
            New-HTMLSection -HeaderText 'Top 5 Logon Duration' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $connectionLogon }
        }
        New-HTMLSection @SectionSettings -Content {
            New-HTMLSection -HeaderText 'Connection Failures' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $ConnectionFailureReport }
            New-HTMLSection -HeaderText 'Machine Failures' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $MachineFailureReport }
        }
        New-HTMLSection @SectionSettings -Content {
            New-HTMLSection -HeaderText 'Config Changes' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $configlog }
        }
        New-HTMLSection @SectionSettings -Content {
            New-HTMLSection -HeaderText 'Delivery Groups' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $DeliveryGroups }
        }
        New-HTMLSection @SectionSettings -Content {
            New-HTMLSection -HeaderText 'VDI Uptimes' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $vdauptime }
        }
        New-HTMLSection @SectionSettings -Content {
            New-HTMLSection -HeaderText 'Resource Utilization' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $ResourceUtilization }
        }
    }
    #endregion
    trap {
        Write-Warning "Failed to generate report:$($_)"
        continue
    }

} #end Function
