---
external help file: CTXCloudApi-help.xml
Module Name: CTXCloudApi
online version:
schema: 2.0.0
---

# Get-CTXAPI_ConnectionReport

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

### Fetch odata
```
Get-CTXAPI_ConnectionReport [-CustomerId] <String> [-SiteId] <String> [-ApiToken] <String> [[-region] <String>]
 [[-hours] <Int32>] [[-Export] <String>] [[-ReportPath] <String>] [<CommonParameters>]
```

### Got odata
```
Get-CTXAPI_ConnectionReport [-MonitorData <PSObject>] [[-Export] <String>] [[-ReportPath] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -ApiToken
{{ Fill ApiToken Description }}

```yaml
Type: String
Parameter Sets: Fetch odata
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CustomerId
{{ Fill CustomerId Description }}

```yaml
Type: String
Parameter Sets: Fetch odata
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Export
{{ Fill Export Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Excel, HTML

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MonitorData
{{ Fill MonitorData Description }}

```yaml
Type: PSObject
Parameter Sets: Got odata
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReportPath
{{ Fill ReportPath Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SiteId
{{ Fill SiteId Description }}

```yaml
Type: String
Parameter Sets: Fetch odata
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -hours
{{ Fill hours Description }}

```yaml
Type: Int32
Parameter Sets: Fetch odata
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -region
{{ Fill region Description }}

```yaml
Type: String
Parameter Sets: Fetch odata
Aliases:
Accepted values: us, eu, ap-s

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
