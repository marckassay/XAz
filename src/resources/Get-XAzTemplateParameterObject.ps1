
function Get-XAzTemplateParameterObject {

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

        # we only care about the parameters object of this file; hence last command
        $TemplateParameters = $ParameterContent | `
            ConvertFrom-Json -Depth 5 -AsHashtable | `
            Select-Object -ExpandProperty parameters

        if ($TemplateParameters) {
            Write-Verbose "Loaded file successfully"
        }
    }
}
