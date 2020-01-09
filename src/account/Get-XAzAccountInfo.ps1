using module .\AccountInfo.psm1

function Get-XAzAccountInfo {
    [CmdletBinding(
        PositionalBinding = $false
    )]
    Param(
        [Parameter(
            Mandatory = $false,
            HelpMessage = "Omit retrieving from either 'az cli' or 'PowerShell Az module'.",
            ValueFromPipeline = $false,
            Position = 0
        )]
        [ValidateSet("az cli", "Az module")]
        [string]$Omit
    )
    
    end {
        
        if ($Omit -ne 'az cli') {

            # get signed-in account
            $SignedInAccountForCLI = ConvertTo-Json -InputObject $(az account show 2>&1) -ErrorAction 'SilentlyContinue'
            if ($SignedInAccountForCLI.Contains('Error') -eq $false) {

                $SignedInAccountForCLI = $SignedInAccountForCLI | ForEach-Object {
                    # hash is being regenerated here so that equality check will be simplier done below
                    $hash = [System.HashCode]::Combine($_.id + $_.isDefault + $_.name + $_.tenantId + $_.user.name)
                    $_ | Add-Member -NotePropertyName Hash -NotePropertyValue $hash
                    $_ | Add-Member -NotePropertyName IsSignedIn -NotePropertyValue $true
                    $_
                }

                # get all available accounts
                [object[]]$AvailableAccountsForCLI = az account list | ConvertFrom-Json -ErrorAction 'SilentlyContinue'
            
                $AvailableAccountsForCLI = $AvailableAccountsForCLI | ForEach-Object {
                    $hash = [System.HashCode]::Combine($_.id + $_.isDefault + $_.name + $_.tenantId + $_.user.name)
                    $_ | Add-Member -NotePropertyName Hash -NotePropertyValue $hash
                    $_ | Add-Member -NotePropertyName IsSignedIn -NotePropertyValue $false
                    $_
                } 

                $AvailableAccountsForCLI += $SignedInAccountForCLI

                [AccountInfo[]] $AiCLI = $AvailableAccountsForCLI | ForEach-Object {
                    if (($_.Hash -ne $SignedInAccountForCLI.Hash) -or ($_.IsSignedIn -eq $true)) {
                        $Account = [AccountInfo]::new()
                        $Account.Program = 'az cli'
                        $Account.SubscriptionId = $_.id
                        $Account.TenantId = $_.tenantId
                        $Account.IsDefault = $_.isDefault
                        $Account.IsSignedIn = $_.IsSignedIn
                        $Account.SignedInIdentity = $_.user.name
                        $Account
                    }
                }
            }
            else {
                $AiCLI
            }
        }

        if ($Omit -ne 'Az module') {

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
                    $Account.Program = 'Az module'
                    $Account.SubscriptionId = $_.Subscription.Id
                    $Account.TenantId = $_.Tenant.Id
                    $Account.IsDefault = $_.isDefault
                    $Account.IsSignedIn = $_.IsSignedIn
                    $Account.SignedInIdentity = $_.Account.Id
                    $Account.ContextName = $_.Name
                    $Account
                }
            }
        }
        
        $AiCLI += $AiPS
        $AiCLI
    }
}
