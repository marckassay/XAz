
function Get-XAzTemplateObject {

    [CmdletBinding(
        PositionalBinding = $true
    )]
    [OutputType(
        [hashtable]
    )]
    Param(
        [Parameter(
            Mandatory = $true,
            Position = 0
        )]
        [ValidateNotNull()]
        [string]$Path
    )

    begin {
        if (-not $PSBoundParameters.ContainsKey('Verbose')) {
            $VerbosePreference = $PSCmdlet.GetVariableValue('VerbosePreference')
        }
    }
    
    end {
        $ResolvedPath = Resolve-Path $Path

        Write-Verbose "Loading file: $ResolvedPath"
        $ParameterContent = Get-Content $ResolvedPath

        Write-Verbose "Converting json file into object"

        $TemplateParameters = $ParameterContent | `
            ConvertFrom-Json -Depth 10 -AsHashtable

        if ($TemplateParameters) {
            Write-Verbose "Loaded file successfully"
            $TemplateParameters
        }
        else {
            $null
        }
    }
}
