---
external help file: XAz-help.xml
Module Name: XAz
online version: https://github.com/marckassay/XAz/blob/0.0.3/docs/New-SelfSignedCert.md
schema: 2.0.0
---

# New-SelfSignedCert

## SYNOPSIS
Creates a self-signed certificate using `openssl`.

## SYNTAX

### ExpiresInYears
```
New-SelfSignedCert [[-OutPath] <String>] [-Years] <Int32> [<CommonParameters>]
```

### ExpiresInDays
```
New-SelfSignedCert [[-OutPath] <String>] [-Days] <Int32> [<CommonParameters>]
```

## DESCRIPTION
When called, it will execute `openssl` which will step thru the process of creating a SSL certificate. Afterwards this function will output a hashtable with a key and crt property that contains the private key and certificate, respectively.

## EXAMPLES

### EXAMPLE 1
```
New-SelfSignedCert -OutPath .\certs\ -Years 10
```

## PARAMETERS

### -OutPath
Parameter description

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: .
Accept pipeline input: False
Accept wildcard characters: False
```

### -Years
Parameter description

```yaml
Type: Int32
Parameter Sets: ExpiresInYears
Aliases:

Required: True
Position: 2
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Days
Parameter description

```yaml
Type: Int32
Parameter Sets: ExpiresInDays
Aliases:

Required: True
Position: 2
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.String

## NOTES
General notes

## RELATED LINKS
