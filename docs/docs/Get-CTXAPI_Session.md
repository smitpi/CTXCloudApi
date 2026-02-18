---
external help file: CTXCloudApi-help.xml
Module Name: CTXCloudApi
online version: https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Session
schema: 2.0.0
---

# Get-CTXAPI_Session

## SYNOPSIS
Returns details about current sessions (handles pagination).

## SYNTAX

```
Get-CTXAPI_Session [-APIHeader] <Object> [<CommonParameters>]
```

## DESCRIPTION
Returns details about current sessions from Citrix Cloud CVAD.

## EXAMPLES

### EXAMPLE 1
```
Get-CTXAPI_Session -APIHeader $APIHeader
```

Retrieves and lists current session objects.

### EXAMPLE 2
```
Get-CTXAPI_Session -APIHeader $APIHeader | Select-Object UserName, DnsName, LogOnDuration, ConnectionState
```

Shows key fields for each session.

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
### Array of session objects returned from the CVAD Manage API.
## NOTES

## RELATED LINKS

[https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Session](https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Session)

