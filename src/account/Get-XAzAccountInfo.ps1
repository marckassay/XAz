using module .\AccountInfo.psm1

function Get-XAzAccountInfo {
    [CmdletBinding(
        PositionalBinding = $false
    )]
    Param(
        [switch]$OnlyAzCli,
        [switch]$OnlyAzModule
    )
    
    end {

        if ($OnlyAzModule -eq $false) {

            # get signed-in account. if Count has a value of greater than 1, then its not an error message 
            [object[]]$SignedInAccountForCLI = az account show 2>&1
            if ($SignedInAccountForCLI.Count -gt 1) {

                $SignedInAccountForCLI = $SignedInAccountForCLI | `
                    ConvertFrom-Json -ErrorAction 'SilentlyContinue' | `
                    ForEach-Object {
                    # hash is being regenerated here so that equality check will be simplier done below
                    $hash = [System.HashCode]::Combine($_.id + $_.isDefault + $_.name + $_.tenantId + $_.user.name)
                    $_ | Add-Member -NotePropertyName Hash -NotePropertyValue $hash
                    $_ | Add-Member -NotePropertyName IsSignedIn -NotePropertyValue $true
                    $_
                }
            }
            else {
                $SignedInAccountForCLI = @{Hash = -1; IsSignedIn = $false }
            }

            # get all available accounts
            [object[]]$AvailableAccountsForCLI = az account list 2>&1

            # since an error-record and empty array is returned, further introspection is requried to make an assessment. 
            $IsAvailable = $AvailableAccountsForCLI | `
                Where-Object { $_ -Is 'System.Management.Automation.ErrorRecord' } | `
                Measure-Object | `
                ForEach-Object { $($_.Count -eq 0) }
            
            if ($IsAvailable) {
                # TODO: not sure how to AvailableAccountsForCLI into pipe. this has to do with pscustomobjects
                $AvailableAccountsForCLI = az account list | ConvertFrom-Json
                $AvailableAccountsForCLI = $AvailableAccountsForCLI | ForEach-Object -Process {
                    $hash = [System.HashCode]::Combine($_.id + $_.isDefault + $_.name + $_.tenantId + $_.user.name)
                    $_ | Add-Member -NotePropertyName Hash -NotePropertyValue $hash
                    $_ | Add-Member -NotePropertyName IsSignedIn -NotePropertyValue $false
                    $_
                }
            }
            else {
                $AvailableAccountsForCLI = @{Hash = -1; IsSignedIn = $false }
            }

            $AvailableAccountsForCLI += $SignedInAccountForCLI
            
            [AccountInfo[]] $AiCLI = $AvailableAccountsForCLI | ForEach-Object {
                if (($_.Hash -ne $SignedInAccountForCLI.Hash) -or ($_.IsSignedIn -eq $true)) {
                    $Account = [AccountInfo]::new()
                    $Account.Program = [AccountInfo]::Cli
                    $Account.SubscriptionId = $_.id
                    $Account.TenantId = $_.tenantId
                    $Account.IsDefault = $_.isDefault
                    $Account.IsSignedIn = $_.IsSignedIn
                    $Account.SignedInIdentity = $_.user.name
                    $Account.Hash = $_.Hash
                    $Account | Add-Member -NotePropertyName ProgramValue -NotePropertyValue $([AccountInfo]::Cli.Value)
                    $Account
                }
            }

            if (-not $AiCLI) {
                $AiCLI = @()
            }
        }
        else {
            $AiCLI = $null
        }

        if ($OnlyAzCli.IsPresent -eq $false) {

            # get signed-in user
            $SignedInUserForPS = Get-AzContext
            if ($SignedInUserForPS) {
                $SignedInUserForPS = $SignedInUserForPS | ForEach-Object {
                    # hash is being regenerated here so that equality check will be simplier done below
                    $hash = [System.HashCode]::Combine($_.Subscription.Id + $_.Name + $_.Tenant.Id + $_.Account.Id)
                    $_ | Add-Member -NotePropertyName Hash -NotePropertyValue $hash
                    $_ | Add-Member -NotePropertyName IsSignedIn -NotePropertyValue $true
                    $_
                }
            }
            else {
                $SignedInUserForPS = @{Hash = -1; IsSignedIn = $false }
            }

            # get all available contexts
            $AvailableAccountsForPS = Get-AzContext -ListAvailable
            $AvailableAccountsForPS = $AvailableAccountsForPS | ForEach-Object {
                $hash = [System.HashCode]::Combine($_.Subscription.Id + $_.Name + $_.Tenant.Id + $_.Account.Id)
                $_ | Add-Member -NotePropertyName Hash -NotePropertyValue $hash
                $_ | Add-Member -NotePropertyName IsSignedIn -NotePropertyValue $false
                $_
            }

            $AvailableAccountsForPS += $SignedInUserForPS
            
            [AccountInfo[]] $AiPS = $AvailableAccountsForPS | ForEach-Object {
                if (($_.Hash -ne $SignedInUserForPS.Hash) -or ($_.IsSignedIn -eq $true)) {
                    $Account = [AccountInfo]::new()
                    $Account.Program = [AccountInfo]::Module
                    $Account.SubscriptionId = $_.Subscription.Id
                    $Account.TenantId = $_.Tenant.Id
                    $Account.IsDefault = $_.isDefault
                    $Account.IsSignedIn = $_.IsSignedIn
                    $Account.SignedInIdentity = $_.Account.Id
                    $Account.ContextName = $_.Name
                    $Account.Hash = $_.Hash
                    $Account | Add-Member -NotePropertyName ProgramValue -NotePropertyValue $([AccountInfo]::Module.Value)
                    $Account
                }
            }

            if (-not $AiPS) {
                $AiPS = @()
            }
        }
        else {
            $AiPS = $null
        }
        
        [AccountInfoCollection]::new($AiCLI, $AiPS)
    }
}
