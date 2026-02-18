---
external help file: CTXCloudApi-help.xml
Module Name: CTXCloudApi
online version: https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_FailureReport
schema: 2.0.0
---

# Get-CTXAPI_FailureReport

## SYNOPSIS
Reports on connection or machine failures in the last X hours.

## SYNTAX

### Fetch odata (Default)
```
Get-CTXAPI_FailureReport -APIHeader <Object> [-hours <Int32>] -FailureType <String> [-Export <String>]
 [-ReportPath <String>] [<CommonParameters>]
```

### Got odata
```
Get-CTXAPI_FailureReport -APIHeader <Object> [-MonitorData <Object>] [-hours <Int32>] -FailureType <String>
 [-Export <String>] [-ReportPath <String>] [<CommonParameters>]
```

## DESCRIPTION
Reports on machine or connection failures in the last X hours using Monitor OData.

## EXAMPLES

### EXAMPLE 1
```
Get-CTXAPI_FailureReport -MonitorData $MonitorData -FailureType Connection
```

Returns connection failures to the host.

### EXAMPLE 2
```
Get-CTXAPI_FailureReport -APIHeader $APIHeader -FailureType Machine -hours 48 -Export Excel -ReportPath C:\Temp
```

Exports machine failures for the last 48 hours to an Excel workbook.

### EXAMPLE 3
```
Get-CTXAPI_FailureReport -APIHeader $APIHeader -FailureType Connection | Select-Object User, DnsName, FailureDate, PowerState
```

Shows common fields for connection failures.

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
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 24
Accept pipeline input: False
Accept wildcard characters: False
```

### -FailureType
Type of failure to report on.
Supported values: Connection, Machine.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
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
### When Export is Host: array of failure report objects; when Export is Excel/HTML: no output objects and files are written to ReportPath.
## NOTES

## RELATED LINKS

[https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_FailureReport](https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_FailureReport)

