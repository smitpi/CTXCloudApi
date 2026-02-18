---
external help file: CTXCloudApi-help.xml
Module Name: CTXCloudApi
online version:
schema: 2.0.0
---

# Get-CTXAPI_FailureReport

## SYNOPSIS
Reports on connection or machine failures in the last X hours.

## SYNTAX

### Fetch odata (Default)
```
Get-CTXAPI_FailureReport -APIHeader <Object> [-hours <Int32>] -FailureType <String> [-Export <String>] [-ReportPath <String>] [<CommonParameters>]
```

### Got odata
```
Get-CTXAPI_FailureReport -APIHeader <Object> [-MonitorData <Object>] -FailureType <String> [-Export <String>] [-ReportPath <String>] [<CommonParameters>]
```

## DESCRIPTION
Reports on machine or connection failures in the last X hours using Monitor OData. Builds a failure dataset depending on `FailureType` (Connection or Machine).

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
Parameter Sets: Fetch odata
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

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

### -MonitorData
Use Get-CTXAPI_MonitorData to create OData.

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
Amount of time to report on.

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

### -FailureType
Type of failure to report on. Supported values: Connection, Machine.

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

### System.Object[]
When Export is Host: Array of failure report objects.

When Export is Excel or HTML: No output objects; files are written to ReportPath.
## NOTES

## RELATED LINKS
