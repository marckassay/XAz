function Confirm-XAzResourceGroup {

    [CmdletBinding(
        PositionalBinding = $true
    )]
    [OutputType(
        [hashtable]
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
        [string]$Location

    )

    begin {
        if (-not $PSBoundParameters.ContainsKey('Verbose')) {
            $VerbosePreference = $PSCmdlet.GetVariableValue('VerbosePreference')
        }
    }
    
    end {
        Write-Verbose "Checking for resource group: $Name"

        $IsExisting = Get-AzResourceGroup -Name $Name -ErrorAction SilentlyContinue -OutVariable ResourceGroup | `
            Measure-Object | `
            ForEach-Object { $($_.Count -eq 1) }

        if ($IsExisting -eq $false) {
            Write-Warning "Resource group was not found. This is needed to continue."
            $CreateResourceGroup = Read-Confirmation "Do you want to create it under current subscription?"
                
            if ($CreateResourceGroup) {
                $CreationResults = New-AzResourceGroup -Name $Name -Location $Location -Verbose -OutVariable ResourceGroup
                if ($CreationResults.ProvisioningState -ne 'Succeeded') {
                    $CreationResults = $null
                }
                else {
                    $IsExisting = $true
                }
            }
            else {
                $CreationResults = $null
            }
        }

        if (($IsExisting -eq $false) -and ($null -eq $CreationResults)) {
            Write-Error "Wasn't able to create required resource group"
            $null
        }
        else {
            Write-Verbose "Verified resource group exist"
            $ResourceGroup.ResourceId
        }
    }
}
