---
document type: cmdlet
external help file: CTXCloudApi-Help.xml
HelpUri: https://smitpi.github.io/CTXCloudApi/New-CTXAPI_Report
Locale: en-US
Module Name: CTXCloudApi
ms.date: 02/23/2026
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
 [-MonitorData <CTXMonitorData>] [-LastHours <int>] [-Export <string>] [-ReportPath <DirectoryInfo>]
 [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

New-CTXAPI_Report generates detailed Citrix Cloud monitoring reports, including resource utilization, connection activity, connection failures, and machine failures.
The function can output reports to the host, export to Excel, or create a styled HTML report with embedded branding.
Data can be sourced from a provided MonitorData object or fetched live via API.

## EXAMPLES

### EXAMPLE 1

New-CTXAPI_Report -APIHeader $header -ReportType All -Export HTML -ReportPath C:\Reports

Generates all available reports and exports them as a styled HTML file to C:\Reports.

### EXAMPLE 2

New-CTXAPI_Report -APIHeader $header -ReportType ResourceUtilization -Export Excel

Exports only the resource utilization report to Excel in the default temp directory.

### EXAMPLE 3

New-CTXAPI_Report -APIHeader $header -MonitorData $data -ReportType ConnectionReport

Outputs the connection report to the host using pre-fetched monitoring data.

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
Valid values: ConnectionReport, ResourceUtilization, ConnectionFailureReport, MachineFailureReport, All.

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

### System.Object

{{ Fill in the Description }}

## NOTES

## RELATED LINKS

{{ Fill in the related links here }}

