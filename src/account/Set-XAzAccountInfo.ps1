# using module .\.\Get-ScriptFile.ps1

function Set-XAzAccountInfo {
  [CmdletBinding(
    PositionalBinding = $false
  )]
  Param(
    [Parameter(
      Mandatory = $false,
      HelpMessage = "The account objects gathered from Get-XAzAccountInfo.",
      ValueFromPipeline = $true,
      Position = 1
    )]
    [AllowNull()]
    [AccountInfo[]]$Accounts
  )
    
  end {

  }
}
