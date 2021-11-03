---
external help file: CTXCloudApi-help.xml
Module Name: CTXCloudApi
online version:
schema: 2.0.0
---

# Get-CTXAPI_Hypervisors

## SYNOPSIS
Returns details about the hosting connection

## SYNTAX

```
Get-CTXAPI_Hypervisors -APIHeader <Object> [<CommonParameters>]
```

## DESCRIPTION
Returns details about the hosting connection

## EXAMPLES

### Example 1
```
PS C:\> Get-CTXAPI_Hypervisors -CustomerId $CustomerId -SiteId $SiteID -ApiToken $ApiToken
```

## PARAMETERS

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
