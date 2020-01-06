using module .\..\..\internal\ParameterCompleters.ps1

Register-ArgumentCompleter `
    -CommandName Remove-X509Certificate `
    -ParameterName FindBy `
    -ScriptBlock $FindByTypesCompleter

Register-ArgumentCompleter `
    -CommandName Remove-X509Certificate `
    -ParameterName Value `
    -ScriptBlock $CertValueCompleter
    
function Remove-X509Certificate {
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
        $FindBy = "FindBy$FindBy"
        $CloseAfter = $false

        if (($null -eq $script:X509Store) -or ($script:X509Store.IsOpen -eq $false)) {
            $CloseAfter = $true
            Open-X509Store
        }

        $Certificate = Export-X509Certificate -FindBy $FindBy -Value $Value
        
        $Certificate | Format-Table -AutoSize -Expand Both
        Write-Warning -Message "The certificate from Credential Management will be removed if you accept?" -WarningAction Inquire
        $script:X509Store.Remove($Certificate)

        if ($CloseAfter -eq $true) {
            Close-X509Store
        }
    }
}
