function Approve-XAzDomainName {
    [CmdletBinding(
        PositionalBinding = $true
    )]
    param(
        [Parameter(
            Mandatory = $true,
            HelpMessage = "The proposed sub-domain in the following url: azurewebsites.net",
            Position = 0
        )]
        [string]$Name
    )

    begin {
        if (-not $PSBoundParameters.ContainsKey('Verbose')) {
            $VerbosePreference = $PSCmdlet.GetVariableValue('VerbosePreference')
        }
        
        Write-Verbose "Checking availability of sub-domain"

        do {
            [boolean]$IsHostNameAvailableForUse = $false
            try {
                $Uri = 'https://host.azurewebsites.net/' -replace 'host', $Name

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
                Write-Verbose "Sub-domain, '$Name', is available for use."
            }
            else {
                Write-Warning "Sub-domain, '$Name' is not available for use."
                $Name = $null
                $Name = Read-Host "Try again. Enter a different name"
            }
        } until ($IsHostNameAvailableForUse -eq $true)
    }
    
    end {
        if ($IsHostNameAvailableForUse) {
            Write-Verbose "Checked and verified availability of sub-domain name of: $Name"
            $Name
        }
        else {
            Write-Error "Unable to verify sub-domain name is availabile."
        }
    }
}
