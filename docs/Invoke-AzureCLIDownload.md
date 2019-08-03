---
external help file: XAz-help.xml
Module Name: XAz
online version: https://github.com/marckassay/XAz/blob/0.0.2/docs/Invoke-AzureCLIDownload.md
schema: 2.0.0
---

# Invoke-AzureCLIDownload

## SYNOPSIS
Downloads MSI for ['Azure CLI'](https://docs.microsoft.com/en-us/cli/azure/?view=azure-cli-latest) to the host computer.

## SYNTAX

```
Invoke-AzureCLIDownload [-Version] <String> [[-Path] <String>] [-AutoExecute] [<CommonParameters>]
```

## DESCRIPTION

Created due to [issue #607](https://github.com/MicrosoftDocs/azure-docs-cli/issues/607) of the Azure CLI doc site. Eventhough its closed, issue still seems to exists.

## EXAMPLES

### Example 1

```powershell
PS C:\> Invoke-AzureCLIDownload -Version 2.0.70
```

Downloads specified version to the current location.

### Example 2

```powershell
PS C:\> Invoke-AzureCLIDownload -Version 2.0.70 -AutoExecute
```

Downloads specified version to the current location and will execute to initiate the installer.

### Example 3

```powershell
PS C:\> Invoke-AzureCLIDownload -Version 2.0.70 -Path C:\temp
```

Downloads specified version to `C:\temp` location on host computer.

## PARAMETERS

### -AutoExecute

Executes to initiate the installer after download.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path

The location where the file will be downloaded.

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

### -Version

The Azure CLI semver.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

[Invoke-AzureCLIDownload.ps1](https://github.com/marckassay/XAz/blob/0.0.2/src/utility/Invoke-AzureCLIDownload.ps1)

[Invoke-AzureCLIDownload.Tests.ps1](https://github.com/marckassay/XAz/blob/0.0.2/test/utility/Invoke-AzureCLIDownload.Tests.ps1)
