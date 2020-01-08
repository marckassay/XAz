function Import-X509Certificate {
    [CmdletBinding()]
    [OutputType()]
    param(
        [Parameter(
            Mandatory = $true,
            HelpMessage = "The location of PKCS12 file.",
            Position = 1
        )]
        [string]$Path,

        [Parameter(
            Mandatory = $false,
            HelpMessage = "Optional credentials for entry.",
            Position = 2
        )]
        [PSCredential]$Credential,

        [switch]
        $CredentialPrompt
    )

    end {
        Open-X509Store

        if ($CredentialPrompt.IsPresent -eq $true) {
            $Credential = Get-Credential -Message "Provide certificate's CommonName and Passphrase"
        }
        
        [byte[]]$CertContentBytes = Get-Content $Path -AsByteStream
            
        # TODO: add to parameters
        $Flags = @(
            [System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::Exportable,
            [System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::MachineKeySet,
            [System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::PersistKeySet
        )

        if ($null -eq $Credential) {
            $Certificate = [System.Security.Cryptography.X509Certificates.X509Certificate2]::new($CertContentBytes, '', $Flags)
        }
        else {
            $Certificate = [System.Security.Cryptography.X509Certificates.X509Certificate2]::new($CertContentBytes, $Credential.Password, $Flags)
        }

        $script:X509Store.Add($Certificate)

        Close-X509Store
    }
}
