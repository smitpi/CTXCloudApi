---
document type: cmdlet
external help file: CTXCloudApi-Help.xml
HelpUri: https://smitpi.github.io/CTXCloudApi/Set-CTXAPI_MachineMaintenanceMode
Locale: en-US
Module Name: CTXCloudApi
ms.date: 02/27/2026
PlatyPS schema version: 2024-05-01
title: Set-CTXAPI_MachineMaintenanceMode
---

# Set-CTXAPI_MachineMaintenanceMode

## SYNOPSIS

Enables or disables Maintenance Mode for Citrix machines via CTX API, with an optional reason.

## SYNTAX

### Set1 (Default)

```
Set-CTXAPI_MachineMaintenanceMode [-APIHeader] <CTXAPIHeaderObject> -Name <string[]>
 -InMaintenanceMode <bool> [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

This function allows you to remotely toggle the Maintenance Mode state of Citrix machines using the CTX API.
You can modify one or more machines by specifying their name, DNS name, or ID.

## EXAMPLES

### EXAMPLE 1

Set-CTXAPI_MachineMaintenanceMode -APIHeader $header -Name "CTX-Machine01" -InMaintenanceMode $true -Reason "Ticket INC-12345: RAM upgrade"

Places the specified Citrix Machine into maintenance mode with an audit reason.

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

### -InMaintenanceMode

Boolean value to set the maintenance mode state ($true to enable, $false to disable).

```yaml
Type: Boolean
DefaultValue: False
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
  IsRequired: true
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

### System.String

{{ Fill in the Description }}

### System.String[]

{{ Fill in the Description }}

## OUTPUTS

### System.Object[]
Returns the API response objects for each machine processed.

{{ Fill in the Description }}

### System.Object

{{ Fill in the Description }}

## NOTES

## RELATED LINKS

{{ Fill in the related links here }}

