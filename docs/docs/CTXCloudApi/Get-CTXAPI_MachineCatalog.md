---
document type: cmdlet
external help file: CTXCloudApi-Help.xml
HelpUri: https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_MachineCatalog
Locale: en-US
Module Name: CTXCloudApi
ms.date: 02/26/2026
PlatyPS schema version: 2024-05-01
title: Get-CTXAPI_MachineCatalog
---

# Get-CTXAPI_MachineCatalog

## SYNOPSIS

Returns details about Machine Catalogs (handles pagination).

## SYNTAX

### __AllParameterSets

```
Get-CTXAPI_MachineCatalog [-APIHeader] <CTXAPIHeaderObject> [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Returns details about Machine Catalogs from Citrix Cloud CVAD.

## EXAMPLES

### EXAMPLE 1

$MachineCatalogs = Get-CTXAPI_MachineCatalog -APIHeader $APIHeader

Retrieves all machine catalogs and stores them for reuse.

### EXAMPLE 2

Get-CTXAPI_MachineCatalog -APIHeader $APIHeader | Select-Object Name, SessionSupport, TotalCount, IsPowerManaged

Lists key catalog fields including session support, total machines, and power management.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None. Parameters are not accepted from the pipeline.

{{ Fill in the Description }}

## OUTPUTS

### PSCustomObject[]
Array of machine catalog objects returned from the CVAD Manage API.

{{ Fill in the Description }}

### System.Management.Automation.PSObject

{{ Fill in the Description }}

## NOTES

## RELATED LINKS

- [](https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_MachineCatalog)
