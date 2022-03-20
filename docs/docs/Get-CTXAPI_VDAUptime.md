---
external help file: CTXCloudAPI-help.xml
Module Name: CTXCloudApi
online version:
schema: 2.0.0
---

# Get-CTXAPI_VDAUptime

## SYNOPSIS
Uses Registration date to calculate uptime

## SYNTAX

```
Get-CTXAPI_VDAUptime [-APIHeader] <Object> [[-Export] <String>] [[-ReportPath] <String>] [<CommonParameters>]
```

## DESCRIPTION
Uses Registration date to calculate uptime

## EXAMPLES

### EXAMPLE 1
```
Get-CTXAPI_VDAUptime -APIHeader $APIHeader -Export excel -ReportPath C:\temp\
```

## PARAMETERS

### -APIHeader
Use Connect-CTXAPI to create headers

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
In what format to export the reports.

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

## OUTPUTS

## NOTES

## RELATED LINKS
