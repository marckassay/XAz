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
            HelpMessage = "The container registry names available from the current Azure subscription.",
            Position = 1
        )]
        [string]$ContainerRegistryName
    )

    begin {
        $PrivateCR = Get-AzContainerRegistry | Where-Object `
            -FilterScript { $_.Name -eq $ContainerRegistryName }

        if ($PrivateCR) {
            $PrivateCRCreds = Get-AzContainerRegistryCredential `
                -Registry $PrivateCR
        }
    }
    
    end {
        if ($PrivateCR) {
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
        else {
            Write-Warning "Unable to get credentials for '$ContainerRegistryName'"
        }
    }
}
