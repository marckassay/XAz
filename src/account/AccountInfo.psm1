class AccountProgram {
    static [string]$Cli = 'az cli'
    static [string]$Module = 'Az module'
    [string]$Value

    AccountProgram([string]$Value) {
        $this.Value = $Value
    }
}

class AccountInfo {
    static [AccountProgram]$Cli = [AccountProgram]::new([AccountProgram]::Cli)
    static [AccountProgram]$Module = [AccountProgram]::new([AccountProgram]::Module)
    hidden [AccountProgram]$Program
    [string]$SubscriptionId
    [string]$TenantId
    [bool]$IsDefault
    [bool]$IsSignedIn
    [string]$SignedInIdentity
    [string]$ContextName
    hidden [string]$Hash
    
    AccountInfo() { }
}
class AccountInfoCollection {
    [AccountInfo[]]$Accounts
    [bool]$Cli
    [bool]$Module

    AccountInfoCollection([AccountInfo[]]$cli, [AccountInfo[]]$module) {
        $this.Cli = ($cli -ne $null)
        $this.Module = ($module -ne $null)
        $this.Accounts = @()
        $this.Accounts += $cli
        $this.Accounts += $module
    }

    [AccountInfo[]] GetAccounts([AccountProgram]$Program) {
        return $this.Accounts | Where-Object { 
            ($_.Program -eq $Program)
        }
    }

    [AccountInfo[]] GetCliAccounts() {
        return $this.GetAccounts([AccountInfo]::Cli)
    }

    [AccountInfo[]] GetSignedInCliAccount() {
        return $this.GetCliAccounts() | Where-Object { $_.IsSignedIn -eq $true }
    }

    [AccountInfo[]] GetSignedOutCliAccount() {
        return $this.GetCliAccounts() | Where-Object { $_.IsSignedIn -eq $false }
    }

    [AccountInfo[]] GetModuleAccounts() {
        return $this.GetAccounts([AccountInfo]::Module)
    }

    [AccountInfo[]] GetSignedInModuleAccount() {
        return $this.GetModuleAccounts() | Where-Object { $_.IsSignedIn -eq $true }
    }

    [AccountInfo[]] GetSignedOutModuleAccount() {
        return $this.GetModuleAccounts() | Where-Object { $_.IsSignedIn -eq $false }
    }

    [object[]] GetSignedInAccounts() {
        if (-not $this.GetSignedInModuleAccount()) {
            return $this.GetSignedInCliAccount()
        }
        elseif (-not $this.GetSignedInCliAccount()) {
            return $this.GetSignedInModuleAccount()
        }
        else {
            return @($this.GetSignedInCliAccount(), $this.GetSignedInModuleAccount())
        }
    }

    [object[]] GetSignedOutAccounts() {
        if (-not $this.GetSignedOutModuleAccount()) {
            return $this.GetSignedOutCliAccount()
        }
        elseif (-not $this.GetSignedOutCliAccount()) {
            return $this.GetSignedOutModuleAccount()
        }
        else {
            return @($this.GetSignedOutCliAccount(), $this.GetSignedOutModuleAccount())
        }
    }
}