---
external help file: CTXCloudApi-help.xml
Module Name: CTXCloudApi
online version: https://smitpi.github.io/CTXCloudApi/#Set-CTXAPI_ReportColors
schema: 2.0.0
---

# Set-CTXAPI_ReportColors

## SYNOPSIS
Set the color and logo for HTML Reports

## SYNTAX

```
Set-CTXAPI_ReportColors [[-Color1] <String>] [[-Color2] <String>] [[-LogoURL] <String>] [<CommonParameters>]
```

## DESCRIPTION
Set the color and logo for HTML Reports.
It updates the registry keys in HKCU:\Software\CTXCloudApi with the new details and display a test report.

## EXAMPLES

### EXAMPLE 1
```
Set-CTXAPI_ReportColors -Color1 '#d22c26' -Color2 '#2bb74e' -LogoURL 'https://gist.githubusercontent.com/default-monochrome.png'
```

## PARAMETERS

### -Color1
New Background Color # code

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: #061820
Accept pipeline input: False
Accept wildcard characters: False
```

### -Color2
New foreground Color # code

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: #FFD400
Accept pipeline input: False
Accept wildcard characters: False
```

### -LogoURL
URL to the new Logo

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: Https://c.na65.content.force.com/servlet/servlet.ImageServer?id=0150h000003yYnkAAE&oid=00DE0000000c48tMAA
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
