using namespace System.Security.Cryptography.X509Certificates

function Set-XAzServicePrincipal {
  [CmdletBinding(
    PositionalBinding = $true
  )]
  Param(
    [Parameter(
      Mandatory = $false,
      ValueFromPipeline = $false,
      Position = 0
    )]
    [string]$ApplicationId,

    [Parameter(
      Mandatory = $false,
      ValueFromPipeline = $false,
      Position = 1
    )]
    [string]$DisplayName,

    [Parameter(
      Mandatory = $false,
      ValueFromPipeline = $false,
      Position = 2
    )]
    [string]$TenantId,

    [Parameter(
      Mandatory = $false,
      ValueFromPipeline = $false,
      Position = 3
    )]
    [X509Certificate]$Certificate,

    [switch]$OnlyAzCli,
    [switch]$OnlyAzModule
  )
    
  end {

    if ($ApplicationId) {
      $SP = Get-AzADServicePrincipal -ApplicationId $ApplicationId
    }
    else {
      $SP = Get-AzADServicePrincipal -DisplayName $DisplayName
    }

    if (-not $SP) {
      Write-Error "The service principal cannot be found: $ApplicationId$DisplayName" -ErrorAction Stop
    }

    $AIs = Get-XAzAccountInfo

    if ($Certificate) {
      $Thumbprint = $Certificate.Thumbprint
      $CertificateFile = Get-PEMCertificate -Certificate $Certificate
    }

    if (-not $OnlyAzModule) {

      $SignedInIdentity = $AIs.GetSignedInCliAccount() | `
        Where-Object { $_.TenantId -eq $TenantId } | `
        Select-Object -ExpandProperty SignedInIdentity

      if ($SignedInIdentity -ne $SP.ApplicationId) {
        az login --service-principal --username ($SP.ApplicationId) --tenant $TenantId --password $CertificateFile.FullName 2>&1 | Out-Null
      }
    }

    if (-not $OnlyAzCli) {

      $SignedInIdentity = $AIs.GetSignedInModuleAccount() | `
        Where-Object { $_.TenantId -eq $TenantId } | `
        Select-Object -ExpandProperty SignedInIdentity
      
      if ($SignedInIdentity -ne $SP.ApplicationId) {
        Connect-AzAccount -ServicePrincipal -CertificateThumbprint $Thumbprint -ApplicationId ($SP.ApplicationId) -TenantId $TenantId | Out-Null
      }
    }
  }
}
