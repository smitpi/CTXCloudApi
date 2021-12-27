---
external help file: CTXCloudApi-help.xml
Module Name: CTXCloudApi
online version: https://smitpi.github.io/CTXCloudApi/#Connect-CTXAPI
schema: 2.0.0
---

# Connect-CTXAPI

## SYNOPSIS
Connect to the cloud and create needed api headers

## SYNTAX

```
Connect-CTXAPI [-Customer_Id] <String> [-Client_Id] <String> [-Client_Secret] <String>
 [-Customer_Name] <String> [<CommonParameters>]
```

## DESCRIPTION
Connect to the cloud and create needed api headers

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
$APIHeader = Connect-CTXAPI @splat

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
Name of your Company, or what you want to call your connection

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
