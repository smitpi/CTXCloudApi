---
external help file: CTXCloudApi-help.xml
Module Name: CTXCloudApi
online version:
schema: 2.0.0
---

# Get-CTXAPI_Test

## SYNOPSIS
Run Built in Citrix cloud tests

## SYNTAX

```
Get-CTXAPI_Test [[-APIHeader] <Object>] [-SiteTest] [-HypervisorsTest] [-DeliveryGroupsTest]
 [-MachineCatalogsTest] [[-Export] <String>] [[-ReportPath] <String>] [<CommonParameters>]
```

## DESCRIPTION
Run Built in Citrix cloud tests

## EXAMPLES

### EXAMPLE 1
```
Get-CTXAPI_Test
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
Config Audit

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
Config Audit

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
Config Audit

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
Config Audit

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
Config Audit

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
Config Audit

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
Detail on what the script does, if this is needed.

## RELATED LINKS
