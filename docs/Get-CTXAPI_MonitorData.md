---
external help file: CTXCloudApi-help.xml
Module Name: CTXCloudApi
online version:
schema: 2.0.0
---

# Get-CTXAPI_MonitorData

## SYNOPSIS
Get the data from odata
## SYNTAX

```
Get-CTXAPI_MonitorData [-CustomerId] <String> [-SiteId] <String> [-ApiToken] <String> [-region] <String>
 [-hours] <Int32> [<CommonParameters>]
```

## DESCRIPTION
Get the data from odata

## EXAMPLES

### Example 1
```powershell
PS C:\> $MonitorData = Get-CTXAPI_MonitorData -CustomerId $CustomerId -SiteId $SiteId -ApiToken $ApiToken -region $region -hours $hours


[2021-10-06 15:58:20] Getting data for:
				Days: 0
				Hours: 1


[15:58:20] Fetching :ApplicationActivitySummaries[1sec]
[15:58:21] Fetching :ApplicationInstances[1sec]
[15:58:22] Fetching :Applications

```

{{ Add example description here }}

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

### -hours
 amount of hours to report on

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
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
