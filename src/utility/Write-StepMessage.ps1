function Write-StepMessage {
    [CmdletBinding(
        PositionalBinding = $true
    )]
    Param(
        [Parameter(
            Mandatory = $true,
            Position = 0
        )]
        [ValidateNotNull()]
        [Int32]$CurrentStep,

        [Parameter(
            Mandatory = $true,
            Position = 1
        )]
        [ValidateNotNull()]
        [Int32]$TotalSteps

    )

    begin {
        if (-not $PSBoundParameters.ContainsKey('Verbose')) {
            $VerbosePreference = $PSCmdlet.GetVariableValue('VerbosePreference')
        }
    }
    
    end {
        Write-Verbose "Step $CurrentStep out of $TotalSteps steps completed"
        Write-Verbose ""
    }
}
