---
external help file: CTXCloudApi-help.xml
Module Name: CTXCloudApi
online version:
schema: 2.0.0
---

# Get-CTXAPI_ConfigLog

## SYNOPSIS
Get high level configuration changes in the last x days.

## SYNTAX

```
Get-CTXAPI_ConfigLog [-APIHeader] <Object> [-Days] <String> [<CommonParameters>]
```

## DESCRIPTION
Get high level configuration changes in the last x days.

## EXAMPLES

### EXAMPLE 1
```
Get-CTXAPI_ConfigLog -APIHeader $APIHeader -Days 15
```

## PARAMETERS

### -APIHeader
Use Connect-CTXAPI to create headers.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Days
Number of days to report on.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
