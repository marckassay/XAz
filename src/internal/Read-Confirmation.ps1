function Read-Confirmation {

    Param(
        [Parameter(
            Mandatory = $true
        )]
        [string]$Prompt,

        [Parameter(
            Mandatory = $false
        )]
        [string]$Message
    )

    $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))

    -not [bool]$Host.UI.PromptForChoice($Message, $Prompt, $choices, 1)
}
