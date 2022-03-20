---
external help file: CTXCloudAPI-help.xml
Module Name: CTXCloudApi
online version:
schema: 2.0.0
---

# Get-CTXAPI_HealthCheck

## SYNOPSIS
Show useful information for daily health check

## SYNTAX

```
Get-CTXAPI_HealthCheck [-APIHeader] <Object> [-region] <String> [[-ReportPath] <String>] [<CommonParameters>]
```

## DESCRIPTION
Show useful information for daily health check

## EXAMPLES

### EXAMPLE 1
```
Get-CTXAPI_HealthCheck -APIHeader $APIHeader -region eu -ReportPath C:\Temp
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

### -region
Your Cloud instance hosted region.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
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
