---
document type: cmdlet
external help file: CTXCloudApi-Help.xml
HelpUri: https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_MonitorData
Locale: en-US
Module Name: CTXCloudApi
ms.date: 02/27/2026
PlatyPS schema version: 2024-05-01
title: Get-CTXAPI_MonitorData
---

# Get-CTXAPI_MonitorData

## SYNOPSIS

Collect Monitoring OData for other reports.

## SYNTAX

### hours

```
Get-CTXAPI_MonitorData -APIHeader <CTXAPIHeaderObject> [-LastHours <int>]
 [-MonitorDetails <string[]>] [<CommonParameters>]
```

### specific

```
Get-CTXAPI_MonitorData -APIHeader <CTXAPIHeaderObject> [-BeginDate <datetime>] [-EndDate <datetime>]
 [-MonitorDetails <string[]>] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Collects Citrix Monitor OData entities for a specified time window and returns a composite object used by reporting cmdlets.

## EXAMPLES

### EXAMPLE 1

$MonitorData = Get-CTXAPI_MonitorData -APIHeader $APIHeader -LastHours 24

Collects the last 24 hours of Monitor OData and returns a CTXMonitorData object.

### EXAMPLE 2

Get-CTXAPI_MonitorData -APIHeader $APIHeader -BeginDate (Get-Date).AddDays(-2) -EndDate (Get-Date).AddDays(-1) -MonitorDetails Connections,Session

Collects data for a specific date range and includes only Connections and Session entities.

### EXAMPLE 3

Get-CTXAPI_MonitorData -APIHeader $APIHeader -LastHours 48 | Select-Object -ExpandProperty Connections

Expands and lists connection records for the past 48 hours.

## PARAMETERS

### -APIHeader

Header object created by Connect-CTXAPI; contains authentication and request headers.

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

### -BeginDate

Start of the time window when specifying an explicit range.

```yaml
Type: DateTime
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: specific
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -EndDate

End of the time window when specifying an explicit range.

```yaml
Type: DateTime
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: specific
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

Relative time window in hours (e.g., 24, 48).
When specified, BeginDate is now and EndDate is now minus LastHours.

```yaml
Type: Int32
DefaultValue: 0
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: hours
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -MonitorDetails

One or more OData entity names to include.
Default is All.

```yaml
Type: String[]
DefaultValue: All
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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Object (PSTypeName: CTXMonitorData)
Composite PSCustomObject containing Monitor OData entities used by reporting cmdlets.

{{ Fill in the Description }}

## NOTES

## RELATED LINKS

- [](https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_MonitorData)
