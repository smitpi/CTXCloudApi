---
external help file: CTXCloudAPI-help.xml
Module Name: CTXCloudApi
online version: https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_MonitorData
schema: 2.0.0
---

# Get-CTXAPI_MonitorData

## SYNOPSIS
Collect Monitoring OData for other reports.

## SYNTAX

### hours
```
Get-CTXAPI_MonitorData -APIHeader <Object> [-LastHours <Int32>] [-MonitorDetails <String[]>]
 [<CommonParameters>]
```

### specific
```
Get-CTXAPI_MonitorData -APIHeader <Object> [-BeginDate <DateTime>] [-EndDate <DateTime>]
 [-MonitorDetails <String[]>] [<CommonParameters>]
```

## DESCRIPTION
Collects Citrix Monitor OData entities for a specified time window and returns a composite object used by reporting cmdlets.

## EXAMPLES

### EXAMPLE 1
```
$MonitorData = Get-CTXAPI_MonitorData -APIHeader $APIHeader -LastHours 24
```

Collects the last 24 hours of Monitor OData and returns a CTXMonitorData object.

### EXAMPLE 2
```
Get-CTXAPI_MonitorData -APIHeader $APIHeader -BeginDate (Get-Date).AddDays(-2) -EndDate (Get-Date).AddDays(-1) -MonitorDetails Connections,Session
```

Collects data for a specific date range and includes only Connections and Session entities.

### EXAMPLE 3
```
Get-CTXAPI_MonitorData -APIHeader $APIHeader -LastHours 48 | Select-Object -ExpandProperty Connections
```

Expands and lists connection records for the past 48 hours.

## PARAMETERS

### -APIHeader
Header object created by Connect-CTXAPI; contains authentication and request headers.

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

### -LastHours
Relative time window in hours (e.g., 24, 48).
When specified, BeginDate is now and EndDate is now minus LastHours.

```yaml
Type: Int32
Parameter Sets: hours
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -BeginDate
Start of the time window when specifying an explicit range.

```yaml
Type: DateTime
Parameter Sets: specific
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EndDate
End of the time window when specifying an explicit range.

```yaml
Type: DateTime
Parameter Sets: specific
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MonitorDetails
One or more OData entity names to include.
Default is All.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: All
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
## OUTPUTS

### System.Object (PSTypeName: CTXMonitorData)
### Composite PSCustomObject containing Monitor OData entities used by reporting cmdlets.
## NOTES

## RELATED LINKS

[https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_MonitorData](https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_MonitorData)

