using module .\Get-XAzRegistryCredentials.ps1

function Approve-XAzRegistryName {
    [CmdletBinding(
        PositionalBinding = $true
    )]
    [OutputType(
        [pscustomobject]
    )]
    param(
        [Parameter(
            Mandatory = $true,
            HelpMessage = "The resource group of where the proposed container registry will reside.",
            Position = 0
        )]
        [string]$ResourceGroupName,

        [Parameter(
            Mandatory = $true,
            HelpMessage = "The proposed container registry name.",
            Position = 1
        )]
        [string]$Name
    )

    begin {
        if (-not $PSBoundParameters.ContainsKey('Verbose')) {
            $VerbosePreference = $PSCmdlet.GetVariableValue('VerbosePreference')
        }
        
        Write-Verbose "Checking availability of container registry name"

        $IsContainerRegistryNameAvailable = $false
        $Dirty = $false
        $AlreadyCreatedUnderResourceGroup = Get-AzContainerRegistry -ResourceGroupName $ResourceGroupName | `
            Select-Object -ExpandProperty Name | `
            Where-Object { $_ -eq $Name } | `
            Measure-Object | `
            ForEach-Object { $($_.Count -eq 1) }

        if ($AlreadyCreatedUnderResourceGroup -eq $false) {
            do {
                $IsContainerRegistryNameAvailable = Test-AzContainerRegistryNameAvailability -Name $Name | `
                    Select-Object -ExpandProperty NameAvailable
                if ($IsContainerRegistryNameAvailable) {
                    Write-Verbose "Container registry name '$Name', is available for use."
                }
                else {
                    Write-Warning "Container registry name '$Name', is not available for use."
                    $Name = $null
                    $Dirty = $true
                    $Name = Read-Host "Enter a different name for container registry"
                }
            } until ($IsContainerRegistryNameAvailable -eq $true)
        }
    }
    
    end {
        if ($AlreadyCreatedUnderResourceGroup -eq $true) {
            Write-Verbose "Found exisiting container registry name under resource group specified"
            $Approved = $true
            $Available = $false
        }
        elseif ($IsContainerRegistryNameAvailable -eq $true) {
            Write-Verbose "Approved availability of container registry name of: $Name"
            $Approved = $true
            $Available = $true
        }
        else {
            Write-Error "Unable to approved container registry name."
            $Approved = $false
            $Available = $false
        }

        [pscustomobject]@{
            Name      = $Name
            Available = $Available
            Approved  = $Approved
            Dirty     = $Dirty
        }
    }
}
