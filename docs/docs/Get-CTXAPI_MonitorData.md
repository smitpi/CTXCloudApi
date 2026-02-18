---
external help file: CTXCloudApi-help.xml
Module Name: CTXCloudApi
online version:
schema: 2.0.0
---

# Get-CTXAPI_MonitorData

## SYNOPSIS
Collect Monitoring OData for other reports.

## SYNTAX

```
Get-CTXAPI_MonitorData [-APIHeader] <Object> [-hours] <Int32> [<CommonParameters>]
```

## DESCRIPTION
Collects Citrix Monitor OData entities for use in other cmdlets and reports. Returns a CTXMonitorData object containing commonly used entities (Connections, Session, Machines, Catalogs, DesktopGroups, ResourceUtilization, SessionMetrics, etc.).

## EXAMPLES

### EXAMPLE 1
```
$MonitorData = Get-CTXAPI_MonitorData -APIHeader $APIHeader -hours 24
```
Collects the last 24 hours of Monitor OData and returns a CTXMonitorData object.

### EXAMPLE 2
```
Get-CTXAPI_MonitorData -APIHeader $APIHeader -hours 48 | Select-Object -ExpandProperty Connections
```
Expands and lists connection records for the past 48 hours.

## PARAMETERS

### -APIHeader
Header object created by Connect-CTXAPI; contains authentication and request headers.

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

### -hours
Amount of time to include in the dataset (e.g., 24, 48).

### -hours
```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS
None

## OUTPUTS
CTXMonitorData

Composite object containing Monitor OData entities used by reporting cmdlets.

## NOTES

## RELATED LINKS
