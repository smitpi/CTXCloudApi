---
external help file: CTXCloudApi-help.xml
Module Name: CTXCloudApi
online version:
schema: 2.0.0
---

# Get-CTXAPI_SiteDetails

## SYNOPSIS
Retrieve Site / Farm details
## SYNTAX

```
Get-CTXAPI_SiteDetails [-CustomerId] <String> [-SiteId] <String> [-ApiToken] <String> [<CommonParameters>]
```

## DESCRIPTION
Retrieve Site / Farm details

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-CTXAPI_SiteDetails @CTX_APIDefaultParm



LicenseServerName                           : 
LicenseServerPort                           : 
LicenseServerUri                            : 
LicensingModel                              : UserDevice
SiteConfigurationComplete                   : True
PrimaryZone                                 : @{Id=00000000-0000-0000-0000-000000000000; Uid=; Name=Initial Zone}
ProductCode                                 : Unknown
ProductEdition                              : Unknown
ProductVersion                              : 7.29
SiteServices                                : {@{ServiceName=Delegated Administration; ServiceType=Admin; CurrentSchemaVersion=; DesiredSchemaVersion=; Capabilities=System.Object[]}, @{ServiceName=Configuration; ServiceType=Config; 
     
```


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
