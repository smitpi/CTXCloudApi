---
external help file: CTXCloudApi-help.xml
Module Name: CTXCloudApi
online version:
schema: 2.0.0
---

# Add-CTXAPI_MachineToCatalog

## SYNOPSIS
add machine to a machine catalog

## SYNTAX

```
Add-CTXAPI_MachineToCatalog [-CustomerId] <String> [-SiteId] <String> [-ApiToken] <String>
 [-CatalogNameORID] <String> [-MachineName] <String> [<CommonParameters>]
```

## DESCRIPTION
add machine to a machine catalog

## EXAMPLES

### Example 1
```powershell
PS C:\> Add-CTXAPI_MachineToCatalog -CustomerId $CustomerId -SiteId $SiteID -ApiToken $ApiToken -CatalogNameORID 1 -MachineName win10
```

## PARAMETERS

### -ApiToken

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

### -CatalogNameORID

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CustomerId

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MachineName

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SiteId

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
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
