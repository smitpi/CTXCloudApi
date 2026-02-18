---
external help file: CTXCloudApi-help.xml
Module Name: CTXCloudApi
online version:
schema: 2.0.0
---

# Get-CTXAPI_ResourceUtilization

## SYNOPSIS
Resource utilization in the last X hours

## SYNTAX

### Fetch odata (Default)
```
Get-CTXAPI_ResourceUtilization -APIHeader <Object> [-hours <Int32>] [-Export <String>] [-ReportPath <String>] [<CommonParameters>]
```

### Got odata
```
Get-CTXAPI_ResourceUtilization [-MonitorData <Object>] [-Export <String>] [-ReportPath <String>] [<CommonParameters>]
```

## DESCRIPTION
Reports on resource utilization for VDA machines over the past X hours. Fetches CVAD Monitor OData (or uses provided `MonitorData`) and builds a per-machine dataset with averages (CPU, memory, sessions) and key details.

## EXAMPLES

### EXAMPLE 1
```
Get-CTXAPI_ResourceUtilization -MonitorData $MonitorData -Export Excel -ReportPath C:\temp\
```
Exports an Excel workbook with aggregated resource metrics.

### EXAMPLE 2
```
Get-CTXAPI_ResourceUtilization -APIHeader $APIHeader -hours 48 -Export HTML -ReportPath C:\temp
```
Generates an HTML report titled "Citrix Resources" for the last 48 hours.

### EXAMPLE 3
```
Get-CTXAPI_ResourceUtilization -APIHeader $APIHeader | Select-Object DnsName, AVGPercentCpu, AVGUsedMemory, AVGSessionCount
```
Returns objects to the host and selects common fields.

## PARAMETERS

### -APIHeader
Header object created by Connect-CTXAPI; contains authentication and request headers (used to fetch Monitor OData).

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
Pre-fetched CVAD Monitor OData created by Get-CTXAPI_MonitorData. If provided, the cmdlet will not fetch data.

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

### -hours
Duration window (in hours) to fetch when retrieving Monitor OData.

### -hours
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
Destination/output for the report. Supported values: Excel, HTML, Host. Default is Host.

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
None

## OUTPUTS
When Export is Host: Array of resource utilization objects.

When Export is Excel or HTML: No output objects; files are written to ReportPath.

## NOTES

## RELATED LINKS
