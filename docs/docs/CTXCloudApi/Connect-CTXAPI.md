---
document type: cmdlet
external help file: CTXCloudApi-Help.xml
HelpUri: https://smitpi.github.io/CTXCloudApi/Connect-CTXAPI
Locale: en-US
Module Name: CTXCloudApi
ms.date: 02/27/2026
PlatyPS schema version: 2024-05-01
title: Connect-CTXAPI
---

# Connect-CTXAPI

## SYNOPSIS

Connects to Citrix Cloud and creates required API headers.

## SYNTAX

### __AllParameterSets

```
Connect-CTXAPI [-Customer_Id] <string> [-Client_Id] <string> [-Client_Secret] <securestring>
 [-Customer_Name] <string> [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Authenticates against Citrix Cloud using `Client_Id` and `Client_Secret`, resolves the CVAD `Citrix-InstanceId`, and constructs headers for subsequent CTXCloudApi requests.
Returns a `CTXAPIHeaderObject` containing `CustomerName`, `TokenExpireAt` (about 1 hour), `CTXAPI` (ids), and `headers`.

## EXAMPLES

### EXAMPLE 1

$splat = @{

Customer_Id = "xxx"
	Client_Id = "xxx-xxx-xxx-xxx"
	Client_Secret = "yyyyyy=="
	Customer_Name = 'HomeLab'
}
$APIHeader = Connect-CTXAPI @splat

### EXAMPLE 2

Connect-CTXAPI -Customer_Id "xxx" -Client_Id "xxx-xxx" -Client_Secret "yyyyyy==" -Customer_Name "Prod"

Creates and returns a `CTXAPIHeaderObject`.
Store it in a variable (e.g., `$APIHeader`) and pass to other cmdlets.

### EXAMPLE 3

Read-Host -AsSecureString -Prompt "Enter Citrix API Secret" | Export-Clixml -Path "C:\Temp\CTX_Secret.xml"

$SecureSecret = Import-Clixml -Path "C:\Secure\CTX_Secret.xml"

## PARAMETERS

### -Client_Id

OAuth Client ID created under Citrix Cloud API access.

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

### -Client_Secret

OAuth Client Secret for the above Client ID.

```yaml
Type: SecureString
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

### -Customer_Id

Citrix Customer ID (GUID) from the Citrix Cloud console.

```yaml
Type: String
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

### -Customer_Name

Display name used in reports/filenames to identify this connection.

```yaml
Type: String
DefaultValue: ''
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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

{{ Fill in the related links here }}

