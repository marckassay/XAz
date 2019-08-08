---
external help file: XAz-help.xml
Module Name: XAz
online version: https://github.com/marckassay/XAz/blob/0.0.3/docs/ConvertTo-Base64.md
schema: 2.0.0
---

# ConvertTo-Base64

## SYNOPSIS
Streams file content into the GNU base64 executeable that is bundled with Git.

## SYNTAX

### ByPipeline (Default)
```
ConvertTo-Base64 [<CommonParameters>]
```

### ByPath
```
ConvertTo-Base64 [-Path] <String[]> [<CommonParameters>]
```

## DESCRIPTION
Long description

## EXAMPLES

### EXAMPLE 1
```
[string]$KeyContent = ConvertTo-Base64 -Path $(Resolve-Path -Path $SslKeyPath)
```

Noticed that the variable is casted to string.
That is deliberate since if it was going to be piped
some bad mojo happens.

## PARAMETERS

### -Path
Parameter description

```yaml
Type: String[]
Parameter Sets: ByPath
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

## OUTPUTS

## NOTES
General notes

## RELATED LINKS
