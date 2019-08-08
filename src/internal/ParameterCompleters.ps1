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

$ImageCompleter = {
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

Export-ModuleMember -Variable ContainerRegistryNameCompleter, ImageCompleter, TemplateNameCompleter
