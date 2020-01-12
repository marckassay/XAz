using module .\src\account\certificate\Close-X509Store.ps1
using module .\src\account\certificate\ConvertTo-PEMCertificateString.ps1
using module .\src\account\certificate\Disable-X509FormatDataView.ps1
using module .\src\account\certificate\Enable-X509FormatDataView.ps1
using module .\src\account\certificate\Export-X509Certificate.ps1
using module .\src\account\certificate\Get-PEMCertificate.ps1
using module .\src\account\certificate\Get-SelfSignedCertParamObject.ps1
using module .\src\account\certificate\Get-X509Certificates.ps1
using module .\src\account\certificate\Import-X509Certificate.ps1
using module .\src\account\certificate\New-SelfSignedCert.ps1
using module .\src\account\certificate\Open-X509Store.ps1
using module .\src\account\certificate\Remove-X509Certificate.ps1
using module .\src\account\Confirm-XAzAccount.ps1
using module .\src\account\Connect-XAzAccount.ps1
using module .\src\account\Get-XAzAccountInfo.ps1
using module .\src\account\Set-XAzServicePrincipal.ps1
using module .\src\internal\Read-Confirmation.ps1
using module .\src\registry\Approve-XAzRegistryName.ps1
using module .\src\registry\Get-XAzContainerRegistryTags.ps1
using module .\src\registry\Get-XAzRegistryCredentials.ps1
using module .\src\resources\Confirm-XAzResourceGroup.ps1
using module .\src\resources\Get-XAzTemplateObject.ps1
using module .\src\utility\Invoke-AzureCLIDownload.ps1
using module .\src\utility\Set-StepMessage.ps1
using module .\src\utility\Test-Object.ps1
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
# debounce Store.Close(). Used in Close-X509Store. 
$script:ClosingStoreJob = @{
    Id    = -1
    State = 'Completed'
}
$script:X509Store = $null

if ($script:SUT -eq $False) {
    # Start-Module
}
