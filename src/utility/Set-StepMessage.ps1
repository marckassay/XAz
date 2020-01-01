function Set-StepMessage {
    [CmdletBinding(
        PositionalBinding = $true
    )]
    Param(
        [Parameter(
            Mandatory = $true,
            Position = 0
        )]
        [ValidateNotNull()]
        [Int32]$TotalSteps,

        [switch]$ShowElapsedTime
    )

    $script:XAzTotalSteps = $TotalSteps
    if ($ShowElapsedTime.IsPresent -eq $true) {
        $script:XAzShowElapsedTime = Get-Date
    }
}
