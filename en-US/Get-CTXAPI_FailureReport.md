---
external help file: CTXCloudApi-help.xml
Module Name: CTXCloudApi
online version:
schema: 2.0.0
---

# Get-CTXAPI_FailureReport

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

### Got odata
```
Get-CTXAPI_FailureReport [-CustomerId] <String> [-SiteId] <String> [-ApiToken] <String>
 [-MonitorData <PSObject>] [-FailureType] <String> [[-Export] <String>] [[-ReportPath] <String>]
 [<CommonParameters>]
```

### Fetch odata
```
Get-CTXAPI_FailureReport [-CustomerId] <String> [-SiteId] <String> [-ApiToken] <String> [[-region] <String>]
 [[-hours] <Int32>] [-FailureType] <String> [[-Export] <String>] [[-ReportPath] <String>] [<CommonParameters>]
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
Type: System.String
Parameter Sets: (All)
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
Type: System.String
Parameter Sets: (All)
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
Type: System.String
Parameter Sets: (All)
Aliases:
Accepted values: Excel, HTML

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FailureType
{{ Fill FailureType Description }}

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:
Accepted values: Connection, Machine

Required: True
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -hours
{{ Fill hours Description }}

```yaml
Type: System.Int32
Parameter Sets: Fetch odata
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MonitorData
{{ Fill MonitorData Description }}

```yaml
Type: System.Management.Automation.PSObject
Parameter Sets: Got odata
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -region
{{ Fill region Description }}

```yaml
Type: System.String
Parameter Sets: Fetch odata
Aliases:
Accepted values: us, eu, ap-s

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReportPath
{{ Fill ReportPath Description }}

```yaml
Type: System.String
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
Type: System.String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
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