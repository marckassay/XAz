using module ..\..\internal\MKModuleInfo.psm1

function Enable-X509FormatDataView {
    [CmdletBinding(
        PositionalBinding = $false)]
    [OutputType([MKModuleInfo])]
    Param(
    )

    end {
        # first save the default format file
        $XAzModulePath = [MKModuleInfo]::new('', 'XAz').Path
        $X509DefaultPath = Join-Path -Path $XAzModulePath -ChildPath '.\formats\X509Certificate2-default.format.ps1xml'
        if ((Test-Path $X509DefaultPath) -eq $false) {
            Get-FormatData -TypeName 'System.Security.Cryptography.X509Certificates.X509Certificate2' -PowerShellVersion $PSVersionTable | `
                Select-Object -First 1 | `
                Export-FormatData -Path $X509DefaultPath
        }

        $XAzX509Path = Join-Path -Path $XAzModulePath -ChildPath '.\formats\X509Certificate2.format.ps1xml'
        Update-FormatData -PrependPath $XAzX509Path
    }
}
