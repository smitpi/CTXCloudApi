---
external help file: CTXCloudApi-help.xml
Module Name: CTXCloudApi
online version:
schema: 2.0.0
---

# Get-CTXAPI_Zone

## SYNOPSIS
Returns Zone details (handles pagination).

## SYNTAX

```
Get-CTXAPI_Zone [-APIHeader] <Object> [<CommonParameters>]
```

## DESCRIPTION
Returns Zone details from Citrix Cloud CVAD.

## EXAMPLES

### EXAMPLE 1
```
Get-CTXAPI_Zone -APIHeader $APIHeader
```
Lists all zones for the tenant.

### EXAMPLE 2
```
Get-CTXAPI_Zone -APIHeader $APIHeader | Select-Object Name, Enabled, Description
```
Shows key fields for each zone.

## PARAMETERS

### -APIHeader
Header object created by Connect-CTXAPI; contains authentication and request headers.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
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
Array of zone objects returned from the CVAD Manage API.
## NOTES

## RELATED LINKS
