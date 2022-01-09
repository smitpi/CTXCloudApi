---
external help file: CTXCloudApi-help.xml
Module Name: CTXCloudApi
online version: https://smitpi.github.io/CTXCloudApi/#Get-CTXAPI_Tests
schema: 2.0.0
---

# Get-CTXAPI_Tests

## SYNOPSIS
Run Built in Citrix cloud tests

## SYNTAX

```
Get-CTXAPI_Tests [[-APIHeader] <Object>] [-SiteTest] [-HypervisorsTest] [-DeliveryGroupsTest]
 [-MachineCatalogsTest] [[-Export] <String>] [[-ReportPath] <String>] [<CommonParameters>]
```

## DESCRIPTION
Run Built in Citrix cloud tests

## EXAMPLES

### EXAMPLE 1
```
Get-CTXAPI_Tests -APIHeader $APIHeader -SiteTest -HypervisorsTest -DeliveryGroupsTest -MachineCatalogsTest -Export HTML -ReportPath C:\temp
```

## PARAMETERS

### -APIHeader
Use Connect-CTXAPI to create headers

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

### -SiteTest
Perform Site test

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

### -HypervisorsTest
Perform the Hypervisors Test

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

### -DeliveryGroupsTest
Perform the Delivery Groups Test

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

### -MachineCatalogsTest
Perform the Machine Catalogs Test

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

### -Export
In what format to export the reports.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Host
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReportPath
Destination folder for the exported report.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: $env:temp
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Collections.Hashtable
## NOTES

## RELATED LINKS
