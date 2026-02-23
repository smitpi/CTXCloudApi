---
external help file: CTXCloudApi-help.xml
Module Name: CTXCloudApi
online version: https://smitpi.github.io/CTXCloudApi/New-CTXAPI_Machine
schema: 2.0.0
---

# New-CTXAPI_Report

## SYNOPSIS
Generate Citrix Cloud monitoring reports in multiple formats (Host, Excel, HTML).

## SYNTAX

```
New-CTXAPI_Report -APIHeader <Object> [-MonitorData <Object>] [-LastHours <Int32>] -ReportType <String[]>
 [-Export <String>] [-ReportPath <DirectoryInfo>] [<CommonParameters>]
```

## DESCRIPTION
New-CTXAPI_Report generates detailed Citrix Cloud monitoring reports, including resource utilization, connection activity, connection failures, and machine failures.
The function can output reports to the host, export to Excel, or create a styled HTML report with embedded branding.
Data can be sourced from a provided MonitorData object or fetched live via API.

## EXAMPLES

### EXAMPLE 1
```
New-CTXAPI_Report -APIHeader $header -ReportType All -Export HTML -ReportPath C:\Reports
```

Generates all available reports and exports them as a styled HTML file to C:\Reports.

### EXAMPLE 2
```
New-CTXAPI_Report -APIHeader $header -ReportType ResourceUtilization -Export Excel
```

Exports only the resource utilization report to Excel in the default temp directory.

### EXAMPLE 3
```
New-CTXAPI_Report -APIHeader $header -MonitorData $data -ReportType ConnectionReport
```

Outputs the connection report to the host using pre-fetched monitoring data.

## PARAMETERS

### -APIHeader
The authentication header object for Citrix Cloud API requests.
Required for all operations.

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
Optional.
Pre-fetched monitoring data object.
If not provided, the function retrieves data using Get-CTXAPI_MonitorData.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LastHours
Optional.
Number of hours of historical data to include (default: 24).
Used only if MonitorData is not provided.

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

### -ReportType
Specifies which report(s) to generate.
Valid values: ConnectionReport, ResourceUtilization, ConnectionFailureReport, MachineFailureReport, All.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Export
Specifies the output format.
Valid values: Host (default), Excel, HTML.

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
Directory path for exported reports (Excel/HTML).
Defaults to $env:TEMP.
Must exist.

```yaml
Type: DirectoryInfo
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

### System.Object[]
## NOTES

## RELATED LINKS
