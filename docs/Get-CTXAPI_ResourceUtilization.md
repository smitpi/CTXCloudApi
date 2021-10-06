---
external help file: CTXCloudApi-help.xml
Module Name: CTXCloudApi
online version:
schema: 2.0.0
---

# Get-CTXAPI_ResourceUtilization

## SYNOPSIS
Reports on the vda performance and utilization for the amount of hours

## SYNTAX

### Fetch odata
```
Get-CTXAPI_ResourceUtilization [-CustomerId] <String> [-SiteId] <String> [-ApiToken] <String>
 [[-region] <String>] [[-hours] <Int32>] [[-Export] <String>] [[-ReportPath] <String>] [<CommonParameters>]
```

### Got odata
```
Get-CTXAPI_ResourceUtilization [-MonitorData <PSObject>] [[-Export] <String>] [[-ReportPath] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Reports on the vda performance and utilization for the amount of hours

## EXAMPLES

### Example 1
```powershell
PS C:\>  Get-CTXAPI_ResourceUtilization -CustomerId $CustomerId -SiteId $SiteID -ApiToken $ApiToken -region eu -hours 5


DnsName                  : AZEUW-CVA
IsInMaintenanceMode      : 
AgentVersion             : 2103.0.0.29045
CurrentRegistrationState : Unregistered
OSType                   : Windows 2016
Catalog                  : 
DesktopGroup             : 
AVGPercentCpu            : 12
AVGUsedMemory            : 13
AVGTotalMemory           : 14
AVGSessionCount          : 11

DnsName                  : AZEUW-X
IsInMaintenanceMode      : 
AgentVersion             : 1912.0.3000.3293
CurrentRegistrationState : Unregistered
OSType                   : Windows 2016
Catalog                  : 
DesktopGroup             : 
AVGPercentCpu            : 12
AVGUsedMemory            : 13
AVGTotalMemory           : 14
AVGSessionCount          : 11
```

### Example 2
```powershell
Get-CTXAPI_ResourceUtilization -MonitorData $mondata -Export Excel
```

if you have the monitoring data from Get-CTXAPI_MonitorData, then you can run it like this,

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
** what type of report**


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

### -hours
 amount of hours to report on

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

### -MonitorData
Custom object from Get-CTXAPI_MonitorData


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

### -region
Where the cloud instance is hosted

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
