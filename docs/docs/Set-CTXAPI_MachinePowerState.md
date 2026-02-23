---
external help file: CTXCloudApi-help.xml
Module Name: CTXCloudApi
online version: https://smitpi.github.io/CTXCloudApi/New-CTXAPI_Machine
schema: 2.0.0
---

# Set-CTXAPI_MachinePowerState

## SYNOPSIS
Starts, shuts down, restarts, or logs off Citrix machines via CTX API.

## SYNTAX

```
Set-CTXAPI_MachinePowerState [-APIHeader] <Object> [-Name <String[]>] [-PowerAction <String>]
 [<CommonParameters>]
```

## DESCRIPTION
This function allows you to remotely control the power state of Citrix machines using the CTX API.
You can start, shut down, restart, or log off one or more machines by specifying their name, DNS name, or ID.

## EXAMPLES

### EXAMPLE 1
```
Set-CTXAPI_MachinePowerState -APIHeader $header -Name "CTX-Machine01" -PowerAction Start
```

Starts the specified Citrix Machine.

### EXAMPLE 2
```
Set-CTXAPI_MachinePowerState -APIHeader $header -Name "CTX-Machine01","CTX-Machine02" -PowerAction Shutdown
```

Shuts down multiple Citrix Machines.

## PARAMETERS

### -APIHeader
The CTX API authentication header object (type CTXAPIHeaderObject) required for API calls.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name, DNS name, or ID of the Citrix Machine(s) to target.
Accepts an array of strings.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: DNSName, Id

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -PowerAction
The desired power action to perform.
Valid values: Start, Shutdown, Restart, Logoff.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Object[]. Returns the API response objects for each machine processed.
## NOTES

## RELATED LINKS
