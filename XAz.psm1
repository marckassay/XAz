using module .\src\utility\Invoke-AzureCLIDownload.ps1

Param(
    [Parameter(Mandatory = $False)]
    [bool]$SUT = $False
)

$script:SUT = $SUT
if ($script:SUT -eq $False) {
    # Start-Module
}

