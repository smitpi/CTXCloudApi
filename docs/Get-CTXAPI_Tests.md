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
Get-CTXAPI_SiteDetails -APIHeader <Object> [<CommonParameters>]
```

## DESCRIPTION
Retrieve Site / Farm details

## EXAMPLES

### Example 1
```
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

### -APIHeader
Use Connect-CTXAPI to create headers


```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
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
