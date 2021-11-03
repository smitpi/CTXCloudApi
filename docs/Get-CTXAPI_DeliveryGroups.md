---
external help file: CTXCloudApi-help.xml
Module Name: CTXCloudApi
online version:
schema: 2.0.0
---

# Get-CTXAPI_DeliveryGroups

## SYNOPSIS
Return details of all delivery groups

## SYNTAX

```
Get-CTXAPI_DeliveryGroups -APIHeader <Object> [<CommonParameters>]
```

## DESCRIPTION
Return details of all delivery groups

- HTML Reports 	- When creating a HTML report: 	- The logo can be changed by replacing the variable  		- $Global:Logourl ='' 	- The colors of the report can be changed, by replacing: 		- $global:colour1 = '#061820' 		- $global:colour2 = '#FFD400' 	- Or permanently replace it by editing the following file 	- \<Module base\>\Private\Reports-Variables.ps1

## EXAMPLES

### Example 1
```
PS C:\> Get-CTXAPI_DeliveryGroups -CustomerId $CustomerId -SiteId $SiteID -ApiToken $ApiToken
```

delivery group settings

## PARAMETERS

### -APIHeader
Use Connect-CTXAPI to create headers

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
