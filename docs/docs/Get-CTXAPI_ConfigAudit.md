---
external help file: CTXCloudAPI-help.xml
Module Name: CTXCloudApi
online version: https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_ConfigAudit
schema: 2.0.0
---

# Get-CTXAPI_ConfigAudit

## SYNOPSIS
Reports on system config.

## SYNTAX

```
Get-CTXAPI_ConfigAudit [-APIHeader] <Object> [[-Export] <String>] [[-ReportPath] <String>] [<CommonParameters>]
```

## DESCRIPTION
Reports on Machine Catalogs, Delivery Groups, Published Applications, and VDI Machines.
Collects audit data and either returns it to the host (default) or exports it to Excel/HTML.

## EXAMPLES

### EXAMPLE 1
```
Get-CTXAPI_ConfigAudit -APIHeader $APIHeader
```

Returns a PSCustomObject containing Machine_Catalogs, Delivery_Groups, Published_Apps, and VDI_Devices.

### EXAMPLE 2
```
Get-CTXAPI_ConfigAudit -APIHeader $APIHeader -Export Excel -ReportPath C:\Temp
```

Exports an Excel workbook (XD_Audit-\<CustomerName\>-\<yyyy.MM.dd-HH.mm\>.xlsx) with sheets for each dataset.

### EXAMPLE 3
```
Get-CTXAPI_ConfigAudit -APIHeader $APIHeader -Export HTML -ReportPath C:\Temp
```

Generates an HTML report (XD_Audit-\<CustomerName\>-\<yyyy.MM.dd-HH.mm\>.html) with tables and branding.

## PARAMETERS

### -APIHeader
Header object created by Connect-CTXAPI; contains authentication and context.

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
Destination folder for exported files when using Excel or HTML.
Defaults to $env:Temp.

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

### When Export is Host: PSCustomObject with properties Machine_Catalogs, Delivery_Groups, Published_Apps, VDI_Devices.
### When Export is Excel or HTML: No objects returned; files are written to ReportPath.
## NOTES

## RELATED LINKS

[https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_ConfigAudit](https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_ConfigAudit)

