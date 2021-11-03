---
external help file: CTXCloudApi-help.xml
Module Name: CTXCloudApi
online version:
schema: 2.0.0
---

# Get-CTXAPI_CloudServices

## SYNOPSIS
Client's Subscription details, and what features are enabled

## SYNTAX

```
Get-CTXAPI_CloudServices -APIHeader <Object> [<CommonParameters>]
```

## DESCRIPTION
Client's Subscription details, and what features are enabled

## EXAMPLES

### Example 1
```
PS C:\> Get-CTXAPI_CloudServices -APIHeader $APIHeader


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
