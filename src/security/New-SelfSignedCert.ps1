New-Alias `
    -Name openssl `
    -Value 'C:\Program Files\Git\usr\bin\openssl.exe' `
    -Option AllScope `
    -Description "Git's bundled copy of openssl" `
    -ErrorAction SilentlyContinue

function New-SelfSignedCert {
    
    [CmdletBinding(PositionalBinding = $true)]
    [OutputType([string])]
    Param(
        
        [Parameter(Mandatory = $false,
            HelpMessage = "Path to where the ssl.csr, ssl.crt and ssl.key will be stored.",
            Position = 0
        )]
        [string]
        $OutPath = '.',

        [Parameter(
            Mandatory = $true,
            ParameterSetName = "ExpiresInYears",
            HelpMessage = "Number of years certificate expires.",
            Position = 1
        )]
        [ValidateRange(1, 10)]
        [Int]
        $Years,
            
        [Parameter(
            Mandatory = $true,
            ParameterSetName = "ExpiresInDays",
            HelpMessage = "Number of days certificate expires.",
            Position = 1
        )]
        [ValidateRange(31, 3650)]
        [Int]
        $Days
    )

    begin {
        if ($(Test-Path $OutPath) -ne $true) {
            New-Item -Path $OutPath -Force -ItemType Directory | Out-Null
        }
        
        [string]$Path = Resolve-Path $OutPath

        if ($Years -ge 1) {
            $Days = $Years * 365
        }
        
        Push-Location
        Set-Location $Path 

    }
    
    process {
        # perhaps the New-Item operation above conflicts with openssl if called immediately, hence
        # the following sleeping
        Start-Sleep -Seconds 2
        Invoke-Expression "openssl req -new -newkey rsa:2048 -nodes -keyout 'ssl.key' -out 'ssl.csr'"
        Start-Sleep -Seconds 2
        Invoke-Expression "openssl x509 -req -days $Days -in 'ssl.csr' -signkey 'ssl.key' -out 'ssl.crt'"
        Start-Sleep -Seconds 2
    }
    
    end {
        Write-Output @{
            crt = Get-Content -Path 'ssl.crt'
            key = Get-Content -Path 'ssl.key'
        }

        Pop-Location
    }
}
