New-Alias `
    -Name base64 `
    -Value 'C:\Program Files\Git\usr\bin\base64.exe' `
    -Option AllScope `
    -Description "Git's bundled copy of base64" `
    -ErrorAction SilentlyContinue

function ConvertTo-Base64 {
    
    <#
    .SYNOPSIS
    Streams file content into the GNU base64 executeable that is bundled with Git.
    
    .DESCRIPTION
    Long description
    
    .PARAMETER Path
    Parameter description
    
    .EXAMPLE
    [string]$KeyContent = ConvertTo-Base64 -Path $(Resolve-Path -Path $SslKeyPath)

    Noticed that the variable is casted to string. That is deliberate since if it was going to be piped
    some bad mojo happens.
    
    .NOTES
    General notes
    #>
    
    [CmdletBinding(
        DefaultParameterSetName = "ByPipeline",
        PositionalBinding = $true
    )]
    param(
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

    Get-Content -Path $Path | base64 -w 0
}
