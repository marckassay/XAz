
function Get-X509Certificates {
    [CmdletBinding()]
    Param(

    )
    
    end {
        $CloseAfter = $false

        if (($null -eq $script:X509Store) -or ($script:X509Store.IsOpen -eq $false)) {
            $CloseAfter = $true
            Open-X509Store
        }

        if ($script:X509Store.Certificates) {
            $script:X509Store.Certificates.GetEnumerator()
        }
    
        if ($CloseAfter -eq $true) {
            Close-X509Store
        }
    }
}
