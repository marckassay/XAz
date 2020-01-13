function Test-Object {
    [CmdletBinding(
        PositionalBinding = $true
    )]
    Param(
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            Position = 0
        )]
        [object[]]$Value,
        
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $false,
            Position = 1
        )]
        [scriptblock]$ScriptBlock
    )

    begin {
        $Values
    }
    process {
        $Values += $Value
    }
    end {
        $Values | Measure-Object -OutVariable MO | Out-Null
        $MO | ForEach-Object { $ScriptBlock.Invoke() }
    }
}