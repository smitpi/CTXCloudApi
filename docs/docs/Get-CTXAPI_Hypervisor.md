---
external help file: CTXCloudApi-help.xml
Module Name: CTXCloudApi
online version: https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Hypervisor
schema: 2.0.0
---

# Get-CTXAPI_Hypervisor

## SYNOPSIS
Returns details about hosting (hypervisor) connections (handles pagination).

## SYNTAX

```
Get-CTXAPI_Hypervisor [-APIHeader] <Object> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Returns details about hosting (hypervisor) connections from Citrix Cloud CVAD.

## EXAMPLES

### EXAMPLE 1
```
Get-CTXAPI_Hypervisor -APIHeader $APIHeader | Select-Object Name, HostingType, Enabled
Lists hypervisor name, hosting type, and enabled state.
```

### EXAMPLE 2
```
Get-CTXAPI_Hypervisor -APIHeader $APIHeader | Where-Object { $_.IsBroken }
Shows hypervisors marked as broken.
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
### Array of hypervisor objects returned from the CVAD Manage API.
## NOTES

## RELATED LINKS

[https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Hypervisor](https://smitpi.github.io/CTXCloudApi/Get-CTXAPI_Hypervisor)

