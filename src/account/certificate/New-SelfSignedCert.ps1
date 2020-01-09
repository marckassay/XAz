function New-SelfSignedCert {
    [CmdletBinding(
        PositionalBinding = $false
    )]
    Param(
        [Parameter(
            Mandatory = $false,
            Position = 1
        )]
        [string]$Path = $(Get-Location | Select-Object -ExpandProperty $Path),

        [Alias("C")]
        [Parameter(
            Mandatory = $false,
            Position = 2
        )]
        [string]$Country = 'AU',

        [Alias("S")]
        [Parameter(
            Mandatory = $false,
            Position = 3
        )]
        [string]$State = 'Some-State',

        [Alias("L")]
        [Parameter(
            Mandatory = $false,
            Position = 4
        )]
        [string]$Location = '',

        [Alias("O")]
        [Parameter(
            Mandatory = $false,
            Position = 5
        )]
        [string]$Organization = 'Internet Widgits Pty Ltd',

        [Alias("OU")]
        [Parameter(
            Mandatory = $false,
            Position = 6
        )]
        [string]$OrganizationUnit = '',

        [Alias("CN")]
        [ValidateNotNullOrEmpty()]
        [Parameter(
            Mandatory = $false,
            Position = 7
        )]
        [string]$CommonName = 'localhost',

        [Alias("E")]
        [ValidateNotNullOrEmpty()]
        [Parameter(
            Mandatory = $true,
            Position = 8
        )]
        [string]$Email = '',

        [Parameter(
            Mandatory = $false,
            Position = 9
        )]
        [string]$CertExePath,

        [switch]$Interactive
    )
    
    end {
        
        $OpenSSLCommand = $false

        if (-not $CertExePath) {

            Get-Command openssl -ErrorAction SilentlyContinue -OutVariable OpenSSLCommand | `
                Out-Null
        }
        else {
            if (Test-Path  $CertExePath) {

                New-Alias -Name openssl -Value $CertExePath -Option AllScope -Description "User specified location of openssl"
                Write-Host "An alias command has been created for OpenSSL on all PowerShell scopes. The command origin, as specified, is here: $CertExePath"
                Write-Host "Executing 'openssl version'"
                openssl version
                $OpenSSLCommand = $true
            }
        }

        if (-not $OpenSSLCommand) {

            Get-Command git -ErrorAction SilentlyContinue | `
                Select-Object -ExpandProperty Source | `
                Resolve-Path -OutVariable GitExePath | `
                Out-Null

            if ($GitExePath) {
            
                $GitInstalledDir = $GitExePath.Path.ToLower().Split('git\')[0]
                $FoundOpenSSL = Join-Path -Path $GitInstalledDir -ChildPath '\git\usr\bin\openssl.exe' | `
                    Resolve-Path | `
                    Select-Object -ExpandProperty Path -OutVariable OpenSSLExePath | `
                    Test-Path

                if ($FoundOpenSSL) {
                    $OpenSSLExePath = $OpenSSLExePath[0]
                    New-Alias -Name 'openssl' -Value $OpenSSLExePath -Scope 'Global' -Description "Git's bundled copy of openssl"
                    Write-Host "An alias command has been created for OpenSSL for all PowerShell scopes. The command origin was found here: $OpenSSLExePath"
                    Write-Host "Executing 'openssl version'"
                    openssl version
                    $OpenSSLCommand = $true
                }
            }
        }

        if ($OpenSSLCommand) {

            $PrivateKeyPath = Join-Path -Path $Path -ChildPath 'private-key.pem'
            $CertKeyPath = Join-Path -Path $Path -ChildPath 'certificate.pem'
            $P12Path = Join-Path -Path $Path -ChildPath 'certificate.p12'

            if (-not $Interactive.IsPresent) {
                $Subject = "/emailAddress=$Email/C=$Country/ST=$State/L=$Location/O=$Organization/OU=$OrganizationUnit/CN=$CommonName"
                
                openssl req -nodes -newkey rsa:2048 -keyout $PrivateKeyPath -x509 -days 365 -out $CertKeyPath -subj $Subject
            }
            else {
                openssl req -nodes -newkey rsa:2048 -keyout $PrivateKeyPath -x509 -days 365 -out $CertKeyPath
            }

            openssl pkcs12 -inkey $PrivateKeyPath -in $CertKeyPath -export -out $P12Path
        }
        else {
            if ($CertExePath) {
                Write-Error "The following specified path couldn't be validated: $CertExePath"
            }
            else {
                Write-Error "No openssl.exe found on filesystem. Specify a path to it and attempt again."
            }
        }
    }
}
