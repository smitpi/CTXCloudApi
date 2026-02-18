---
external help file: CTXCloudApi-help.xml
Module Name: CTXCloudApi
online version: https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_LowLevelOperation
schema: 2.0.0
---

# Get-CTXAPI_LowLevelOperation

## SYNOPSIS
Returns details about low-level configuration changes (more detailed).

## SYNTAX

```
Get-CTXAPI_LowLevelOperation [-APIHeader] <Object> [-HighLevelID] <String> [<CommonParameters>]
```

## DESCRIPTION
Returns details about low-level configuration changes for a specific operation ID from Config Log.

## EXAMPLES

### EXAMPLE 1
```
$ConfigLog = Get-CTXAPI_ConfigLog -APIHeader $APIHeader -Days 7
```

$LowLevelOperations = Get-CTXAPI_LowLevelOperation -APIHeader $APIHeader -HighLevelID $ConfigLog\[0\].id
Retrieves low-level operations for the first high-level operation in the past 7 days.

### EXAMPLE 2
```
" | Select-Object OperationType, Property, OldValue, NewValue
```

Shows key fields for each low-level change.

## PARAMETERS

### -APIHeader
Header object created by Connect-CTXAPI; contains authentication and request headers.

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
Unique id for a config change (from Get-CTXAPI_ConfigLog).

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

### None. Parameters are not accepted from the pipeline.
## OUTPUTS

### System.Object[]
### Array of low-level operation objects returned from the CVAD Manage API.
## NOTES

## RELATED LINKS

[https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_LowLevelOperation](https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_LowLevelOperation)

