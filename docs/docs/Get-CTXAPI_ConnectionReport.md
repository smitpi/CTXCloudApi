---
external help file: CTXCloudApi-help.xml
Module Name: CTXCloudApi
online version: https://smitpi.github.io/CTXCloudApi/#Get-CTXAPI_ConnectionReport
schema: 2.0.0
---

# Get-CTXAPI_ConnectionReport

## SYNOPSIS
Creates Connection report

## SYNTAX

### Fetch odata (Default)
```
Get-CTXAPI_ConnectionReport -APIHeader <Object> [-region <String>] [-hours <Int32>] [-Export <String>]
 [-ReportPath <String>] [<CommonParameters>]
```

### Got odata
```
Get-CTXAPI_ConnectionReport [-MonitorData <Object>] [-Export <String>] [-ReportPath <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Report on connections in the last x hours

## EXAMPLES

### EXAMPLE 1
```
Get-CTXAPI_ConnectionReport -MonitorData $MonitorData -Export HTML -ReportPath c:\temp
```

## PARAMETERS

### -APIHeader
Use Connect-CTXAPI to create headers

```yaml
Type: Object
Parameter Sets: Fetch odata
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MonitorData
Use Get-CTXAPI_MonitorData to create OData

```yaml
Type: Object
Parameter Sets: Got odata
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -region
You Cloud region

```yaml
Type: String
Parameter Sets: Fetch odata
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -hours
Duration of the report

```yaml
Type: Int32
Parameter Sets: Fetch odata
Aliases:

Required: False
Position: Named
Default value: 24
Accept pipeline input: False
Accept wildcard characters: False
```

### -Export
In what format to export the reports.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Host
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReportPath
Destination folder for the exported report.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: $env:temp
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
