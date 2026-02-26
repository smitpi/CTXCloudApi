---
document type: cmdlet
external help file: CTXCloudApi-Help.xml
HelpUri: https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_LowLevelOperation
Locale: en-US
Module Name: CTXCloudApi
ms.date: 02/26/2026
PlatyPS schema version: 2024-05-01
title: Get-CTXAPI_LowLevelOperation
---

# Get-CTXAPI_LowLevelOperation

## SYNOPSIS

Returns details about low-level configuration changes (more detailed).

## SYNTAX

### __AllParameterSets

```
Get-CTXAPI_LowLevelOperation [-APIHeader] <CTXAPIHeaderObject> [-HighLevelID] <string>
 [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Returns details about low-level configuration changes for a specific operation ID from Config Log.

## EXAMPLES

### EXAMPLE 1

$ConfigLog = Get-CTXAPI_ConfigLog -APIHeader $APIHeader -Days 7

$LowLevelOperations = Get-CTXAPI_LowLevelOperation -APIHeader $APIHeader -HighLevelID $ConfigLog[0].id
Retrieves low-level operations for the first high-level operation in the past 7 days.

### EXAMPLE 2

" | Select-Object OperationType, Property, OldValue, NewValue

Shows key fields for each low-level change.

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
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -HighLevelID

Unique id for a config change (from Get-CTXAPI_ConfigLog).

```yaml
Type: String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
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

### None. Parameters are not accepted from the pipeline.

{{ Fill in the Description }}

## OUTPUTS

### System.Object[]
Array of low-level operation objects returned from the CVAD Manage API.

{{ Fill in the Description }}

### System.Object

{{ Fill in the Description }}

## NOTES

## RELATED LINKS

- [](https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_LowLevelOperation)
