---
external help file: CTXCloudApi-help.xml
Module Name: CTXCloudApi
online version:
schema: 2.0.0
---

# Get-CTXAPI_MachineCatalog

## SYNOPSIS
Returns details about Machine Catalogs (handles pagination).

## SYNTAX

```
Get-CTXAPI_MachineCatalog [-APIHeader] <Object> [<CommonParameters>]
```

## DESCRIPTION
Returns details about Machine Catalogs from Citrix Cloud CVAD.

## EXAMPLES

### EXAMPLE 1
```
$MachineCatalogs = Get-CTXAPI_MachineCatalog -APIHeader $APIHeader
```
Retrieves all machine catalogs and stores them for reuse.

### EXAMPLE 2
```
Get-CTXAPI_MachineCatalog -APIHeader $APIHeader | Select-Object Name, SessionSupport, TotalCount, IsPowerManaged
```
Lists key catalog fields including session support, total machines, and power management.

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
Array of machine catalog objects returned from the CVAD Manage API.
## NOTES

## RELATED LINKS
