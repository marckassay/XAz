function Get-XAzContainerRegistryTags {

    [CmdletBinding(
        PositionalBinding = $true
    )]
    param(
        [Parameter(
            Mandatory = $true,
            HelpMessage = "The container registry names available from `$ResourceGroupName.",
            Position = 1
        )]
        [string]$ContainerRegistryName
    )

    begin {
        if (-not $PSBoundParameters.ContainsKey('Verbose')) {
            $VerbosePreference = $PSCmdlet.GetVariableValue('VerbosePreference')
        }
    }
    
    end {
        Write-Verbose "Searching for repositories and tags in the registry of: $ContainerRegistryName"
        $ProgessId = Get-Random -Minimum 1000
        Write-Progress -Activity "Searching for repositories and tags in the registry of: $ContainerRegistryName" -Id $ProgessId

        $Images = @()
        # TODO: would be nice to have this PS module not depend on az CLI. 
        az acr repository list -n $ContainerRegistryName | `
            ConvertFrom-Json | `
            ForEach-Object {

            # if fasley, then we're assuming that there is no repos in this registry
            if (-not $_) {
                Write-Warning "Found no repository in this registry."
                return
            }
            
            Write-Verbose "Found '$_' repository"

            $Tags = az acr repository show-tags -n $ContainerRegistryName --repository $_ | ConvertFrom-Json
            foreach ($Tag in $Tags) {
                $Images += $("$($_):$Tag")
            } 
        }

        Write-Progress -Activity ' ' -Completed -Id $ProgessId
        Write-Verbose "Completed repository search "

        $Images
    }
}
