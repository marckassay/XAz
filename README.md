# XAz

[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/marckassay/XAz/blob/master/LICENSE)
[![PS Gallery](https://img.shields.io/badge/install-PS%20Gallery-blue.svg)](https://www.powershellgallery.com/packages/XAz/)

XAz is a collection of [PowerShell Core](https://docs.microsoft.com/en-us/powershell/) scripts to interface with [Az](https://docs.microsoft.com/en-us/powershell/azure/overview?view=azps-2.5.0) module.

## API

#### [`ConvertTo-Base64`](https://github.com/marckassay/XAz/blob/0.0.3/docs/ConvertTo-Base64.md)

Streams file content into the GNU base64 executeable that is bundled with Git. 

#### [`Get-XAzRegistryCredentials`](https://github.com/marckassay/XAz/blob/0.0.3/docs/Get-XAzRegistryCredentials.md)

Makes 2 Az function calls to get Azure Container Registry credentials. 

#### [`Invoke-AzureCLIDownload`](https://github.com/marckassay/XAz/blob/0.0.3/docs/Invoke-AzureCLIDownload.md)

Downloads MSI for ['Azure CLI'](https://docs.microsoft.com/en-us/cli/azure/?view=azure-cli-latest) to the host computer. 

#### [`New-SelfSignedCert`](https://github.com/marckassay/XAz/blob/0.0.3/docs/New-SelfSignedCert.md)

Creates a self-signed certificate using `openssl`. 

#### [`New-XAzResourceGroupDeployment`](https://github.com/marckassay/XAz/blob/0.0.3/docs/New-XAzResourceGroupDeployment.md)

Creates (or updates) a resource deployment under the resource group specified by the `ContainerRegistryName` parameter. 
