---
external help file: CTXCloudApi-help.xml
Module Name: CTXCloudApi
online version:
schema: 2.0.0
---

# Get-CTXAPI_SiteID

## SYNOPSIS
Get the SiteID

## SYNTAX

```
Get-CTXAPI_SiteID [-CustomerId] <String> [-ApiToken] <String> [<CommonParameters>]
```

## DESCRIPTION
Get the SiteID

## EXAMPLES

### Example 1
```powershell
PS C:\> $siteid = Get-CTXAPI_Siteid -CustomerId $CustomerId -ApiToken $apitoken
```

## PARAMETERS

### -ApiToken

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
