---
external help file: CTXCloudApi-help.xml
Module Name: CTXCloudApi
online version:
schema: 2.0.0
---

# Get-CTXAPI_ConnectionReport

## SYNOPSIS
Generate a report on connections

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
Generate a report on connections

## EXAMPLES

### Example 1
```powershell
PS C:\>  Get-CTXAPI_ConnectionReport -CustomerId $CustomerId -SiteId $SiteID -ApiToken $ApiToken -region ap-s -hours 24 -Export Excel -ReportPath C:\Temp


[2021-10-06 11:27:44] Getting data for:
				Days: 1
				Hours: 24


[11:27:44] Fetching :ApplicationActivitySummaries[9sec]
[11:27:53] Fetching :ApplicationInstances[4sec]
[11:27:58] Fetching :Applications[1sec]
[11:28:00] Fetching :Catalogs[0sec]
[11:28:00] Fetching :ConnectionFailureLogs[0sec]
[11:28:01] Fetching :Connections[4sec]
[11:28:06] Fetching :DesktopGroups[0sec]
[11:28:07] Fetching :DesktopOSDesktopSummaries[0sec]
[11:28:08] Fetching :FailureLogSummaries[1sec]
[11:28:09
```

Details in the excel / html file

## PARAMETERS

### -ApiToken
 Generate token with Get-CTXAPI_Token

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
 From Citrix Cloud Portal

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
 what type of report

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
a cutom psobject with monitoring data, if it is not present. Then the script fetch the odata


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
Parameter Sets: Fetch odata
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -hours
a moun of hours it will report on


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
where the clients' cloud instance is hosted


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
