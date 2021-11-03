---
external help file: CTXCloudApi-help.xml
Module Name: CTXCloudApi
online version:
schema: 2.0.0
---

# Get-CTXAPI_Zones

## SYNOPSIS
show zone details

## SYNTAX

```
Get-CTXAPI_Zones [-CustomerId] <String> [-SiteId] <String> [-ApiToken] <String> [<CommonParameters>]
```

## DESCRIPTION
show zone details

## EXAMPLES

### Example 1
```powershell
PS C:\>  Get-CTXAPI_Zones -CustomerId $CustomerId -SiteId $SiteID -ApiToken $ApiToken


Id               : d94fe0d6-742e-4535-a562-61afrth (DR)
Description      : 
IsPrimary        : False
Metadata         : {}
ResourceLocation : @{Id=3452790fa; Uid=; Name=}

Id               : 0bce0a9-8920-855ddd9b6772
Name             : Azure EU West (Production)
Description      : 
IsPrimary        : False
Metadata         : {}
ResourceLocation : @{Id=60-f69971c570ee; Uid=; Name=}

Id               : 4e4948e295-8f9636886d05
Name             : Dubai
Description      : 
IsPrimary        : False
Metadata         : {}
ResourceLocation : @{Id=9960d8af43c; Uid=; Name=}
```

{{ Add example description here }}

## PARAMETERS

### -ApiToken
 Generate token with Get-CTXAPI_Token

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

### -CustomerId
 From Citrix Cloud Portal

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

### -SiteId
 Generate id with Get-CTXAPI_SiteID

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
