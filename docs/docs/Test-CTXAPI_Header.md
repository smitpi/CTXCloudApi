---
external help file: CTXCloudAPI-help.xml
Module Name: CTXCloudApi
online version: https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Zone
schema: 2.0.0
---

# Test-CTXAPI_Header

## SYNOPSIS
Checks that the connection is still valid, and the token hasn't expired.

## SYNTAX

```
Test-CTXAPI_Header [[-APIHeader] <Object>] [-AutoRenew] [<CommonParameters>]
```

## DESCRIPTION
Checks that the connection is still valid, and the token hasn't expired.

## EXAMPLES

### EXAMPLE 1
```
Test-CTXAPI_Header -APIHeader $APIHeader -AutoRenew
```

## PARAMETERS

### -APIHeader
Use Connect-CTXAPI to create headers.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AutoRenew
If the token has expired, it will connect and renew the variable.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Boolean
## NOTES

## RELATED LINKS
