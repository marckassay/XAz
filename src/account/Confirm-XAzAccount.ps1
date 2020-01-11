using module .\AccountInfo.psm1

function Confirm-XAzAccount {
    [CmdletBinding(
        PositionalBinding = $true
    )]
    Param(
        [Parameter(
            Mandatory = $true,
            HelpMessage = "The account objects gathered from Get-XAzAccountInfo.",
            ValueFromPipeline = $false,
            Position = 0
        )]
        [AccountInfoHash]$Accounts,

        [switch]$OnlyAzCli,
        [switch]$OnlyAzModule,

        [switch]$StopOnEmptyCli,
        [switch]$StopOnEmptyModule
    )
    
    end {
        
        if (($null -ne $Accounts.Cli) -and ($OnlyAzModule -eq $false)) {
            $Exit = $false

            # for 'az cli', only one Subscription-Tenant can exist. so no switching can occur between 2 princiapls. if no results from show,
            # but results from list; user can select so that a princiapl can be switched to another subscription using this method.
            if ($Accounts.Cli) {
                $SignedInCLI = ($Accounts.Cli) | Where-Object { ($_.Program -eq 'az cli') -and ($_.IsSignedIn -eq $true) } | Select-Object -First 1
            }

            if ($SignedInCLI) {
                Write-Host "Currently 'az cli' is signed-in having the following account info:" -ForegroundColor 'DarkGreen'
                Write-Host "SubscriptionId:   $($SignedInCLI.SubscriptionId)"
                Write-Host "TenantId:         $($SignedInCLI.TenantId)" 
                Write-Host "SignedInIdentity: $($SignedInCLI.SignedInIdentity)" 
            }
            else {
                Write-Host "Currently 'az cli' is not signed-in." -ForegroundColor 'DarkRed'
                $Exit = $true
            }

            if (-not $Exit) {
                Write-Host ""
                Write-Host "---------------------------------------------------------------------" -ForegroundColor 'DarkGray'
                Write-Host ""

                if ($SignedInCLI) {
                    Write-Host "Press '0' to use current account info." -ForegroundColor Yellow
                }

                $Index = 0
                $SignedOutCLI = ($Accounts.Cli) | Where-Object { ($_.Program -eq 'az cli') -and ($_.IsSignedIn -eq $false) }
                $AIs = 1..($SignedOutCLI.Count + 1)
                $SignedOutCLI | ForEach-Object -Process {
                    Write-Host ("Press '" + ++$Index + "' to set account to use subscription: " + $_.SubscriptionId) -ForegroundColor Yellow
                    $AIs[$Index] = $_
                }

                Write-Host "Or press 'ENTER' to halt deployment." -ForegroundColor Yellow
                Write-Host ""
                $Selection = Read-Host "Make selection and press 'ENTER'"
                Write-Host ""
                if (($Selection -ge 1) -and ($Selection -le $Index)) {
                    $SelectedCLI = $AIs[$Selection]
                    $SubscriptionId = $SelectedCLI.SubscriptionId

                    Write-Host "Executing:"
                    Write-Host "az account set --subscription $SubscriptionId"
                    az account set --subscription $SubscriptionId
                }
                elseif (($SignedInCLI) -and ($Selection -eq 0)) {
                    $SelectedCLI = $SignedInCLI
                    Write-Host "Current account will be used."
                }
                elseif (($Selection.Length -eq 0)) {
                    Write-Host "Stopping further execution." -InformationAction 'Stop'
                }
                else {
                    Write-Error "Stopped due to unknown selection" -ErrorAction 'Stop'
                }
            }
        }
        
        if (($null -ne $Accounts.Module) -and ($OnlyAzCli -eq $false)) {

            if ($Selection -ge 0) {
                Write-Host ""
            }

            if ($Accounts.Module) {
                # for 'Az module', multiple Subscription-Tenant contexts can exist. so selecting between 2 principlas can happen
                $SignedInPS = ($Accounts.Module) | Where-Object { ($_.Program -eq 'Az module') -and ($_.IsSignedIn -eq $true) } | Select-Object -First 1
                $SignedOutPS = ($Accounts.Module) | Where-Object { ($_.Program -eq 'Az module') -and ($_.IsSignedIn -eq $false) }
            }

            if ($SignedInPS) {
                Write-Host "Currently 'Az module' is signed-in having the following account info:" -ForegroundColor 'DarkGreen'
                Write-Host "SubscriptionId:   $($SignedInPS.SubscriptionId)" 
                Write-Host "TenantId:         $($SignedInPS.TenantId)" 
                Write-Host "SignedInIdentity: $($SignedInPS.SignedInIdentity)"
            }
            else {
                Write-Host "Currently 'Az module' is not signed-in." -ForegroundColor 'DarkRed'
            }
            
            if ($SignedOutPS) {
                Write-Host ""
                Write-Host "---------------------------------------------------------------------" -ForegroundColor 'DarkGray'
                Write-Host ""

                if ($SignedInPS) {
                    Write-Host "Press '0' to use current account info." -ForegroundColor Yellow
                }

                $Index = 0
                $AIs = 1..($SignedOutPS.Count + 1)
                $SignedOutPS | ForEach-Object -Process {
                    Write-Host ("Press '" + ++$Index + "' to set account to use subscription and identity of: " + $_.SubscriptionId + " - " + $_.SignedInIdentity) -ForegroundColor Yellow
                    $AIs[$Index] = $_
                }

                Write-Host "Or press 'ENTER' to halt deployment." -ForegroundColor Yellow
                Write-Host ""
                $Selection = Read-Host "Make selection and press 'ENTER'"
                Write-Host ""
                if (($Selection -ge 1) -and ($Selection -le $Index)) {
                    $SelectedPS = $AIs[$Selection]
                    $RequestedContext = $SelectedPS.ContextName

                    Write-Host "Executing:"
                    Write-Host "Get-AzContext -Name $RequestedContext | Set-AzContext"
                    Get-AzContext -Name $RequestedContext | Set-AzContext
                }
                elseif (($SignedInPS) -and ($Selection -eq 0)) {
                    $SelectedPS = $SignedInPS
                    Write-Host "Current account will be used."
                }
                elseif (($Selection.Length -eq 0)) {
                    Write-Host "Stopping further execution." -InformationAction 'Stop'
                }
                else {
                    Write-Error "Stopped due to unknown selection" -ErrorAction 'Stop'
                }
            }
        }

        $Results = @{
            Cli    = $SelectedCLI
            Module = $SelectedPS
        }
        
        if ($StopOnEmptyCli -or $StopOnEmptyModule) {
            if (($StopOnEmptyCli -and ($null -eq $Results.Cli)) -and ($StopOnEmptyModule -and ($null -eq $Results.Module))) {
                Write-Error "Stopped due to no initial signed-in or cache found. Sign-in is required for both Cli and Module." -ErrorAction 'Stop'
            }
            elseif ($StopOnEmptyCli -and ($null -eq $Results.Cli)) {
                Write-Error "Stopped due to no initial signed-in or cache found. Sign-in is required for Cli." -ErrorAction 'Stop'
            }
            elseif ($StopOnEmptyModule -and ($null -eq $Results.Module)) {
                Write-Error "Stopped due to no initial signed-in or cache found. Sign-in is required for Module." -ErrorAction 'Stop'
            }
        }

        $Results
    }
}
