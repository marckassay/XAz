class AccountInfo {
    [string]$Program
    [string]$SubscriptionId
    [string]$TenantId
    [bool]$IsDefault
    [bool]$IsSignedIn
    [string]$SignedInIdentity
    [string]$ContextName

    AccountInfo() { }
}