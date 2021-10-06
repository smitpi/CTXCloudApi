---
external help file: CTXCloudApi-help.xml
Module Name: CTXCloudApi
online version:
schema: 2.0.0
---

# Get-CTXAPI_ConfigAudit

## SYNOPSIS
Generate detailed report on machine catlog,delivery group and published apps

## SYNTAX

```
Get-CTXAPI_ConfigAudit [-CustomerId] <String> [-SiteId] <String> [-ApiToken] <String> [-Export] <String>
 [[-ReportPath] <String>] [<CommonParameters>]
```

## DESCRIPTION
Generate detailed report on machine catlog,delivery group and published apps

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-CTXAPI_ConfigAudit -CustomerId $CustomerId -SiteId $SiteID -ApiToken $ApiToken -Export Excel
```

Details in excel or html file

## PARAMETERS

### -ApiToken
 Generate token with Get-CTXAPI_Token

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

### -CustomerId
 From Citrix Cloud Portal


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Export
what type of report


```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Excel, HTML, Host

Required: True
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReportPath
where the report will be saved


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
 Generate id with Get-CTXAPI_SiteID

```yaml
Type: String
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
