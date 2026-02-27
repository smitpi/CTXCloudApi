---
document type: cmdlet
external help file: CTXCloudApi-Help.xml
HelpUri: https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_CloudService
Locale: en-US
Module Name: CTXCloudApi
ms.date: 02/27/2026
PlatyPS schema version: 2024-05-01
title: Get-CTXAPI_CloudService
---

# Get-CTXAPI_CloudService

## SYNOPSIS

Returns details about cloud services and subscription.

## SYNTAX

### __AllParameterSets

```
Get-CTXAPI_CloudService [-APIHeader] <CTXAPIHeaderObject> [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Returns details about Citrix Cloud services and subscription state from the `serviceStates` endpoint.

## EXAMPLES

### EXAMPLE 1

Get-CTXAPI_CloudService -APIHeader $APIHeader | Select-Object serviceName, state, lastUpdated

Lists each service name, its current state, and the last update time.

### EXAMPLE 2

Get-CTXAPI_CloudService -APIHeader $APIHeader | Where-Object { $_.state -ne 'Enabled' }

Shows services that are not currently enabled.

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
Array of service state objects returned from the Core Workspaces API.

{{ Fill in the Description }}

### System.Management.Automation.PSObject

{{ Fill in the Description }}

## NOTES

## RELATED LINKS

- [](https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_CloudService)
