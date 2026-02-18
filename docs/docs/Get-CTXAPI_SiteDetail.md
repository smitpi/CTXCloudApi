---
external help file: CTXCloudAPI-help.xml
Module Name: CTXCloudApi
online version: https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_SiteDetail
schema: 2.0.0
---

# Get-CTXAPI_SiteDetail

## SYNOPSIS
Returns details about your CVAD site.

## SYNTAX

```
Get-CTXAPI_SiteDetail [-APIHeader] <Object> [<CommonParameters>]
```

## DESCRIPTION
Returns details about your CVAD site (farm) from Citrix Cloud.

## EXAMPLES

### EXAMPLE 1
```
Get-CTXAPI_SiteDetail -APIHeader $APIHeader
```

Returns the site details for the current \`Citrix-InstanceId\`.

### EXAMPLE 2
```
Get-CTXAPI_SiteDetail -APIHeader $APIHeader | Select-Object Name, FunctionalLevel, LicensingMode
```

Selects key fields from the site object.

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

### System.Object
### Site detail object returned from the CVAD Manage API.
## NOTES

## RELATED LINKS

[https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_SiteDetail](https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_SiteDetail)

