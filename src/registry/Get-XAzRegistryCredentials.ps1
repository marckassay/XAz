using module .\..\internal\ParameterCompleters.ps1

Register-ArgumentCompleter `
    -CommandName Get-XAzRegistryCredentials `
    -ParameterName ContainerRegistryName `
    -ScriptBlock $ContainerRegistryNameCompleter

function Get-XAzRegistryCredentials {
    
    [CmdletBinding(
        PositionalBinding = $true
    )]
    param(
        [Parameter(
            Mandatory = $true,
            HelpMessage = "The resource group names available from the current Azure subscription.",
            Position = 1
        )]
        [string]$ContainerRegistryName
    )

    begin {
        $PrivateCR = Get-AzContainerRegistry | Where-Object `
            -FilterScript { $_.Name -eq $ContainerRegistryName }

        $PrivateCRCreds = Get-AzContainerRegistryCredential `
            -Registry $PrivateCR
    }
    
    end {
        # dont add 'password2' field on this object since it will fail the deployment
        @{
            ResourceGroupName = $PrivateCR.ResourceGroupName
            Image             = @(@{
                    server   = $PrivateCR.LoginServer
                    username = $PrivateCRCreds.Username
                    password = $PrivateCRCreds.Password
                })
        }
    }
}
