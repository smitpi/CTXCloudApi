---
external help file: CTXCloudApi-help.xml
Module Name: CTXCloudApi
online version:
schema: 2.0.0
---

# Get-CTXAPI_Token

## SYNOPSIS
Retrives the token for authentication 

## SYNTAX

```
Get-CTXAPI_Token [[-client_id] <String>] [[-client_secret] <String>] [<CommonParameters>]
```

## DESCRIPTION
Retrives the token for authentication 

## EXAMPLES

### Example 1
```powershell
PS C:\> $apitoken = Get-CTXAPI_Token -client_id $clientid -client_secret $clientsecret
```

{{ Add example description here }}

## PARAMETERS

### -client_id
 From Citrix Cloud Portal

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -client_secret
 From Citrix Cloud Portal

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
