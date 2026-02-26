---
document type: cmdlet
external help file: CTXCloudApi-Help.xml
HelpUri: https://smitpi.github.io/CTXCloudApi/Test-CTXAPI_Header
Locale: en-US
Module Name: CTXCloudApi
ms.date: 02/26/2026
PlatyPS schema version: 2024-05-01
title: Test-CTXAPI_Header
---

# Test-CTXAPI_Header

## SYNOPSIS

Checks that the connection is still valid, and the token hasn't expired.

## SYNTAX

### __AllParameterSets

```
Test-CTXAPI_Header [[-APIHeader] <CTXAPIHeaderObject>] [-AutoRenew] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Checks that the connection is still valid, and the token hasn't expired.

## EXAMPLES

### EXAMPLE 1

Test-CTXAPI_Header -APIHeader $APIHeader -AutoRenew

## PARAMETERS

### -APIHeader

Use Connect-CTXAPI to create headers.

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

### -AutoRenew

If the token has expired, it will connect and renew the variable.

```yaml
Type: SwitchParameter
DefaultValue: False
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

### System.Boolean

{{ Fill in the Description }}

## NOTES

## RELATED LINKS

{{ Fill in the related links here }}

