---
external help file: CTXCloudApi-help.xml
Module Name: CTXCloudApi
online version:
schema: 2.0.0
---

# Get-CTXAPI_LowLevelOperations

## SYNOPSIS
Retrieves detailed logs  administrator actions, from the Get-CTXAPI_ConfigLog function

## SYNTAX

```
Get-CTXAPI_LowLevelOperations -APIHeader <Object> [-HighLevelID] <String> [<CommonParameters>]
```

## DESCRIPTION
more details on config changes

## EXAMPLES

### Example 1
```
PS C:\> Get-CTXAPI_LowLevelOperations -CustomerId $CustomerId -SiteId $SiteID -ApiToken $ApiToken -HighLevelID $id
```

## PARAMETERS

### -HighLevelID
Get-CTXAPI_ConfigLog function

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

### -APIHeader
Use Connect-CTXAPI to create headers


```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
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
