
function Get-X509CertificateList {
    [CmdletBinding()]
    Param(

    )
    
    end {
        $CloseAfter = $false

        if (($null -eq $script:X509Store) -or ($script:X509Store.IsOpen -eq $false)) {
            $CloseAfter = $true
            Open-X509Store
        }

        $script:X509Store.Certificates | Format-Table -AutoSize -Property Thumbprint, Subject
    
        if ($CloseAfter -eq $true) {
            Close-X509Store
        }
    }
}
