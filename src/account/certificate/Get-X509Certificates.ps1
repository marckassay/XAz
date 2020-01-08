
function Get-X509Certificates {
    [CmdletBinding()]
    Param(

    )
    
    end {
        Open-X509Store

        if ($script:X509Store.Certificates) {
            $script:X509Store.Certificates.GetEnumerator()
        }
    
        Close-X509Store
    }
}
