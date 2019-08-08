using module .\..\internal\ParameterCompleters.ps1

Register-ArgumentCompleter `
    -CommandName Get-XAzRegistryCredentials `
    -ParameterName ContainerRegistryName `
    -ScriptBlock $ContainerRegistryNameCompleter

function Get-XAzRegistryCredentials {

    <##
    .SYNOPSIS
    Makes 2 Az function calls to get Azure Container Registry credentials.
    
    .DESCRIPTION
    The returned object is a hashtable that contains an Image array. That array is in the shape of 
    ImageRegistryCredentials object which is used in ARM templates.
    
    .PARAMETER ContainerRegistryName
    Autocompleter enabled. The container name to retrieve the credentials from.
    
    .EXAMPLE
    An example
    
    .NOTES
    General notes
    #>
    
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
