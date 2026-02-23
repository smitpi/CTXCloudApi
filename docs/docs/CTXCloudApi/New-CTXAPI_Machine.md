---
document type: cmdlet
external help file: CTXCloudApi-Help.xml
HelpUri: https://smitpi.github.io/CTXCloudApi/New-CTXAPI_Machine
Locale: en-US
Module Name: CTXCloudApi
ms.date: 02/23/2026
PlatyPS schema version: 2024-05-01
title: New-CTXAPI_Machine
---

# New-CTXAPI_Machine

## SYNOPSIS

Creates and adds new machines to a Citrix Cloud Delivery Group.

## SYNTAX

### __AllParameterSets

```
New-CTXAPI_Machine [-APIHeader] <CTXAPIHeaderObject> [-MachineCatalogName] <string>
 [-DeliveryGroupName] <string> [-AmountOfMachines] <int> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

This function provisions one or more new machines in a specified Machine Catalog and adds them to a specified Delivery Group in Citrix Cloud using the CTXCloudApi module.
The function supports verbose output for detailed process tracking.

## EXAMPLES

### EXAMPLE 1

New-CTXAPI_Machine -APIHeader $header -MachineCatalogName "Win10-Catalog" -DeliveryGroupName "Win10-Users" -AmountOfMachines 2 -Verbose

Creates 2 new machines in the "Win10-Catalog" Machine Catalog and adds them to the "Win10-Users" Delivery Group, showing verbose output.

## PARAMETERS

### -AmountOfMachines

The number of machines to create and add to the Delivery Group.

```yaml
Type: Int32
DefaultValue: 0
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 3
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -APIHeader

The authentication header object returned by Connect-CTXAPI, required for all API calls.

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

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- cf
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

### -DeliveryGroupName

The name of the Delivery Group to which the new machines will be added.

```yaml
Type: String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 2
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -MachineCatalogName

The name of the Machine Catalog where new machines will be created.

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

### -WhatIf

Runs the command in a mode that only reports what would happen without performing the actions.

```yaml
Type: SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- wi
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

### System.Object

{{ Fill in the Description }}

## NOTES

## RELATED LINKS

- [](https://smitpi.github.io/CTXCloudApi/New-CTXAPI_Machine)
