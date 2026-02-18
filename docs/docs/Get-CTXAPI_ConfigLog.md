---
external help file: CTXCloudApi-help.xml
Module Name: CTXCloudApi
online version:
schema: 2.0.0
---

# Get-CTXAPI_ConfigLog

## SYNOPSIS
Returns high-level configuration changes in the last X days.

## SYNTAX

```
Get-CTXAPI_ConfigLog [-APIHeader] <Object> [-Days] <String> [<CommonParameters>]
```

## DESCRIPTION
Returns high-level configuration changes over the past X days from the CVAD Manage API `ConfigLog/Operations?days=<X>` endpoint.

## EXAMPLES

### EXAMPLE 1
```
Get-CTXAPI_ConfigLog -APIHeader $APIHeader -Days 15 | Select-Object TimeStamp, ObjectType, OperationType, User
```
Shows recent configuration operations with key fields for the past 15 days.

### EXAMPLE 2
```
Get-CTXAPI_ConfigLog -APIHeader $APIHeader -Days 7 | Where-Object { $_.ObjectType -eq 'DeliveryGroup' }
```
Filters operations related to Delivery Groups in the last 7 days.

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

### -Days
Number of days to report on (e.g., 7, 15, 30).

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
None

## OUTPUTS
### System.Object[]
Array of configuration operation objects returned from the CVAD Manage API.

## NOTES

## RELATED LINKS
