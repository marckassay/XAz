using module .\Get-XAzRegistryCredentials.ps1

function Approve-XAzRegistryName {
    [CmdletBinding(
        PositionalBinding = $true
    )]
    param(
        [Parameter(
            Mandatory = $true,
            HelpMessage = "The proposed container registry name.",
            Position = 0
        )]
        [AllowNull()]
        [string]$Name,

        [switch]$AcceptExisting
    )

    begin {
        if (-not $PSBoundParameters.ContainsKey('Verbose')) {
            $VerbosePreference = $PSCmdlet.GetVariableValue('VerbosePreference')
        }
        
        Write-Verbose "Checking availability of container registry name"

        $AlreadyExists = Get-XAzRegistryCredentials -ContainerRegistryName $Name -WarningAction SilentlyContinue | `
            Measure-Object | `
            ForEach-Object { $($_.Count -eq 1) }

        if (($AcceptExisting.IsPresent -eq $true) -and ($AlreadyExists -eq $true)) {
            $NameAsIs = $Name
        }
        else {
            [boolean]$IsContainerRegistryNameAvailable = $false

            do {
                $IsContainerRegistryNameAvailable = Test-AzContainerRegistryNameAvailability -Name $Name | `
                    Select-Object -ExpandProperty NameAvailable
                if ($IsContainerRegistryNameAvailable) {
                    Write-Verbose "Container registry name '$Name', is available for use."
                }
                else {
                    Write-Warning "Container registry name '$Name', is not available for use."
                    $Name = $null
                    $Name = Read-Host "Try again. Enter a different name"
                }
            } until ($IsContainerRegistryNameAvailable -eq $true)
        }
    }
    
    end {
        # $NameAsIs is set only when AcceptExisting is switched and a container registry exists with
        # this name. If this is the case, then the $Name will be returned 'as-is' (without changes)
        if ($null -ne $NameAsIs) {
            Write-Verbose "Found exisiting container registry name"
            $NameAsIs
        }
        elseif ($null -ne $Name) {
            Write-Verbose "Checked and verified availability of container registry name of: $Name"
            $Name
        }
        else {
            Write-Error "Unable to verify container registry name is availabile."
        }
    }
}
