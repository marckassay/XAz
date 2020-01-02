function Close-X509Store
{
    Param(

    )

    end {
        if(($null -ne $script:X509Store) -and ($script:X509Store.IsOpen -eq $true)) {
            $script:X509Store.Close()
        }
    }
}
