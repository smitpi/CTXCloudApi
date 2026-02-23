---
document type: cmdlet
external help file: CTXCloudApi-Help.xml
HelpUri: https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Machine
Locale: en-US
Module Name: CTXCloudApi
ms.date: 02/23/2026
PlatyPS schema version: 2024-05-01
title: Get-CTXAPI_Machine
---

# Get-CTXAPI_Machine

## SYNOPSIS

Returns details about VDA machines (handles pagination).

## SYNTAX

### __AllParameterSets

```
Get-CTXAPI_Machine [-APIHeader] <CTXAPIHeaderObject> [[-Name] <string[]>] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Returns details about VDA machines from Citrix Cloud CVAD.

## EXAMPLES

### EXAMPLE 1

$machines = Get-CTXAPI_Machine -APIHeader $APIHeader

Retrieves all machines and stores them for reuse.

### EXAMPLE 2

Get-CTXAPI_Machine -APIHeader $APIHeader | Select-Object DnsName, IPAddress, OSType, RegistrationState

Lists key machine fields for quick inspection.

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

### -Name

{{ Fill Name Description }}

```yaml
Type: String[]
DefaultValue: ''
SupportsWildcards: false
Aliases:
- DNSName
- Id
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: false
  ValueFromPipeline: true
  ValueFromPipelineByPropertyName: true
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

### System.String[]

{{ Fill in the Description }}

## OUTPUTS

### PSCustomObject[]
Array of machine objects returned from the CVAD Manage API.

{{ Fill in the Description }}

### System.Management.Automation.PSObject

{{ Fill in the Description }}

## NOTES

## RELATED LINKS

- [](https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Machine)
