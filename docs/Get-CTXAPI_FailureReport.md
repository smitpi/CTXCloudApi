---
external help file: CTXCloudApi-help.xml
Module Name: CTXCloudApi
online version:
schema: 2.0.0
---

# Get-CTXAPI_FailureReport

## SYNOPSIS
Failure Report

## SYNTAX

### Fetch odata (Default)
```
Get-CTXAPI_FailureReport -APIHeader <Object> [-region <String>] [-hours <Int32>] -FailureType <String>
 [-Export <String>] [-ReportPath <String>] [<CommonParameters>]
```

### Got odata
```
Get-CTXAPI_FailureReport [-MonitorData <Object>] -FailureType <String> [-Export <String>]
 [-ReportPath <String>] [<CommonParameters>]
```

## DESCRIPTION
Config Audit

## EXAMPLES

### Example 1
```
Config Audit
```

Config Audit

## PARAMETERS

### -APIHeader
Use Connect-CTXAPI to create headers

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

### -Export
Config Audit

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Excel, HTML

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FailureType
Config Audit

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Connection, Machine

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MonitorData
Config Audit

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

### -ReportPath
Config Audit

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -hours
Config Audit

```yaml
Type: Int32
Parameter Sets: Fetch odata
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -region
Config Audit

```yaml
Type: String
Parameter Sets: Fetch odata
Aliases:
Accepted values: us, eu, ap-s

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
## OUTPUTS

### System.Object[]
## NOTES

## RELATED LINKS
