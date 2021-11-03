---
external help file: CTXCloudApi-help.xml
Module Name: CTXCloudApi
online version:
schema: 2.0.0
---

# Get-CTXAPI_Applications

## SYNOPSIS
Returns a list of published Apps

## SYNTAX

```
Get-CTXAPI_Applications -APIHeader <Object> [<CommonParameters>]
```

## DESCRIPTION
Returns a list of published Apps

## EXAMPLES

### Example 1
```
PS C:\>  Get-CTXAPI_Applications -APIHeader $APIHeader

Details about each app
@{Id=0; Uid=0; Name=}
ApplicationType                 : HostedOnDesktop
ClientFolder                    : 
ContainerScopes                 : {@{Scopes=System.Object[]; ScopeType=ApplicationGroup}, @{Scopes=System.Object[]; ScopeType=DeliveryGroup}}
Description                     : KEYWORDS:AUTO
Enabled                         : True
IconId                          : 49
InstalledAppProperties          : @{CommandLineArguments=; CommandLineExecutable=C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE; WorkingDirectory=}
AppVAppProperties               : 
ContentLocation                 : 
Name                            : Word PROD 2016 -
PublishedName                   : Word
Visible                         : True
SharingKind                     : Unknown
Tags                            : {}
Tenants                         : 
CloudWorkspaceManaged           : False
NumAssociatedDeliveryGroups     : 1
NumAssociatedApplicationGroups  : 0
AssociatedDeliveryGroupUuids    : {6fcefefb-1ade-455d-8553-9b916af11579}
AssociatedApplicationGroupUuids : {}
ZoneId                          :
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
