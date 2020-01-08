using module .\..\..\internal\ParameterCompleters.ps1

Register-ArgumentCompleter `
    -CommandName Export-X509Certificate `
    -ParameterName FindBy `
    -ScriptBlock $FindByTypesCompleter

Register-ArgumentCompleter `
    -CommandName Export-X509Certificate `
    -ParameterName Value `
    -ScriptBlock $CertValueCompleter

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
        $FindByX = "FindBy$FindBy"
        
        if ($FindByX -eq 'FindBySubject') {
            $FindByX = 'FindBySubjectDistinguishedName'
        }

        if ($Value.Contains('*')) {
            Get-X509Certificates | Where-Object { $_.Subject -like $Value }
        }
        else {
            Open-X509Store

            Write-Debug "FindByX: FindBy$FindBy"
            Write-Debug "Value: $Value"
        
            $script:X509Store.Certificates.Find($FindByX, $Value, $false);

            Close-X509Store
        }
    }
}
