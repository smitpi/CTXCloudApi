---
document type: cmdlet
external help file: CTXCloudApi-Help.xml
HelpUri: https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_SiteDetail
Locale: en-US
Module Name: CTXCloudApi
ms.date: 02/26/2026
PlatyPS schema version: 2024-05-01
title: Get-CTXAPI_SiteDetail
---

# Get-CTXAPI_SiteDetail

## SYNOPSIS

Returns details about your CVAD site.

## SYNTAX

### __AllParameterSets

```
Get-CTXAPI_SiteDetail [-APIHeader] <CTXAPIHeaderObject> [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Returns details about your CVAD site (farm) from Citrix Cloud.

## EXAMPLES

### EXAMPLE 1

Get-CTXAPI_SiteDetail -APIHeader $APIHeader

Returns the site details for the current `Citrix-InstanceId`.

### EXAMPLE 2

Get-CTXAPI_SiteDetail -APIHeader $APIHeader | Select-Object Name, FunctionalLevel, LicensingMode

Selects key fields from the site object.

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

### PSCustomObject
Site detail object returned from the CVAD Manage API.

{{ Fill in the Description }}

### System.Management.Automation.PSObject

{{ Fill in the Description }}

## NOTES

## RELATED LINKS

- [](https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_SiteDetail)
