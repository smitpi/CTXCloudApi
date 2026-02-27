---
document type: cmdlet
external help file: CTXCloudApi-Help.xml
HelpUri: https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Zone
Locale: en-US
Module Name: CTXCloudApi
ms.date: 02/27/2026
PlatyPS schema version: 2024-05-01
title: Get-CTXAPI_Zone
---

# Get-CTXAPI_Zone

## SYNOPSIS

Returns Zone details (handles pagination).

## SYNTAX

### __AllParameterSets

```
Get-CTXAPI_Zone [[-APIHeader] <CTXAPIHeaderObject>] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Returns Zone details from Citrix Cloud CVAD.

## EXAMPLES

### EXAMPLE 1

Get-CTXAPI_Zone -APIHeader $APIHeader

Lists all zones for the tenant.

### EXAMPLE 2

Get-CTXAPI_Zone -APIHeader $APIHeader | Select-Object Name, Enabled, Description

Shows key fields for each zone.

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

### None. Parameters are not accepted from the pipeline.

{{ Fill in the Description }}

## OUTPUTS

### psobject[]
Array of zone objects returned from the CVAD Manage API.

{{ Fill in the Description }}

### System.Management.Automation.PSObject

{{ Fill in the Description }}

## NOTES

## RELATED LINKS

- [](https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Zone)
