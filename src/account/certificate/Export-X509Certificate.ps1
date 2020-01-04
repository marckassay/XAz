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
        $CloseAfter = $false

        if (($null -eq $script:X509Store) -or ($script:X509Store.IsOpen -eq $false)) {
            $CloseAfter = $true
            Open-X509Store
        }

        $script:X509Store.Certificates.Find($FindBy, $Value, $false);

        if ($CloseAfter -eq $true) {
            Close-X509Store
        }
    }
}
