---
external help file: CTXCloudAPI-help.xml
Module Name: CTXCloudApi
online version: https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_CloudService
schema: 2.0.0
---

# Get-CTXAPI_CloudService

## SYNOPSIS
Returns details about cloud services and subscription.

## SYNTAX

```
Get-CTXAPI_CloudService [-APIHeader] <Object> [<CommonParameters>]
```

## DESCRIPTION
Returns details about Citrix Cloud services and subscription state from the \`serviceStates\` endpoint.

## EXAMPLES

### EXAMPLE 1
```
Get-CTXAPI_CloudService -APIHeader $APIHeader | Select-Object serviceName, state, lastUpdated
```

Lists each service name, its current state, and the last update time.

### EXAMPLE 2
```
Get-CTXAPI_CloudService -APIHeader $APIHeader | Where-Object { $_.state -ne 'Enabled' }
```

Shows services that are not currently enabled.

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

### None. Parameters are not accepted from the pipeline.
## OUTPUTS

### System.Object[]
### Array of service state objects returned from the Core Workspaces API.
## NOTES

## RELATED LINKS

[https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_CloudService](https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_CloudService)

