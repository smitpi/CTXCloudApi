---
external help file: CTXCloudApi-help.xml
Module Name: CTXCloudApi
online version:
schema: 2.0.0
---

# Set-CTXAPI_DefaultParameters

## SYNOPSIS
Adds the variables in a persistent hash table

## SYNTAX

```
Set-CTXAPI_DefaultParameters [[-CustomerId] <String>] [[-ClientId] <String>] [[-ClientSecret] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Adds the variables in a persistent hash table

## EXAMPLES

### Example 1
```powershell
PS C:\>  Set-CTXAPI_DefaultParameters -CustomerId vvv -ClientId yyy -ClientSecret uuu
Get-CTXAPI_Token

    PS V:\CloudStorage\Dropbox\#Profile\Documents\PowerShell\Github\CTXCloudApi> $CTX_APIDefaultParm

Name                           Value
----                           -----
CustomerId                     vouiv8idvkid
SiteId                         8fbd6487-30
ApiToken                       eyJhbGciOiJ



PS V:\CloudStorage\Dropbox\#Profile\Documents\PowerShell\Github\CTXCloudApi> $CTX_APIAllParm

Name                           Value
----                           -----
ClientId                       2d73361c-477b-43da-b301-d30ef4ee22db
CustomerId                     vouiv8idvkid
ApiToken                       eyJhbGciOiJSUzI1NiIsInR5cCI6IkpX
SiteId                         8fbd6487-3077-472a-a39c-56bcae3bf172
ClientSecret                   dEXtv9YWeZWV0BKUCJWx9w==
ReportPath                     C:\Users\ps\AppData\Local\Temp
```

Creates these hashtables to use in other commands

## PARAMETERS

### -ClientId

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ClientSecret

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CustomerId

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
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
