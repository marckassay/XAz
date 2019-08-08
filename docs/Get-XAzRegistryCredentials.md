---
external help file: XAz-help.xml
Module Name: XAz
online version: https://github.com/marckassay/XAz/blob/0.0.3/docs/Get-XAzRegistryCredentials.md
schema: 2.0.0
---

# Get-XAzRegistryCredentials

## SYNOPSIS
Makes 2 Az function calls to get Azure Container Registry credentials.

## SYNTAX

```
Get-XAzRegistryCredentials [-ContainerRegistryName] <String> [<CommonParameters>]
```

## DESCRIPTION
The returned object is a hashtable that contains an Image array. That array is in the shape of `ImageRegistryCredentials` object which is used in ARM templates.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -ContainerRegistryName
Autocompleter enabled. The container name to retrieve the credentials from.

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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
