---
external help file: XAz-help.xml
Module Name: XAz
online version: https://github.com/marckassay/XAz/blob/0.0.3/docs/New-XAzResourceGroupDeployment.md
schema: 2.0.0
---

# New-XAzResourceGroupDeployment

## SYNOPSIS
 Creates (or updates) a resource deployment under the resource group specified by the `ContainerRegistryName` parameter.

## SYNTAX

### ByTemplateName
```
New-XAzResourceGroupDeployment [-TemplateParameterObject <Hashtable>] [-ContainerRegistryName] <String>
 [-Image] <String> [-TemplateName] <String> [[-Name] <String>] [[-Mode] <String>] [-AsJob] [-Force] [-WhatIf]
 [<CommonParameters>]
```

### ByTemplateFile
```
New-XAzResourceGroupDeployment [-TemplateParameterObject <Hashtable>] [-ContainerRegistryName] <String>
 [-Image] <String> [-TemplateFile] <String> [[-Name] <String>] [[-Mode] <String>] [-AsJob] [-Force] [-WhatIf]
 [<CommonParameters>]
```

## DESCRIPTION
Before calling this function, the PS session must have a current Azure session. Check by verifying that Get-AzSubscription returns a value. The `$ContainerRegistryName` parameter specifies which Resource Group to use by name from the current Azure subscription.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -AsJob
{{Fill AsJob Description}}

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

### -Force
{{Fill Force Description}}

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

### -Image
The image in the container registry.
This defined set is determined by the

ContainerRegistryName parameter.

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

### -Mode
Specifies the deployment mode. The acceptable values for this parameter are: Complete and Incremental

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Incremental, Complete

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Specifies the name of the resource group deployment to create. A name will be generated if one isn't given.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TemplateFile
The location of a Template file.

```yaml
Type: String
Parameter Sets: ByTemplateFile
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TemplateName
The file names of Json files located in the ${PWD}/build/templates folder.

```yaml
Type: String
Parameter Sets: ByTemplateName
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TemplateParameterObject
The resource group names available from the current Azure subscription.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs. The cmdlet is not run.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Collections.Hashtable

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
