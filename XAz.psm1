using module .\src\account\Connect-XAzAccount.ps1
using module .\src\internal\ParameterCompleters.ps1
using module .\src\internal\Read-Confirmation.ps1
using module .\src\registry\Approve-XAzRegistryName.ps1
using module .\src\registry\Get-XAzContainerRegistryTags.ps1
using module .\src\registry\Get-XAzRegistryCredentials.ps1
using module .\src\resources\Confirm-XAzResourceGroup.ps1
using module .\src\resources\Get-XAzTemplateObject.ps1
using module .\src\utility\Invoke-AzureCLIDownload.ps1
using module .\src\utility\Set-StepMessage.ps1
using module .\src\utility\Write-StepMessage.ps1
using module .\src\webapp\Approve-XAzDomainName.ps1

Param(
    [Parameter(Mandatory = $False)]
    [bool]$SUT = $False
)

$script:SUT = $SUT
$script:XAzTotalSteps = 0
$script:XAzCurrentStep = 0
$script:XAzShowElapsedTime = $null

if ($script:SUT -eq $False) {
    # Start-Module
}


