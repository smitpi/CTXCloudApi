---
external help file: CTXCloudApi-help.xml
Module Name: CTXCloudApi
online version:
schema: 2.0.0
---

# Get-CTXAPI_ResourceLocation

## SYNOPSIS
Details about the resource locations 

## SYNTAX

```
Get-CTXAPI_ResourceLocation [-CustomerId] <String> [-ApiToken] <String> [<CommonParameters>]
```

## DESCRIPTION
Details about the resource locations 
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
PS C:\> Get-CTXAPI_ResourceLocation -CustomerId $CustomerId -SiteId $SiteID -ApiToken $ApiToken



id           : 3452204b0fa
name         : Azure EU North (DR)
internalOnly : False
timeZone     : GMT Standard Time
readOnly     : False

id           : 6037c58f
name         : Azure EU West (Production)
internalOnly : False
timeZone     : South Africa Standard Time
readOnly     : False

id           : 9960d851
name         : Dubai
internalOnly : False
timeZone     : Arabian Standard Time
readOnly     : False
```

{{ Add example description here }}

## PARAMETERS

### -ApiToken
 Generate token with Get-CTXAPI_Token

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
