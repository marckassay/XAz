using module .\..\..\internal\ParameterCompleters.ps1

Register-ArgumentCompleter `
    -CommandName Get-PEMCertificate `
    -ParameterName StoreName `
    -ScriptBlock $StoreNamesCompleter

Register-ArgumentCompleter `
    -CommandName Get-PEMCertificate `
    -ParameterName StoreLocation `
    -ScriptBlock $StoreLocationsCompleter

Register-ArgumentCompleter `
    -CommandName Get-PEMCertificate `
    -ParameterName OpenPolicy `
    -ScriptBlock $OpenPoliciesCompleter

Register-ArgumentCompleter `
    -CommandName Get-PEMCertificate `
    -ParameterName FindBy `
    -ScriptBlock $FindByTypesCompleter

Register-ArgumentCompleter `
    -CommandName Get-PEMCertificate `
    -ParameterName Value `
    -ScriptBlock $CertValueCompleter

function Get-PEMCertificate {
    [CmdletBinding(
        PositionalBinding = $false,
        DefaultParameterSetName = "ByStore"
    )]
    Param(
        [Parameter(
            Mandatory = $true,
            HelpMessage = "The method of searching in the store, using the parameter Value.",
            Position = 1,
            ParameterSetName = 'ByStore'
        )]
        [string]$FindBy,

        [Parameter(
            Mandatory = $true,
            HelpMessage = "The method of searching in the store, using the parameter Value.",
            Position = 1,
            ParameterSetName = 'ByCertificate'
        )]
        [object]$Certificate,

        [Parameter(
            Mandatory = $true,
            HelpMessage = "The value to be used when searching in the store.",
            Position = 2,
            ParameterSetName = 'ByStore'
        )]
        [string]$Value,

        [Parameter(
            Mandatory = $false,
            HelpMessage = "The StoreName enum member of X509Certificates.",
            Position = 3,
            ParameterSetName = 'ByStore'
        )]
        [string]$StoreName = 'My',

        [Parameter(
            Mandatory = $false,
            HelpMessage = "The StoreLocation enum member of X509Certificates.",
            Position = 4,
            ParameterSetName = 'ByStore'
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

        if (-not $Certificate) {
            Open-X509Store -StoreName $StoreName -StoreLocation $StoreLocation -OpenPolicy $OpenPolicy
            
            Export-X509Certificate -FindBy $FindBy -Value $Value | `
                ConvertTo-PEMCertificateString | `
                Set-Content -Path $TempFile.FullName -Encoding utf8 -NoNewline

            Close-X509Store
        }
        else {
            $Certificate | `
                ConvertTo-PEMCertificateString | `
                Set-Content -Path $TempFile.FullName -Encoding utf8 -NoNewline
        }

        # only return TempFile if it got written to.
        if ((Get-Item $TempFile | Select-Object -ExpandProperty Length) -gt 0) {
            $TempFile
        }
    }
}
