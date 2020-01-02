using module .\..\..\internal\ParameterCompleters.ps1

Register-ArgumentCompleter `
    -CommandName Open-X509Store `
    -ParameterName StoreName `
    -ScriptBlock $StoreNamesCompleter

Register-ArgumentCompleter `
    -CommandName Open-X509Store `
    -ParameterName StoreLocation `
    -ScriptBlock $StoreLocationsCompleter

Register-ArgumentCompleter `
    -CommandName Open-X509Store `
    -ParameterName OpenPolicy `
    -ScriptBlock $OpenPoliciesCompleter

function Open-X509Store {
    [CmdletBinding(
        PositionalBinding = $true
    )]
    Param(
        [Parameter(
            Mandatory = $false,
            HelpMessage = "The StoreName enum member of X509Certificates.",
            Position = 1
        )]
        [string]$StoreName = 'My',

        [Parameter(
            Mandatory = $false,
            HelpMessage = "The StoreLocation enum member of X509Certificates.",
            Position = 2
        )]
        [string]$StoreLocation = 'CurrentUser',

        [Parameter(
            Mandatory = $false,
            HelpMessage = "The OpenFlags enum member of X509Certificates.",
            Position = 3
        )]
        [string]$OpenPolicy = 'ReadWrite'
    )

    end {
        $script:X509Store = [System.Security.Cryptography.X509Certificates.X509Store]::new($StoreName, $StoreLocation)
        $script:X509Store.Open($OpenPolicy)
    }
}
