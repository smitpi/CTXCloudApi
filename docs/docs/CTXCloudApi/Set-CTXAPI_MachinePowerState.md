---
document type: cmdlet
external help file: CTXCloudApi-Help.xml
HelpUri: https://smitpi.github.io/CTXCloudApi/Set-CTXAPI_MachinePowerState
Locale: en-US
Module Name: CTXCloudApi
ms.date: 02/26/2026
PlatyPS schema version: 2024-05-01
title: Set-CTXAPI_MachinePowerState
---

# Set-CTXAPI_MachinePowerState

## SYNOPSIS

Starts, shuts down, restarts, or logs off Citrix machines via CTX API.

## SYNTAX

### __AllParameterSets

```
Set-CTXAPI_MachinePowerState [-APIHeader] <CTXAPIHeaderObject> [-Name <string[]>]
 [-PowerAction <string>] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

This function allows you to remotely control the power state of Citrix machines using the CTX API.
You can start, shut down, restart, or log off one or more machines by specifying their name, DNS name, or ID.

## EXAMPLES

### EXAMPLE 1

Set-CTXAPI_MachinePowerState -APIHeader $header -Name "CTX-Machine01" -PowerAction Start

Starts the specified Citrix Machine.

### EXAMPLE 2

Set-CTXAPI_MachinePowerState -APIHeader $header -Name "CTX-Machine01","CTX-Machine02" -PowerAction Shutdown

Shuts down multiple Citrix Machines.

## PARAMETERS

### -APIHeader

The CTX API authentication header object (type CTXAPIHeaderObject) required for API calls.

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

The name, DNS name, or ID of the Citrix Machine(s) to target.
Accepts an array of strings.

```yaml
Type: String[]
DefaultValue: ''
SupportsWildcards: false
Aliases:
- DNSName
- Id
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: true
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: true
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -PowerAction

The desired power action to perform.
Valid values: Start, Shutdown, Restart, Logoff.

```yaml
Type: String
DefaultValue: ''
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

### System.String[]

{{ Fill in the Description }}

## OUTPUTS

### System.Object[]. Returns the API response objects for each machine processed.

{{ Fill in the Description }}

### System.Object

{{ Fill in the Description }}

## NOTES

## RELATED LINKS

{{ Fill in the related links here }}

