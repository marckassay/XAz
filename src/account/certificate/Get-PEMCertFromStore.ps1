using module .\..\..\internal\ParameterCompleters.ps1

Register-ArgumentCompleter `
    -CommandName Get-PEMCertFromStore `
    -ParameterName StoreName `
    -ScriptBlock $StoreNamesCompleter

Register-ArgumentCompleter `
    -CommandName Get-PEMCertFromStore `
    -ParameterName StoreLocation `
    -ScriptBlock $StoreLocationsCompleter

Register-ArgumentCompleter `
    -CommandName Get-PEMCertFromStore `
    -ParameterName OpenPolicy `
    -ScriptBlock $OpenPoliciesCompleter

Register-ArgumentCompleter `
    -CommandName Get-PEMCertFromStore `
    -ParameterName FindBy `
    -ScriptBlock $FindByTypesCompleter

function Get-PEMCertFromStore {
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
        [string]$Value,

        [Parameter(
            Mandatory = $false,
            HelpMessage = "The StoreName enum member of X509Certificates.",
            Position = 3
        )]
        [string]$StoreName = 'My',

        [Parameter(
            Mandatory = $false,
            HelpMessage = "The StoreLocation enum member of X509Certificates.",
            Position = 4
        )]
        [string]$StoreLocation = 'CurrentUser',

        [Parameter(
            Mandatory = $false,
            HelpMessage = "The OpenFlags enum member of X509Certificates.",
            Position = 5
        )]
        [string]$OpenPolicy = 'ReadWrite'
    )
    
    end {
        New-TemporaryFile -OutVariable TempFile | Out-Null
        
        Open-X509Store -StoreName $StoreName -StoreLocation $StoreLocation -OpenPolicy $OpenPolicy | `
            Export-X509Certificate -FindBy $FindBy -Value $Value | `
            ConvertTo-PEMCertificate | `
            Set-Content -Path $TempFile.FullName -Encoding utf8

        Close-X509Store
        
        $TempFile
    }
}
