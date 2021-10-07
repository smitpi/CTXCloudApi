---
external help file: CTXCloudApi-help.xml
Module Name: CTXCloudApi
online version:
schema: 2.0.0
---

# Get-CTXAPI_CloudServices

## SYNOPSIS
Client's Subscription details, and wjat features are enabled

## SYNTAX

```
Get-CTXAPI_CloudServices [-CustomerId] <String> [-ApiToken] <String> [<CommonParameters>]
```

## DESCRIPTION
Client's Subscription details, and wjat features are enabled

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-CTXAPI_CloudServices -CustomerId $CustomerId -SiteId $SiteID -ApiToken $ApiToken


serviceName                : adc
state                      : NotOnboarded
type                       : Default
quantity                   : 0
daysToExpiration           : 
notificationsDisabled      : False
futureEntitlementStartDate : 

serviceName                : podio
state                      : NotOnboarded
type                       : Default
quantity                   : 0
daysToExpiration           : 
notificationsDisabled      : False
futureEntitlementStartDate :
```

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
