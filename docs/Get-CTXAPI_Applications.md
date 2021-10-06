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
Get-CTXAPI_Applications [-CustomerId] <String> [-SiteId] <String> [-ApiToken] <String> [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### Example 1
```powershell
PS C:\>  Get-CTXAPI_Applications -CustomerId $CustomerId -SiteId $SiteID -ApiToken $ApiToken

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

{{ Add example description here }}

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
