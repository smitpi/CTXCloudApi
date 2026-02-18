---
external help file: CTXCloudApi-help.xml
Module Name: CTXCloudApi
online version:
schema: 2.0.0
---

# Connect-CTXAPI

## SYNOPSIS
Connects to Citrix Cloud and creates required API headers.

## SYNTAX

```
Connect-CTXAPI [-Customer_Id] <String> [-Client_Id] <String> [-Client_Secret] <String>
 [-Customer_Name] <String> [<CommonParameters>]
```

## DESCRIPTION
Authenticates to Citrix Cloud using Client Id/Secret, resolves the CVAD Instance Id, and returns a CTXAPIHeaderObject containing headers and context for other CTXCloudApi cmdlets.

## EXAMPLES

### EXAMPLE 1
```
$splat = @{
	Customer_Id   = "xxx"
	Client_Id     = "xxx-xxx-xxx-xxx"
	Client_Secret = "yyyyyy=="
	Customer_Name = 'HomeLab'
}
$APIHeader = Connect-CTXAPI @splat
```

### EXAMPLE 2
```
Connect-CTXAPI -Customer_Id "xxx" -Client_Id "xxx-xxx" -Client_Secret "yyyyyy==" -Customer_Name "Prod"
```
Creates and returns a CTXAPIHeaderObject. Store it (e.g., $APIHeader) and pass to other cmdlets.

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
None

## OUTPUTS
CTXAPIHeaderObject

Contains authentication headers and context (CustomerName, TokenExpireAt, CTXAPI fields) for CTXCloudApi cmdlets.

## NOTES

## RELATED LINKS
