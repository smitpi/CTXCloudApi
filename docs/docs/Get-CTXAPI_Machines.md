---
external help file: CTXCloudAPI-help.xml
Module Name: CTXCloudAPI
online version:
schema: 2.0.0
---

# Get-CTXAPI_Machines

## SYNOPSIS
Return details about vda machines

## SYNTAX

```
Get-CTXAPI_Machines [-APIHeader] <Object> [-GetPubDesktop] [<CommonParameters>]
```

## DESCRIPTION
Return details about vda machines

## EXAMPLES

### EXAMPLE 1
```
$machines = Get-CTXAPI_Machines -APIHeader $APIHeader
```

## PARAMETERS

### -APIHeader
Use Connect-CTXAPI to create headers

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

### -GetPubDesktop
Get published desktop details

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
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
