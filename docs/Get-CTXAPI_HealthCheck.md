---
external help file: CTXCloudApi-help.xml
Module Name: CTXCloudApi
online version:
schema: 2.0.0
---

# Get-CTXAPI_HealthCheck

## SYNOPSIS
Creates a morning healthcheck report for admins. Looking at some key data points

## SYNTAX

```
Get-CTXAPI_HealthCheck [-CustomerId] <String> [-SiteId] <String> [-ApiToken] <String> [-region] <String>
 [[-ReportPath] <String>] [<CommonParameters>]
```

## DESCRIPTION
Creates a morning healthcheck report for admins. Looking at some key data points

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-CTXAPI_HealthCheck -CustomerId $CustomerId -SiteId $SiteId -ApiToken $ApiToken -region $region -ReportPath C:\Temp\
```

details in the html file

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

### -ReportPath
 where the report will be saved

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
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

### -region
Where the cloud instance is hosted

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: us, eu, ap-s

Required: True
Position: 3
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
