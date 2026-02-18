---
external help file: CTXCloudAPI-help.xml
Module Name: CTXCloudApi
online version: https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_ConnectionReport
schema: 2.0.0
---

# Get-CTXAPI_ConnectionReport

## SYNOPSIS
Creates a connection report from CVAD Monitor data.

## SYNTAX

### Fetch odata (Default)
```
Get-CTXAPI_ConnectionReport -APIHeader <Object> [-hours <Int32>] [-Export <String>] [-ReportPath <String>]
 [<CommonParameters>]
```

### Got odata
```
Get-CTXAPI_ConnectionReport [-MonitorData <Object>] [-Export <String>] [-ReportPath <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Reports on user session connections for the last X hours.

## EXAMPLES

### EXAMPLE 1
```
Get-CTXAPI_ConnectionReport -MonitorData $MonitorData -Export HTML -ReportPath c:\temp
```

Generates an HTML report titled "Citrix Sessions" with the full dataset.

### EXAMPLE 2
```
Get-CTXAPI_ConnectionReport -APIHeader $APIHeader -hours 48 -Export Excel -ReportPath c:\temp
```

Fetches 48 hours of Monitor data and exports an Excel workbook (Session_Audit-\<yyyy.MM.dd-HH.mm\>.xlsx).

### EXAMPLE 3
```
Get-CTXAPI_ConnectionReport -APIHeader $APIHeader | Select-Object Upn, DnsName, EstablishmentDate, AVG_ICA_RTT
```

Returns objects to the host and selects common fields for quick inspection.

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

### -hours
Duration window (in hours) to fetch when retrieving Monitor OData.
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

### System.Object[]
### When Export is Host: array of connection report objects; when Export is Excel/HTML: no output objects and files are written to ReportPath.
## NOTES

## RELATED LINKS

[https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_ConnectionReport](https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_ConnectionReport)

