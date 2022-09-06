---
external help file: CTXCloudApi-help.xml
Module Name: CTXCloudApi
online version:
schema: 2.0.0
---

# Add-CTXAPI_DefaultsToProfile

## SYNOPSIS
This function will add connection settings to PSDefaultParameter and your profile.

## SYNTAX

```
Add-CTXAPI_DefaultsToProfile [-Customer_Id] <String> [-Client_Id] <String> [-Client_Secret] <String>
 [-Customer_Name] <String> [-RemoveConfig] [<CommonParameters>]
```

## DESCRIPTION
This function will add connection settings to PSDefaultParameter and your profile.

## EXAMPLES

### EXAMPLE 1
```
$splat = @{
```

Customer_Id = "xxx"
	Client_Id = "xxx-xxx-xxx-xxx"
	Client_Secret = "yyyyyy=="
	Customer_Name = 'HomeLab'
}
Add-CTXAPI_DefaultsToProfile @splat

## PARAMETERS

### -Customer_Id
From Citrix Cloud

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

### -Client_Id
From Citrix Cloud

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

### -Client_Secret
From Citrix Cloud

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

### -Customer_Name
Name of your Company, or what you want to call your connection.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RemoveConfig
Remove the config from your profile.

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
