Describe 'Test ConvertTo-Base64' {
    BeforeAll {
        $ModuleHome = $script:PSCommandPath | Split-Path -Parent | Split-Path -Parent | Split-Path -Parent

        # Reimports 'XAz'.  If its not currently import just silently continue
        Remove-Module -Name 'XAz' -ErrorAction SilentlyContinue
        Import-Module $ModuleHome

        InModuleScope 'XAz' {
            $script:SUT = $true
        }
    }
    
    AfterAll {
        InModuleScope 'XAz' {
            $script:SUT = $false
        }
    }

    Context 'Post executing New-Script' {
        It 'Should have command accessible' {
            $Results = Get-Command ConvertTo-Base64 | Select-Object -ExpandProperty CommandType
            $Results | Should -Be 'Function'
        }
    }
}

