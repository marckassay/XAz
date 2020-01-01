function Write-StepMessage {
    [CmdletBinding(
        PositionalBinding = $true
    )]
    Param(
        [Parameter(
            Mandatory = $false,
            Position = 0
        )]
        [ValidateNotNull()]
        [Int32]$CurrentStep,

        [Parameter(
            Mandatory = $false,
            Position = 1
        )]
        [ValidateNotNull()]
        [Int32]$TotalSteps

    )

    begin {
        if (-not $PSBoundParameters.ContainsKey('Verbose')) {
            $VerbosePreference = $PSCmdlet.GetVariableValue('VerbosePreference')
        }

        if (-not $CurrentStep) {
            ++$script:XAzCurrentStep
            $CurrentStep = $script:XAzCurrentStep
        }
    }
    
    end {
        $Msg = "Step $CurrentStep out of $script:XAzTotalSteps steps completed"

        if ($script:XAzShowElapsedTime -is [datetime]) {
            $Time = "T+{0:mm:ss:fff} " -f [datetime]((Get-Date) - $script:XAzShowElapsedTime).Ticks
            $Msg = "$Time $Msg" 
        }

        Write-Verbose $Msg
        Write-Verbose ""
    }
}
