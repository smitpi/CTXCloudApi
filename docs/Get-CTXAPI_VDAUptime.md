---
external help file: CTXCloudApi-help.xml
Module Name: CTXCloudApi
online version:
schema: 2.0.0
---

# Get-CTXAPI_VDAUptime

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

```
Get-CTXAPI_VDAUptime [-CustomerId] <String> [-SiteId] <String> [-ApiToken] <String> [[-Export] <String>]
 [[-ReportPath] <String>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-CTXAPI_VDAUptime -CustomerId $CustomerId -SiteId $SiteID -ApiToken $ApiToken -Export Excel -ReportPath c:\


DnsName           : AZ1.murza.co.za
AgentVersion      : 1912.0.3000.3293
MachineCatalog    : MC-AZEUW-UPDATES-2016
DeliveryGroup     : DG-AZEUW-UPDATES-2016
InMaintenanceMode : True
IPAddress         : 
OSType            : Windows 2016
ProvisioningType  : MCS
SummaryState      : Off
FaultState        : None
Days              : 6
TotalHours        : 146
OnlineSince       : 2021/09/30 13:13:19
DayOfWeek         : Thursday


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


### -Export
 what type of report

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Excel, HTML

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReportPath
 where the report will be saved

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
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
