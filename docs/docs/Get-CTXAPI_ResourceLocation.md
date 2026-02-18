---
external help file: CTXCloudAPI-help.xml
Module Name: CTXCloudApi
online version: https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_ResourceLocation
schema: 2.0.0
---

# Get-CTXAPI_ResourceLocation

## SYNOPSIS
Returns cloud Resource Locations.

## SYNTAX

```
Get-CTXAPI_ResourceLocation [-APIHeader] <Object> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Returns Citrix Cloud Resource Locations for the current customer.

## EXAMPLES

### EXAMPLE 1
```
Get-CTXAPI_ResourceLocation -APIHeader $APIHeader
Lists all Resource Locations for the tenant.
```

### EXAMPLE 2
```
Get-CTXAPI_ResourceLocation -APIHeader $APIHeader | Select-Object name, description, id
Selects key fields from the returned items.
```

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

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
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
### Array of resource location objects returned from the Registry API.
## NOTES

## RELATED LINKS

[https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_ResourceLocation](https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_ResourceLocation)

