---
external help file: CTXCloudApi-help.xml
Module Name: CTXCloudApi
online version:
schema: 2.0.0
---

# Get-CTXAPI_ConfigAudit

## SYNOPSIS
Reports on system config.

## SYNTAX

```
Get-CTXAPI_ConfigAudit [-APIHeader] <Object> [-Export <String>] [[-ReportPath] <String>] [<CommonParameters>]
```

## DESCRIPTION
Reports on machine Catalog, delivery groups and published desktops.

## EXAMPLES

### EXAMPLE 1
```
Get-CTXAPI_ConfigAudit -APIHeader $APIHeader -Export Excel -ReportPath C:\Temp
```

### EXAMPLE 2
```
Get-CTXAPI_ConfigAudit -APIHeader $APIHeader
```
Returns a PSCustomObject with properties: Machine_Catalogs, Delivery_Groups, Published_Apps, VDI_Devices.

### EXAMPLE 3
```
Get-CTXAPI_ConfigAudit -APIHeader $APIHeader -Export HTML -ReportPath C:\Temp
```
Writes an HTML report to the specified folder.

## PARAMETERS

### -APIHeader
Use Connect-CTXAPI to create headers.

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
In what format to export the reports. Supported values: Excel, HTML, Host. Default is Host.

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
None

## OUTPUTS
When Export is Host: PSCustomObject with properties Machine_Catalogs, Delivery_Groups, Published_Apps, VDI_Devices.

When Export is Excel or HTML: No output objects; files are written to ReportPath.

## NOTES

## RELATED LINKS
