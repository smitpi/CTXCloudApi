---
external help file: CTXCloudApi-help.xml
Module Name: CTXCloudApi
online version: https://smitpi.github.io/CTXCloudApi/#Get-CTXAPI_LowLevelOperations
schema: 2.0.0
---

# Get-CTXAPI_LowLevelOperations

## SYNOPSIS
Return details about low lever config change (More detailed)

## SYNTAX

```
Get-CTXAPI_LowLevelOperations [-APIHeader] <Object> [-HighLevelID] <String> [<CommonParameters>]
```

## DESCRIPTION
Return details about low lever config change (More detailed)

## EXAMPLES

### EXAMPLE 1
```
$ConfigLog = Get-CTXAPI_ConfigLog -APIHeader $APIHeader -Days 7
$LowLevelOperations = Get-CTXAPI_LowLevelOperations -APIHeader $APIHeader -HighLevelID $ConfigLog[0].id
```

## PARAMETERS

### -APIHeader
Use Connect-CTXAPI to create headers

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

### -HighLevelID
Unique id for a config change.
From the Get-CTXAPI_ConfigLog function.

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

### System.Object[]
## NOTES

## RELATED LINKS
