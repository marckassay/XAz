Describe 'Test New-XAzResourceGroupDeployment' {
    BeforeAll {
        $ModuleHome = $script:PSCommandPath | Split-Path -Parent | Split-Path -Parent | Split-Path -Parent

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

    Context 'with provided registry and image name' {

        Push-Location
        Set-Location $TestDrive

        $TestATemplatePath = Join-Path $TestDrive "/build/templates/TestATemplate.json" 
        New-Item -Path $TestATemplatePath -Force
        
        Mock New-AzResourceGroupDeployment -ModuleName XAz
        
        Mock Write-Warning { $WarningAction -eq 'Inquire' } -ModuleName XAz

        # TODO: Running into this limitation with parameters. Also if attempt to find a solution again, be aware of VS Code or OS holding a PS session eventhough all console appear to be closed.:
        # https://github.com/pester/Pester/issues/706
        #
        It 'Should called New-AzResourceGroupDeployment with specified parameters' {
            
            $PesterTemplateParameterObject = @{
                containerGroupName = ''
                registryImageUrl   = 'orldatacontainerregistry.azurecr.io/orldata/prod:0.0.1'
                sslKey             = ''
            }

            New-XAzResourceGroupDeployment `
                -ContainerRegistryName 'orldatacontainerregistry' `
                -Image 'orldata/prod:0.0.1' `
                -TemplateName 'TestATemplate.json'

            Assert-MockCalled New-AzResourceGroupDeployment `
                -ParameterFilter { 
                $TemplateFile -eq $TestATemplatePath -and 
                $Mode -eq 'Incremental' -and 
                $AsJob -eq $false -and 
                $Force -eq $false 
            } -Times 1 -ModuleName XAz

            Assert-MockCalled New-AzResourceGroupDeployment `
                -ParameterFilter { $TemplateParameterObject.registryImageUrl -eq $PesterTemplateParameterObject.registryImageUrl } `
                -Times 1 `
                -ModuleName XAz

            Assert-MockCalled Write-Warning `
                -Times 1 `
                -ModuleName XAz
        }

        Pop-Location
    }
}
