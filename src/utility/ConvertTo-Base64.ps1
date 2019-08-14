New-Alias `
    -Name base64 `
    -Value 'C:\Program Files\Git\usr\bin\base64.exe' `
    -Option AllScope `
    -Description "Git's bundled copy of base64" `
    -ErrorAction SilentlyContinue

function ConvertTo-Base64 {
    
    [CmdletBinding(
        DefaultParameterSetName = "ByPipe",
        PositionalBinding = $true
    )]
    param(
        [Parameter(
            Mandatory = $true,
            ParameterSetName = "ByPipe",
            ValueFromPipeline = $true,
            HelpMessage = "The contents of the file to encode."
        )]
        [ValidateNotNull()]
        [psobject]
        $InputObject,

        [Parameter(
            Mandatory = $true,
            ParameterSetName = "ByPath",
            ValueFromPipeline = $false,
            HelpMessage = "The path of the file to encode.",
            Position = 0
        )]
        [ValidateNotNull()]
        [string[]]
        $Path
    )

    begin {
        if ($Path.Length -gt 0) {
            Get-Content -Path $Path | base64 -w 0
        }
    }

    process {
        $_ | base64 -w 0
    }
 
}
