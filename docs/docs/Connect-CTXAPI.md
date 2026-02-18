---
external help file: CTXCloudApi-help.xml
Module Name: CTXCloudApi
online version: https://smitpi.github.io/CTXCloudApi/Connect-CTXAPI
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
Authenticates against Citrix Cloud using \`Client_Id\` and \`Client_Secret\`, resolves the CVAD \`Citrix-InstanceId\`, and constructs headers for subsequent CTXCloudApi requests.
Returns a \`CTXAPIHeaderObject\` containing \`CustomerName\`, \`TokenExpireAt\` (about 1 hour), \`CTXAPI\` (ids), and \`headers\`.

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

### EXAMPLE 2
```
Connect-CTXAPI -Customer_Id "xxx" -Client_Id "xxx-xxx" -Client_Secret "yyyyyy==" -Customer_Name "Prod"
```

Creates and returns a \`CTXAPIHeaderObject\`.
Store it in a variable (e.g., \`$APIHeader\`) and pass to other cmdlets.

## PARAMETERS

### -Customer_Id
Citrix Customer ID (GUID) from the Citrix Cloud console.

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
OAuth Client ID created under Citrix Cloud API access.

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
OAuth Client Secret for the above Client ID.

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
Display name used in reports/filenames to identify this connection.

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

### None. Parameters are not accepted from the pipeline.
## OUTPUTS

### CTXAPIHeaderObject. Contains authentication headers and context for CTXCloudApi cmdlets.
## NOTES
The access token typically expires in ~1 hour.
Re-run Connect-CTXAPI to refresh headers when needed.

## RELATED LINKS

[https://smitpi.github.io/CTXCloudApi/Connect-CTXAPI](https://smitpi.github.io/CTXCloudApi/Connect-CTXAPI)

