$ContainerRegistryNameCompleter = {
    param ( 
        $commandName,
        $parameterName,
        $wordToComplete,
        $commandAst,
        $fakeBoundParameters
    )
    
    return Get-AzContainerRegistry | Select-Object -ExpandProperty Name
}

# TODO: contains a module dependency
<# $ImageCompleter = {
    param ( 
        $commandName,
        $parameterName,
        $wordToComplete,
        $commandAst,
        $fakeBoundParameters
    )
    
    $possibleValues = Get-DockerImage
    
    if ($fakeBoundParameters.ContainsKey('ContainerRegistryName')) {
        $ContainerRegistryName = $fakeBoundParameters.ContainerRegistryName
        
        $possibleValues | Where-Object -FilterScript {
            $_.ImageName -like "$ContainerRegistryName*" 
        } | ForEach-Object {
            ($_.ImageName).Split('/', 2)[1]
        }
    }
    else {
        $possibleValues.Values | ForEach-Object { $_ }
    }
}
 #>
$TemplateNameCompleter = {
    param ( 
        $commandName,
        $parameterName,
        $wordToComplete,
        $commandAst,
        $fakeBoundParameters
    )
    
    return Get-Item .\build\templates\* -Include *.json | Select-Object -ExpandProperty Name
}

$ResourceGroupNameCompleter = {
    param ( 
        $commandName,
        $parameterName,
        $wordToComplete,
        $commandAst,
        $fakeBoundParameters
    )
    
    return Get-AzResourceGroup | Select-Object -ExpandProperty ResourceGroupName
}

$StoreNamesCompleter = {
    param ( 
        $commandName,
        $parameterName,
        $wordToComplete,
        $commandAst,
        $fakeBoundParameters
    )

    return [System.Security.Cryptography.X509Certificates.StoreName].GetEnumNames()
}

$StoreLocationsCompleter = {
    param ( 
        $commandName,
        $parameterName,
        $wordToComplete,
        $commandAst,
        $fakeBoundParameters
    )

    return [System.Security.Cryptography.X509Certificates.StoreLocation].GetEnumNames()
}

$OpenPoliciesCompleter = {
    param ( 
        $commandName,
        $parameterName,
        $wordToComplete,
        $commandAst,
        $fakeBoundParameters
    )

    return [System.Security.Cryptography.X509Certificates.OpenFlags].GetEnumNames()
}

<#
returns:
    Thumbprint
    SubjectName
    SubjectDistinguishedName
    IssuerName
    IssuerDistinguishedName
    SerialNumber
    TimeValid
    TimeNotYetValid
    TimeExpired
    TemplateName
    ApplicationPolicy
    CertificatePolicy
    Extension
    KeyUsage
    SubjectKeyIdentifier
#>
$FindByTypesCompleter = {
    param ( 
        $commandName,
        $parameterName,
        $wordToComplete,
        $commandAst,
        $fakeBoundParameters
    )

    return [System.Security.Cryptography.X509Certificates.X509FindType].GetEnumNames() | `
        Where-Object { ($_ -like '*Thumbprint') -or ($_ -like '*SubjectDistinguish*') } | `
        ForEach-Object { if ($_ -like '*SubjectDistinguish*') { return 'FindBySubject' } else { $_ } } | `
        ForEach-Object { $_.Split('FindBy')[1] }
}

$CertValueCompleter = {
    param ( 
        $commandName,
        $parameterName,
        $wordToComplete,
        $commandAst,
        $fakeBoundParameters
    )
    
    $possibleValues = Get-X509Certificates
    
    # the $fakeBoundParameters values are: 'FindBy' and 'Value'
    if ($fakeBoundParameters.ContainsKey('FindBy')) {
        
        # $FindByPropName is one of the values from $CertValueCompleter
        $FindByPropName = $fakeBoundParameters.FindBy

        if ($FindByPropName -eq 'Thumbprint') {

            # for the following line, $wordToComplete is perhaps a partial value of a cert's Thumbprint 
            $possibleValues | `
                Where-Object { $_.Thumbprint -like "$wordToComplete*" } | `
                Select-Object -ExpandProperty Thumbprint
        }
        elseif ($FindByPropName -eq 'Subject') {

            # since without the following ForEach-Object, values are returned without quotes. it seems
            # easier to read with quotes; hence the single-quotes
            $possibleValues | `
                Where-Object { $_.Subject -like "$wordToComplete*" } | `
                Select-Object -ExpandProperty Subject | `
                ForEach-Object { "'$_'" }
        }
    }
}