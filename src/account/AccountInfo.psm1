class AccountInfo {
    [string]$Program
    [string]$SubscriptionId
    [string]$TenantId
    [bool]$IsDefault
    [bool]$IsSignedIn
    [string]$SignedInIdentity
    [string]$ContextName
    [string]$Hash

    AccountInfo() { }
}
class AccountInfoHash {
    [AccountInfo[]]$Cli
    [AccountInfo[]]$Module

    AccountInfoHash([AccountInfo[]]$cli, [AccountInfo[]]$module) { 
        $this.Cli = $cli
        $this.Module = $module
    }
}