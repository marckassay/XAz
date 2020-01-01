function Approve-XAzDomainName {
    [CmdletBinding(
        PositionalBinding = $true
    )]
    [OutputType(
        [pscustomobject]
    )]
    param(
        [Parameter(
            Mandatory = $true,
            HelpMessage = "The resource group of where the proposed webapp will reside.",
            Position = 0
        )]
        [string]$ResourceGroupName,

        [Parameter(
            Mandatory = $true,
            HelpMessage = "The proposed sub-domain that will replace the asterick in the DomainName parameter.",
            Position = 1
        )]
        [string]$SubDomainName,

        [Parameter(
            Mandatory = $false,
            HelpMessage = "By default Microsoft.Web/Sites has a domain of: '*.azurewebsites.net'.",
            Position = 2
        )]
        [ValidatePattern("[\*][\.][a-zA-Z0-9]+[\.][a-zA-Z0-9]+")]
        [string]$DomainName = "*.azurewebsites.net"
    )

    begin {
        if (-not $PSBoundParameters.ContainsKey('Verbose')) {
            $VerbosePreference = $PSCmdlet.GetVariableValue('VerbosePreference')
        }
        
        Write-Verbose "Checking availability of sub-domain"

        $IsHostNameAvailableForUse = $false
        $Dirty = $false
        $Uri = $DomainName -replace '[\*]', $SubDomainName

        $AlreadyCreatedUnderResourceGroup = Get-AzWebApp -ResourceGroupName $ResourceGroupName | `
            Where-Object -Property Name -EQ $SubDomainName | `
            Measure-Object | `
            ForEach-Object { $($_.Count -eq 1) }

        if ($AlreadyCreatedUnderResourceGroup -eq $false) {
            do {
                try {
                    Invoke-WebRequest -Uri $Uri -ErrorAction Stop -Verbose:$false | Out-Null
                    # if Invoke-WebRequest doesnt throw an error, than it probably exists. so this host 
                    # name is not available to use.
                    $IsHostNameAvailableForUse = $false
                }
                catch {
                    # if it fails, I'm assuming that because it doesn't exist. so this host name is 
                    # available for use.
                    $IsHostNameAvailableForUse = $true
                }

                if ($IsHostNameAvailableForUse) {
                    Write-Verbose "The domain, '$Uri', is available for use."
                }
                else {
                    Write-Warning "The domain, '$Uri' is not available for use."
                    $SubDomainName = $null
                    $Dirty = $true
                    $SubDomainName = Read-Host "Enter a different value for sub-domain"
                }
            } until ($IsHostNameAvailableForUse -eq $true)
        }
    }
    
    end {
        if ($AlreadyCreatedUnderResourceGroup -eq $true) {
            Write-Verbose "Found exisiting web app name under resource group specified"
            $Approved = $true
            $Available = $false
        }
        elseif ($IsHostNameAvailableForUse) {
            Write-Verbose "Checked and verified availability: $Uri"
            $Approved = $true
            $Available = $true
        }
        else {
            Write-Error "Unable to verify domain is availabile."
            $Approved = $false
            $Available = $false
        }
        
        [pscustomobject]@{
            Available     = $Available
            Approved      = $Approved
            SubDomainName = $SubDomainName
            DomainName    = $DomainName
            Uri           = $Uri
            Dirty         = $Dirty
        }
    }
}
