---
external help file: CTXCloudApi-help.xml
Module Name: CTXCloudApi
online version: https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_VDAUptime
schema: 2.0.0
---

# Get-CTXAPI_VDAUptime

## SYNOPSIS
Calculate VDA uptime and export or return results.

## SYNTAX

```
Get-CTXAPI_VDAUptime [-APIHeader] <Object> [[-Export] <String>] [[-ReportPath] <String>] [<CommonParameters>]
```

## DESCRIPTION
Calculates VDA machine uptime based on registration/deregistration timestamps.

## EXAMPLES

### EXAMPLE 1
```
Get-CTXAPI_VDAUptime -APIHeader $APIHeader -Export Excel -ReportPath C:\temp\
```

Exports an Excel workbook (VDAUptime-\<yyyy.MM.dd-HH.mm\>.xlsx) with uptime details.

### EXAMPLE 2
```
Get-CTXAPI_VDAUptime -APIHeader $APIHeader -Export HTML -ReportPath C:\Temp
```

Generates an HTML report titled "Citrix Uptime".

### EXAMPLE 3
```
Get-CTXAPI_VDAUptime -APIHeader $APIHeader | Select-Object DnsName, Days, OnlineSince, SummaryState
```

Returns objects to the host and selects common fields for quick inspection.

## PARAMETERS

### -APIHeader
Header object created by Connect-CTXAPI; contains authentication and request headers.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
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
Position: 2
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
Position: 3
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
### When Export is Host: array of uptime objects; when Export is Excel/HTML: no output objects and files are written to ReportPath.
## NOTES

## RELATED LINKS

[https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_VDAUptime](https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_VDAUptime)

