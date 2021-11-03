---
external help file: CTXCloudApi-help.xml
Module Name: CTXCloudApi
online version:
schema: 2.0.0
---

# Get-CTXAPI_Sessions

## SYNOPSIS
Reports on user sessions

## SYNTAX

```
Get-CTXAPI_Sessions -APIHeader <Object> [<CommonParameters>]
```

## DESCRIPTION
Reports on user sessions

## EXAMPLES

### Example 1
```
PS C:\> $Sessions = Get-CTXAPI_Sessions -CustomerId $CustomerId -SiteId $SiteId -ApiToken $ApiToken
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
