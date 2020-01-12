using module ..\..\internal\MKModuleInfo.psm1

function Disable-X509FormatDataView {
    [CmdletBinding(
        PositionalBinding = $false)]
    [OutputType()]
    Param(
    )
    
    end {
        $XAzModulePath = [MKModuleInfo]::new('', 'XAz').Path

        # first save the default format file
        $X509DefaultPath = Join-Path -Path $XAzModulePath -ChildPath '.\formats\X509Certificate2-powershell.format.ps1xml'
        if ((Test-Path $X509DefaultPath) -eq $false) {
            Get-FormatData -TypeName 'System.Security.Cryptography.X509Certificates.X509Certificate2' -PowerShellVersion $PSVersionTable | `
                Select-Object -First 1 | `
                Export-FormatData -Path $X509DefaultPath -Force -IncludeScriptBlock
        }
        
        Update-FormatData -PrependPath $X509DefaultPath
    }
}
