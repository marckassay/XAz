using module .\src\account\Connect-XAzAccount.ps1
using module .\src\deployment\New-XAzResourceGroupDeployment.ps1
using module .\src\registry\Approve-XAzRegistryName.ps1
using module .\src\registry\Get-XAzContainerRegistryTags.ps1
using module .\src\registry\Get-XAzRegistryCredentials.ps1
using module .\src\resources\Get-XAzTemplateParameterObject.ps1
using module .\src\security\New-SelfSignedCert.ps1
using module .\src\storage\New-Storage.ps1
using module .\src\utility\ConvertTo-Base64.ps1
using module .\src\utility\Invoke-AzureCLIDownload.ps1
using module .\src\webapp\Approve-XAzDomainName.ps1

Param(
    [Parameter(Mandatory = $False)]
    [bool]$SUT = $False
)

$script:SUT = $SUT
if ($script:SUT -eq $False) {
    # Start-Module
}


