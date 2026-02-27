---
document type: cmdlet
external help file: CTXCloudApi-Help.xml
HelpUri: https://smitpi.github.io/CTXCloudApi/New-CTXAPI_Report
Locale: en-US
Module Name: CTXCloudApi
ms.date: 02/27/2026
PlatyPS schema version: 2024-05-01
title: New-CTXAPI_Report
---

# New-CTXAPI_Report

## SYNOPSIS

Generate Citrix Cloud monitoring reports in multiple formats (Host, Excel, HTML).

## SYNTAX

### Got odata

```
New-CTXAPI_Report -APIHeader <CTXAPIHeaderObject> -ReportType <string[]>
 [-MonitorData <CTXMonitorData>] [-Export <string>] [-ReportPath <DirectoryInfo>]
 [<CommonParameters>]
```

### Needdata

```
New-CTXAPI_Report -APIHeader <CTXAPIHeaderObject> -ReportType <string[]> [-LastHours <int>]
 [-Export <string>] [-ReportPath <DirectoryInfo>] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

New-CTXAPI_Report generates detailed Citrix Cloud monitoring reports, including resource utilization, connection activity, connection failures, session reports, machine failures, and login duration analytics.
The function can output reports to the host, export to Excel, or create a styled HTML report with embedded branding.
Data can be sourced from a provided MonitorData object or fetched live via API.

## EXAMPLES

### EXAMPLE 1

New-CTXAPI_Report -APIHeader $header -ReportType All -Export HTML -ReportPath C:\Reports

Generates all available reports and exports them as a styled HTML file to C:\Reports.

### EXAMPLE 2

New-CTXAPI_Report -APIHeader $header -ReportType LoginDurationReport -Export Excel -ReportPath C:\Reports

Generates per-hour and total login duration reports and exports them to Excel.

### EXAMPLE 3

New-CTXAPI_Report -APIHeader $header -ReportType SessionReport -Export Host

Returns session analytics to the host (console output).

## PARAMETERS

### -APIHeader

The authentication header object for Citrix Cloud API requests.
Required for all operations.

```yaml
Type: Object
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Export

Specifies the output format.
Valid values: Host (default), Excel, HTML.

```yaml
Type: String
DefaultValue: Host
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -LastHours

Optional.
Number of hours of historical data to include (default: 24).
Used only if MonitorData is not provided.

```yaml
Type: Int32
DefaultValue: 24
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Needdata
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -MonitorData

Optional.
Pre-fetched monitoring data object.
If not provided, the function retrieves data using Get-CTXAPI_MonitorData.

```yaml
Type: Object
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Got odata
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ReportPath

Directory path for exported reports (Excel/HTML).
Defaults to $env:TEMP.
Must exist.

```yaml
Type: DirectoryInfo
DefaultValue: $env:temp
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ReportType

Specifies which report(s) to generate.
Valid values:
 - ConnectionFailureReport: Details on failed connection attempts.
 - MachineFailureReport: Details on machine failures and fault states.
 - SessionReport: Session-level analytics and metrics.
 - MachineReport: Machine resource utilization and status.
 - LoginDurationReport: Per-hour and total login duration breakdowns.
 - All: All available reports.

```yaml
Type: String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### PSCustomObject containing one or more of the following properties

{{ Fill in the Description }}

### System.Object

{{ Fill in the Description }}

## NOTES

Requires the ImportExcel and PSHTML modules for Excel and HTML export functionality.
ReportPath must exist for file exports.


## RELATED LINKS

{{ Fill in the related links here }}

