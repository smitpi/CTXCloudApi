---
external help file: CTXCloudApi-help.xml
Module Name: CTXCloudApi
online version:
schema: 2.0.0
---

# Get-CTXAPI_ConfigLog

## SYNOPSIS
Reports on changes in the environment

## SYNTAX

```
Get-CTXAPI_ConfigLog [-CustomerId] <String> [-SiteId] <String> [-Days] <String> [-ApiToken] <String>
 [<CommonParameters>]
```

## DESCRIPTION
Reports on changes in the environment
- HTML Reports
	- When creating a HTML report:
	- The logo can be changed by replacing the variable 
		- $Global:Logourl =''
	- The colors of the report can be changed, by replacing:
		- $global:colour1 = '#061820'
		- $global:colour2 = '#FFD400'
	- Or permanently replace it by editing the following file
	- <Module base>\Private\Reports-Variables.ps1

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-CTXAPI_ConfigLog -CustomerId $CustomerId -SiteId $SiteID -ApiToken $ApiToken -Days 7


Id                 : 6a657368-873b-4379-ab9e-6a1f8aa73b03
AdminMachineIP     : 
EndTime            : 9/29/2021 2:01:44 PM
FormattedEndTime   : 2021-09-29T14:01:44Z
IsSuccessful       : True
OperationType      : AdminActivity
Parameters
```

## PARAMETERS

### -ApiToken
 Generate token with Get-CTXAPI_Token

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

### -CustomerId
 From Citrix Cloud Portal

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Days
The amount of days of changes to report


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

### -SiteId
 Generate id with Get-CTXAPI_SiteID

```yaml
Type: String
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

### None
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
