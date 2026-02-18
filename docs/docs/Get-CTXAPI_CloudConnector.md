---
external help file: CTXCloudApi-help.xml
Module Name: CTXCloudApi
online version:
schema: 2.0.0
---

# Get-CTXAPI_CloudConnector

## SYNOPSIS
Returns details about current Cloud Connectors.

## SYNTAX

```
Get-CTXAPI_CloudConnector [-APIHeader] <Object> [<CommonParameters>]
```

## DESCRIPTION
Returns details about current Citrix Cloud Connectors by enumerating EdgeServers and expanding each to full detail.

## EXAMPLES

### EXAMPLE 1
```
Get-CTXAPI_CloudConnector -APIHeader $APIHeader | Select-Object name, version, status
```
Lists connector name, version, and status.

### EXAMPLE 2
```
Get-CTXAPI_CloudConnector -APIHeader $APIHeader | Where-Object {$_.status -ne 'Healthy'}
```
Shows connectors not in a healthy state.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS
None

## OUTPUTS

### System.Object[]
Array of Cloud Connector objects returned from the Agent Hub API.
## NOTES

## RELATED LINKS
