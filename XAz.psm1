using module .\src\deployment\New-XAzResourceGroupDeployment.ps1
using module .\src\registry\Get-XAzRegistryCredentials.ps1
using module .\src\utility\ConvertTo-Base64.ps1
using module .\src\security\New-SelfSignedCert.ps1
using module .\src\utility\Invoke-AzureCLIDownload.ps1

Param(
    [Parameter(Mandatory = $False)]
    [bool]$SUT = $False
)

$script:SUT = $SUT
if ($script:SUT -eq $False) {
    # Start-Module
}

