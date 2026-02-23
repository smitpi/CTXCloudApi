---
external help file: CTXCloudApi-help.xml
Module Name: CTXCloudApi
online version: https://smitpi.github.io/CTXCloudApi/New-CTXAPI_Machine
schema: 2.0.0
---

# New-CTXAPI_Machine

## SYNOPSIS
Creates and adds new machines to a Citrix Cloud Delivery Group.

## SYNTAX

```
New-CTXAPI_Machine [-APIHeader] <Object> [-MachineCatalogName] <String> [-DeliveryGroupName] <String>
 [-AmountOfMachines] <Int32> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function provisions one or more new machines in a specified Machine Catalog and adds them to a specified Delivery Group in Citrix Cloud using the CTXCloudApi module.
The function supports verbose output for detailed process tracking.

## EXAMPLES

### EXAMPLE 1
```
New-CTXAPI_Machine -APIHeader $header -MachineCatalogName "Win10-Catalog" -DeliveryGroupName "Win10-Users" -AmountOfMachines 2 -Verbose
```

Creates 2 new machines in the "Win10-Catalog" Machine Catalog and adds them to the "Win10-Users" Delivery Group, showing verbose output.

## PARAMETERS

### -APIHeader
The authentication header object returned by Connect-CTXAPI, required for all API calls.

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

### -MachineCatalogName
The name of the Machine Catalog where new machines will be created.

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

### -DeliveryGroupName
The name of the Delivery Group to which the new machines will be added.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AmountOfMachines
The number of machines to create and add to the Delivery Group.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Object[]
## NOTES

## RELATED LINKS

[https://smitpi.github.io/CTXCloudApi/New-CTXAPI_Machine](https://smitpi.github.io/CTXCloudApi/New-CTXAPI_Machine)

