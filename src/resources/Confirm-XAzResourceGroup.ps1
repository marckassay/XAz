function Confirm-XAzResourceGroup {

    [CmdletBinding(
        PositionalBinding = $true
    )]
    [OutputType(
        [pscustomobject]
    )]
    Param(
        [Parameter(
            Mandatory = $true,
            Position = 0
        )]
        [ValidateNotNull()]
        [string]$Name,

        [Parameter(
            Mandatory = $true,
            Position = 1
        )]
        [ValidateNotNull()]
        [string]$Location,
        
        [switch]$Prompt
    )

    begin {
        if (-not $PSBoundParameters.ContainsKey('Verbose')) {
            $VerbosePreference = $PSCmdlet.GetVariableValue('VerbosePreference')
        }
    }
    
    end {
        Write-Verbose "Checking for resource group: $Name"

        $RequiredCreation = $false
        $IsExisting = Get-AzResourceGroup -Name $Name -ErrorAction SilentlyContinue -OutVariable ResourceGroup | `
            Measure-Object | `
            ForEach-Object { $($_.Count -eq 1) }

        if ($IsExisting -eq $false) {
            Write-Warning "Resource group was not found. This is needed to continue."

            if ($Prompt.IsPresent -eq $true) {
                $CreateResourceGroup = Read-Confirmation "Do you want to create it now under current subscription?"
            }
            
            if ($CreateResourceGroup) {
                $CreationResults = New-AzResourceGroup -Name $Name -Location $Location -Verbose -OutVariable ResourceGroup
                $IsExisting = ($CreationResults.ProvisioningState -eq 'Succeeded')
                $RequiredCreation = $true
            }
            else {
                $IsExisting = $false
            }
        }
        else {
            Write-Verbose "Verified resource group existence"
        }

        # post Write-Warning procedures
        if ($IsExisting -eq $true) {
            
            if ($RequiredCreation) {
                $Msg = "Created and verified resource group existence"
            }
            else {
                $Msg = "Verified resource group existence"
            }

            Write-Verbose $Msg
            
            [pscustomobject]@{
                Id               = $ResourceGroup.ResourceId
                Name             = $Name
                RequiredCreation = $RequiredCreation
            }
        }
        else {
            Write-Error "Wasn't able to create required resource group"
            
            [pscustomobject]@{
                Id               = ''
                Name             = $Name
                RequiredCreation = $false
            }
        }
    }
}
