function ConvertTo-PEMCertificateString {
    [CmdletBinding(
        PositionalBinding = $false
    )]
    Param(
        [Parameter(
            Mandatory = $false,
            HelpMessage = "The exported certificate from the store.",
            ValueFromPipeline = $true,
            Position = 1
        )]
        [object]$Certificates
    )
    
    end {
        if ($Certificates.Count -eq 1) {

            # setting eol to CRLF. Azure seems to fail when its LF.
            $OFS = "`r`n"
            $KeyFormat = [System.Security.Cryptography.CngKeyBlobFormat]::Pkcs8PrivateBlob
            $StringFormat = [System.Base64FormattingOptions]::InsertLineBreaks

            [string]@(
                "-----BEGIN PRIVATE KEY-----",
                [System.Convert]::ToBase64String($Certificates.PrivateKey.Key.Export($KeyFormat), $StringFormat),
                "-----END PRIVATE KEY-----"
            ) | ForEach-Object { Out-String -InputObject $_ -NoNewline } -OutVariable PrivateKey64 | Out-Null
	
            [string]@(
                "-----BEGIN CERTIFICATE-----",
                [System.Convert]::ToBase64String($Certificates.GetRawCertData(), $StringFormat),
                "-----END CERTIFICATE-----"
            ) | ForEach-Object { Out-String -InputObject $_ -NoNewline } -OutVariable Certificate64 | Out-Null

            @"
$PrivateKey64
$Certificate64

"@
        }
        elseif ($Certificates.Count -eq 0) {
            Write-Error "Found no certificate. 1 certificate is required"
        }
        else {
            Write-Error "Found more than 1 certificate. Only 1 is required."
        }
    }
    
}
