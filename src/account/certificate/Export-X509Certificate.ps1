using module .\..\..\internal\ParameterCompleters.ps1

Register-ArgumentCompleter `
    -CommandName Export-X509Certificate `
    -ParameterName FindBy `
    -ScriptBlock $FindByTypesCompleter

function Export-X509Certificate {
    [CmdletBinding(
        PositionalBinding = $false
    )]
    Param(
        [Parameter(
            Mandatory = $true,
            HelpMessage = "The method of searching in the store, using the parameter Value.",
            Position = 1
        )]
        [string]$FindBy,

        [Parameter(
            Mandatory = $true,
            HelpMessage = "The value to be used when searching in the store.",
            Position = 2
        )]
        [string]$Value
    )
    
    end {
        if (($null -ne $script:X509Store) -and ($script:X509Store.IsOpen -eq $true)) {
            $script:X509Store.Certificates.Find($FindBy, $Value, $false);
        }
    }
}
