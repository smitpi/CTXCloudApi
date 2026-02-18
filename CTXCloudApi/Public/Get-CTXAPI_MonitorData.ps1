
<#PSScriptInfo

.VERSION 1.1.8

.GUID dbc0ddb1-1785-45ea-b3ec-6ef8d0158050

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
 Collect Monitoring OData for other reports. 

#> 



<#
.SYNOPSIS
Collect Monitoring OData for other reports.

.DESCRIPTION
Collects Citrix Monitor OData entities for a specified time window and returns a composite object used by reporting cmdlets.

.PARAMETER APIHeader
Header object created by Connect-CTXAPI; contains authentication and request headers.

.PARAMETER LastHours
Relative time window in hours (e.g., 24, 48). When specified, BeginDate is now and EndDate is now minus LastHours.

.PARAMETER BeginDate
Start of the time window when specifying an explicit range.

.PARAMETER EndDate
End of the time window when specifying an explicit range.

.PARAMETER MonitorDetails
One or more OData entity names to include. Default is All.

.EXAMPLE
$MonitorData = Get-CTXAPI_MonitorData -APIHeader $APIHeader -LastHours 24
Collects the last 24 hours of Monitor OData and returns a CTXMonitorData object.

.EXAMPLE
Get-CTXAPI_MonitorData -APIHeader $APIHeader -BeginDate (Get-Date).AddDays(-2) -EndDate (Get-Date).AddDays(-1) -MonitorDetails Connections,Session
Collects data for a specific date range and includes only Connections and Session entities.

.EXAMPLE
Get-CTXAPI_MonitorData -APIHeader $APIHeader -LastHours 48 | Select-Object -ExpandProperty Connections
Expands and lists connection records for the past 48 hours.

.INPUTS
None

.OUTPUTS
System.Object (PSTypeName: CTXMonitorData)
Composite PSCustomObject containing Monitor OData entities used by reporting cmdlets.

.LINK
https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_MonitorData
#>

function Get-CTXAPI_MonitorData {
    [Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_MonitorData')]
    param(
        [Parameter(Mandatory = $true)]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $false, ParameterSetName = 'hours')]
        [int]$LastHours,
        [Parameter(Mandatory = $false, ParameterSetName = 'specific')]
        [datetime]$BeginDate,
        [Parameter(Mandatory = $false, ParameterSetName = 'specific')]
        [datetime]$EndDate,
        [ValidateSet('ApplicationActivitySummaries', 
            'ApplicationActivitySummaries',
            'ApplicationInstances',
            'Applications',
            'Catalogs',
            'ConnectionFailureLogs',
            'Connections',
            'DesktopGroups',
            'DesktopOSDesktopSummaries',
            'FailureLogSummaries',
            'Hypervisors',
            'LogOnMetrics',
            'LogOnSummaries',
            'MachineCosts',
            'MachineCostSavingsSummaries',
            'MachineFailureLogs',
            'MachineMetric',
            'Machines',
            'ReconnectSummaries',
            'ResourceUtilization',
            'ResourceUtilizationSummary',
            'ServerOSDesktopSummaries',
            'Session',
            'SessionActivitySummaries',
            'SessionAutoReconnects',
            'SessionMetrics',
            'SessionMetricsLatest',
            'Users',
            'All')]
        [string[]]$MonitorDetails = 'All'
    )
    
    Write-Verbose "[$(Get-Date -Format HH:mm:ss) BEGIN] Starting $($myinvocation.mycommand)"
    if ($PSCmdlet.ParameterSetName -eq 'hours' -and $null -ne $LastHours) {
        $BeginDate = Get-Date
        $EndDate = (Get-Date).AddHours(-$LastHours)
    } elseif ($PSCmdlet.ParameterSetName -eq 'specific') {
        if ($null -eq $BeginDate) { throw 'BeginDate is required when LastHours is not specified' }
        if ($null -eq $EndDate) { throw 'EndDate is required when LastHours is not specified' }
    } else {
        throw 'Specify either -LastHours or both -BeginDate and -EndDate.'
    }

    $BeginDateStr = $BeginDate.ToString('yyyy-MM-ddTHH:mm:ss.ffffZ')
    $EndDateStr = $EndDate.ToString('yyyy-MM-ddTHH:mm:ss.ffffZ')

    # Initialize all potential datasets to avoid strict-mode errors when not selected
    $ApplicationActivitySummaries = $null
    $ApplicationInstances = $null
    $Applications = $null
    $Catalogs = $null
    $ConnectionFailureLogs = $null
    $Connections = $null
    $DesktopGroups = $null
    $DesktopOSDesktopSummaries = $null
    $FailureLogSummaries = $null
    $Hypervisors = $null
    $LogOnMetrics = $null
    $LogOnSummaries = $null
    $MachineCosts = $null
    $MachineCostSavingsSummaries = $null
    $MachineFailureLogs = $null
    $MachineMetric = $null
    $Machines = $null
    $ReconnectSummaries = $null
    $ResourceUtilization = $null
    $ResourceUtilizationSummary = $null
    $ServerOSDesktopSummaries = $null
    $SessionActivitySummaries = $null
    $SessionAutoReconnects = $null
    $Sessions = $null
    $SessionMetrics = $null
    $SessionMetricsLatest = $null
    $Users = $null
    
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'ApplicationActivitySummaries')) { $ApplicationActivitySummaries = Export-Odata -URI ('https://api.cloud.com/monitorodata/ApplicationActivitySummaries?$filter=(Granularity eq 60 and ModifiedDate ge ' + $EndDateStr + ' and ModifiedDate le ' + $BeginDateStr + ' )') -headers $APIHeader.headers }
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'ApplicationInstances')) { $ApplicationInstances = Export-Odata -URI ('https://api.cloud.com/monitorodata/ApplicationInstances?$filter=(ModifiedDate ge ' + $EndDateStr + ' and ModifiedDate le ' + $BeginDateStr + ' )') -headers $APIHeader.headers }
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'Applications')) {$Applications = Export-Odata -URI ('https://api.cloud.com/monitorodata/Applications') -headers $APIHeader.headers                                                                                                                                }
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'Catalogs')) {$Catalogs = Export-Odata -URI ('https://api.cloud.com/monitorodata/Catalogs') -headers $APIHeader.headers}
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'ConnectionFailureLogs')) {$ConnectionFailureLogs = Export-Odata -URI ('https://api.cloud.com/monitorodata/ConnectionFailureLogs?$filter=(ModifiedDate ge ' + $EndDateStr + ' and ModifiedDate le ' + $BeginDateStr + ' )') -headers $APIHeader.headers}
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'Connections')) {$Connections = Export-Odata -URI ('https://api.cloud.com/monitorodata/Connections?$filter=(ModifiedDate ge ' + $EndDateStr + ' and ModifiedDate le ' + $BeginDateStr + ' )') -headers $APIHeader.headers}
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'DesktopGroups')) {$DesktopGroups = Export-Odata -URI ('https://api.cloud.com/monitorodata/DesktopGroups') -headers $APIHeader.headers}
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'DesktopOSDesktopSummaries')) {$DesktopOSDesktopSummaries = Export-Odata -URI ('https://api.cloud.com/monitorodata/DesktopOSDesktopSummaries?$filter=(Granularity eq 60 and ModifiedDate ge ' + $EndDateStr + ' and ModifiedDate le ' + $BeginDateStr + ' )') -headers $APIHeader.headers}
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'FailureLogSummaries')) {$FailureLogSummaries = Export-Odata -URI ('https://api.cloud.com/monitorodata/FailureLogSummaries?$filter=(ModifiedDate ge ' + $EndDateStr + ' )') -headers $APIHeader.headers}
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'Hypervisors')) {$Hypervisors = Export-Odata -URI ('https://api.cloud.com/monitorodata/Hypervisors') -headers $APIHeader.headers}
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'LogOnMetrics')) {$LogOnMetrics = Export-Odata -URI ('https://api.cloud.com/monitorodata/LogOnMetrics?$filter=(UserInitStartDate ge ' + $EndDateStr + ' and UserInitStartDate le ' + $BeginDateStr + ' )') -headers $APIHeader.headers}
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'LogOnSummaries')) {$LogOnSummaries = Export-Odata -URI ('https://api.cloud.com/monitorodata/LogOnSummaries?$filter=(ModifiedDate ge ' + $EndDateStr + ' and ModifiedDate le ' + $BeginDateStr + ' )') -headers $APIHeader.headers}
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'MachineCosts')) {$MachineCosts = Export-Odata -URI ('https://api.cloud.com/monitorodata/MachineCosts') -headers $APIHeader.headers}
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'MachineCostSavingsSummaries')) {$MachineCostSavingsSummaries = Export-Odata -URI ('https://api.cloud.com/monitorodata/MachineCostSavingsSummaries') -headers $APIHeader.headers}
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'MachineFailureLogs')) {$MachineFailureLogs = Export-Odata -URI ('https://api.cloud.com/monitorodata/MachineFailureLogs?$filter=(ModifiedDate ge ' + $EndDateStr + ' and ModifiedDate le ' + $BeginDateStr + ' )') -headers $APIHeader.headers}
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'MachineMetric')) {$MachineMetric = Export-Odata -URI ('https://api.cloud.com/monitorodata/MachineMetric?$filter=(CollectedDate ge ' + $EndDateStr + ' and CollectedDate le ' + $BeginDateStr + ' )') -headers $APIHeader.headers}
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'Machines')) {$Machines = Export-Odata -URI ('https://api.cloud.com/monitorodata/Machines') -headers $APIHeader.headers}
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'ReconnectSummaries')) {$ReconnectSummaries = Export-Odata -URI ('https://api.cloud.com/monitorodata/ReconnectSummaries') -headers $APIHeader.headers}
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'ResourceUtilization')) {$ResourceUtilization = Export-Odata -URI ('https://api.cloud.com/monitorodata/ResourceUtilization?$filter=(ModifiedDate ge ' + $EndDateStr + ' and ModifiedDate le ' + $BeginDateStr + ' )') -headers $APIHeader.headers}
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'ResourceUtilizationSummary')) {$ResourceUtilizationSummary = Export-Odata -URI ('https://api.cloud.com/monitorodata/ResourceUtilizationSummary?$filter=(ModifiedDate ge ' + $EndDateStr + ' and ModifiedDate le ' + $BeginDateStr + ' )') -headers $APIHeader.headers}
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'ServerOSDesktopSummaries')) {$ServerOSDesktopSummaries = Export-Odata -URI ('https://api.cloud.com/monitorodata/ServerOSDesktopSummaries?$filter=(Granularity eq 60 and ModifiedDate ge ' + $EndDateStr + ' and ModifiedDate le ' + $BeginDateStr + ' )') -headers $APIHeader.headers}
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'SessionActivitySummaries')) {$SessionActivitySummaries = Export-Odata -URI ('https://api.cloud.com/monitorodata/SessionActivitySummaries?$filter=(Granularity eq 60 and ModifiedDate ge ' + $EndDateStr + ' and ModifiedDate le ' + $BeginDateStr + ' )') -headers $APIHeader.headers}
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'SessionAutoReconnects')) {$SessionAutoReconnects = Export-Odata -URI ('https://api.cloud.com/monitorodata/SessionAutoReconnects?$filter=(CreatedDate ge ' + $EndDateStr + ' and CreatedDate le ' + $BeginDateStr + ' )') -headers $APIHeader.headers}
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'Sessions')) {$Sessions = Export-Odata -URI ('https://api.cloud.com/monitorodata/Sessions?$filter=(ModifiedDate ge ' + $EndDateStr + ' and ModifiedDate le ' + $BeginDateStr + ' )') -headers $APIHeader.headers}
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'SessionMetrics')) {$SessionMetrics = Export-Odata -URI ('https://api.cloud.com/monitorodata/SessionMetrics?$filter=(CollectedDate ge ' + $EndDateStr + ' and CollectedDate le ' + $BeginDateStr + ' )') -headers $APIHeader.headers}
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'SessionMetricsLatest')) {$SessionMetricsLatest = Export-Odata -URI ('https://api.cloud.com/monitorodata/SessionMetricsLatest?$filter=(CreatedDate ge ' + $EndDateStr + ' and CreatedDate le ' + $BeginDateStr + ' )') -headers $APIHeader.headers -verbose}
    if (($MonitorDetails -contains 'All') -or ($MonitorDetails -contains 'Users')) {$Users = Export-Odata -URI ('https://api.cloud.com/monitorodata/Users') -headers $APIHeader.headers}

    Write-Verbose "[$(Get-Date -Format HH:mm:ss)] Building composite object with retrieved datasets..."
    $datasets = [pscustomobject]@{
        PSTypeName = 'CTXMonitorData'
    }
    if ($null -ne $ApplicationActivitySummaries) { $datasets | Add-Member -NotePropertyName 'ApplicationActivitySummaries' -NotePropertyValue $ApplicationActivitySummaries }
    if ($null -ne $ApplicationInstances) { $datasets | Add-Member -NotePropertyName 'ApplicationInstances' -NotePropertyValue $ApplicationInstances }
    if ($null -ne $Applications) { $datasets | Add-Member -NotePropertyName 'Applications' -NotePropertyValue $Applications }
    if ($null -ne $Catalogs) { $datasets | Add-Member -NotePropertyName 'Catalogs' -NotePropertyValue $Catalogs }
    if ($null -ne $ConnectionFailureLogs) { $datasets | Add-Member -NotePropertyName 'ConnectionFailureLogs' -NotePropertyValue $ConnectionFailureLogs }
    if ($null -ne $Connections) { $datasets | Add-Member -NotePropertyName 'Connections' -NotePropertyValue $Connections }
    if ($null -ne $DesktopGroups) { $datasets | Add-Member -NotePropertyName 'DesktopGroups' -NotePropertyValue $DesktopGroups }
    if ($null -ne $DesktopOSDesktopSummaries) { $datasets | Add-Member -NotePropertyName 'DesktopOSDesktopSummaries' -NotePropertyValue $DesktopOSDesktopSummaries }
    if ($null -ne $FailureLogSummaries) { $datasets | Add-Member -NotePropertyName 'FailureLogSummaries' -NotePropertyValue $FailureLogSummaries }
    if ($null -ne $Hypervisors) { $datasets | Add-Member -NotePropertyName 'Hypervisors' -NotePropertyValue $Hypervisors }
    if ($null -ne $LogOnMetrics) { $datasets | Add-Member -NotePropertyName 'LogOnMetrics' -NotePropertyValue $LogOnMetrics }
    if ($null -ne $LogOnSummaries) { $datasets | Add-Member -NotePropertyName 'LogOnSummaries' -NotePropertyValue $LogOnSummaries }
    if ($null -ne $MachineCosts) { $datasets | Add-Member -NotePropertyName 'MachineCosts' -NotePropertyValue $MachineCosts }
    if ($null -ne $MachineCostSavingsSummaries) { $datasets | Add-Member -NotePropertyName 'MachineCostSavingsSummaries' -NotePropertyValue $MachineCostSavingsSummaries }
    if ($null -ne $MachineFailureLogs) { $datasets | Add-Member -NotePropertyName 'MachineFailureLogs' -NotePropertyValue $MachineFailureLogs }
    if ($null -ne $MachineMetric) { $datasets | Add-Member -NotePropertyName 'MachineMetric' -NotePropertyValue $MachineMetric }
    if ($null -ne $Machines) { $datasets | Add-Member -NotePropertyName 'Machines' -NotePropertyValue $Machines }
    if ($null -ne $ReconnectSummaries) { $datasets | Add-Member -NotePropertyName 'ReconnectSummaries' -NotePropertyValue $ReconnectSummaries }
    if ($null -ne $ResourceUtilization) { $datasets | Add-Member -NotePropertyName 'ResourceUtilization' -NotePropertyValue $ResourceUtilization }
    if ($null -ne $ResourceUtilizationSummary) { $datasets | Add-Member -NotePropertyName 'ResourceUtilizationSummary' -NotePropertyValue $ResourceUtilizationSummary }
    if ($null -ne $ServerOSDesktopSummaries) { $datasets | Add-Member -NotePropertyName 'ServerOSDesktopSummaries' -NotePropertyValue $ServerOSDesktopSummaries }
    if ($null -ne $SessionActivitySummaries) { $datasets | Add-Member -NotePropertyName 'SessionActivitySummaries' -NotePropertyValue $SessionActivitySummaries }
    if ($null -ne $SessionAutoReconnects) { $datasets | Add-Member -NotePropertyName 'SessionAutoReconnects' -NotePropertyValue $SessionAutoReconnects }
    if ($null -ne $Sessions) { $datasets | Add-Member -NotePropertyName 'Sessions' -NotePropertyValue $Sessions }
    if ($null -ne $SessionMetrics) { $datasets | Add-Member -NotePropertyName 'SessionMetrics' -NotePropertyValue $SessionMetrics }
    if ($null -ne $SessionMetricsLatest) { $datasets | Add-Member -NotePropertyName 'SessionMetricsLatest' -NotePropertyValue $SessionMetricsLatest }
    if ($null -ne $Users) { $datasets | Add-Member -NotePropertyName 'Users' -NotePropertyValue $Users }

    return $datasets
} #end Function


#MachineCostSavingsSummaries  = Export-Odata -URI ('https://api.cloud.com/monitorodata/MachineCostSavingsSummaries?$apply=aggregate(TotalAmountSaved with sum as TotalAmountSavedSum)') -headers $APIHeader.headers
