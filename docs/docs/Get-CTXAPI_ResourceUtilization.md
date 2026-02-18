---
external help file: CTXCloudApi-help.xml
Module Name: CTXCloudApi
online version: https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_ResourceUtilization
schema: 2.0.0
---

# Get-CTXAPI_ResourceUtilization

## SYNOPSIS
Resource utilization in the last X hours.

## SYNTAX

### Fetch odata (Default)
```
Get-CTXAPI_ResourceUtilization -APIHeader <Object> [-LastHours <Int32>] [-Export <String>]
 [-ReportPath <String>] [<CommonParameters>]
```

### Got odata
```
Get-CTXAPI_ResourceUtilization -APIHeader <Object> [-MonitorData <Object>] [-Export <String>]
 [-ReportPath <String>] [<CommonParameters>]
```

## DESCRIPTION
Reports on resource utilization for VDA machines over the past X hours.

## EXAMPLES

### EXAMPLE 1
```
Get-CTXAPI_ResourceUtilization -MonitorData $MonitorData -Export Excel -ReportPath C:\temp\
```

Exports an Excel workbook (Resources_Audit-\<yyyy.MM.dd-HH.mm\>.xlsx) with aggregated resource metrics.

### EXAMPLE 2
```
Get-CTXAPI_ResourceUtilization -APIHeader $APIHeader -LastHours 48 -Export HTML -ReportPath C:\temp
```

Generates an HTML report titled "Citrix Resources" for the last 48 hours.

### EXAMPLE 3
```
Get-CTXAPI_ResourceUtilization -APIHeader $APIHeader | Select-Object DnsName, AVGPercentCpu, AVGUsedMemory, AVGSessionCount
```

Returns objects to the host and selects common fields for quick inspection.

## PARAMETERS

### -APIHeader
Header object created by Connect-CTXAPI; contains authentication and request headers (used to fetch Monitor OData).

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

### -MonitorData
Pre-fetched CVAD Monitor OData created by Get-CTXAPI_MonitorData.
If provided, the cmdlet will not fetch data.

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

### -LastHours
Duration window in hours used when fetching Monitor OData.
Default: 24.

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
Destination/output for the report.
Supported values: Host, Excel, HTML.
Default: Host.

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
Destination folder for exported files when using Excel or HTML.
Defaults to $env:Temp.

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

### None. Parameters are not accepted from the pipeline.
## OUTPUTS

### PSCustomObject[]
### When Export is Host: array of resource utilization objects; when Export is Excel/HTML: no output objects and files are written to ReportPath.
## NOTES

## RELATED LINKS

[https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_ResourceUtilization](https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_ResourceUtilization)

