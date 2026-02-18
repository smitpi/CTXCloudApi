---
external help file: CTXCloudAPI-help.xml
Module Name: CTXCloudApi
online version: https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_DeliveryGroup
schema: 2.0.0
---

# Get-CTXAPI_DeliveryGroup

## SYNOPSIS
Returns details about Delivery Groups (handles pagination).

## SYNTAX

```
Get-CTXAPI_DeliveryGroup [-APIHeader] <Object> [<CommonParameters>]
```

## DESCRIPTION
Returns details about Delivery Groups from Citrix Cloud CVAD.

## EXAMPLES

### EXAMPLE 1
```
Get-CTXAPI_DeliveryGroup -APIHeader $APIHeader | Select-Object Name, TotalMachines, InMaintenanceMode
```

Lists group name, total machines, and maintenance status.

### EXAMPLE 2
```
Get-CTXAPI_DeliveryGroup -APIHeader $APIHeader | Where-Object { $_.IsBroken }
```

Shows delivery groups marked as broken.

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
### Array of delivery group objects returned from the CVAD Manage API.
## NOTES

## RELATED LINKS

[https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_DeliveryGroup](https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_DeliveryGroup)

