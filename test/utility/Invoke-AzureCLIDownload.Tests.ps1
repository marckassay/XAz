Describe 'Test Invoke-AzureCLIDownload' {
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
        $Version = '2.0.70'

        Mock Invoke-WebRequest {
            $Encode = [system.Text.Encoding]::UTF8
            $Bytes = 1..50 | ForEach-Object { $_ * (Get-Random -SetSeed 2) }

            New-MockObject -Type Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject | Add-Member -MemberType NoteProperty -Name Content -Value $($Encode.GetBytes($Bytes)) -Force -PassThru

            Start-Sleep -Milliseconds 500 | Out-Null

        } -ModuleName XAz

        Mock Invoke-Expression { } -ModuleName XAz -Verifiable

        It 'Should have created MSI file in TestDrive folder' {
            Invoke-AzureCLIDownload -Version $Version -Path $TestDrive | Select-Object -ExpandProperty CommandType
            $TestDriveChildItemName = Get-ChildItem $TestDrive | Select-Object -First 1 -ExpandProperty Name
            $TestDriveChildItemName | Should -Be "azure-cli-${Version}.msi"
        }

        It 'Should have not attempted to auto execute file' {
            Invoke-AzureCLIDownload -Version $Version -Path $TestDrive | Select-Object -ExpandProperty CommandType

            Assert-MockCalled Invoke-Expression -ParameterFilter { $Command -eq "$TestDrive\azure-cli-${Version}.msi" } -Times 0 -ModuleName XAz
        }

        It 'Should have attempted to auto execute file' {
            Invoke-AzureCLIDownload -Version $Version -Path $TestDrive -AutoExecute | Select-Object -ExpandProperty CommandType

            Assert-MockCalled Invoke-Expression -ParameterFilter { $Command -eq "$TestDrive\azure-cli-${Version}.msi" } -Times 1 -ModuleName XAz
        }
    }
}

