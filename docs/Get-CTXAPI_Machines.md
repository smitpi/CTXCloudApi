---
external help file: CTXCloudApi-help.xml
Module Name: CTXCloudApi
online version:
schema: 2.0.0
---

# Get-CTXAPI_Machines

## SYNOPSIS
Details about VDA devices

## SYNTAX

```
Get-CTXAPI_Machines -APIHeader <Object> [-GetPubDesktop] [<CommonParameters>]
```

## DESCRIPTION
Details about VDA devices

## EXAMPLES

### Example 1
```
PS C:\>  Get-CTXAPI_Machines -CTXAPI_MachineCatalogs -CustomerId $CustomerId -SiteId $SiteID -ApiToken $ApiToken
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

### -GetPubDesktop
Get desktop details

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
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
