function Connect-XAzAccount {
    [CmdletBinding()]
    Param(
        [switch]$PassThru
    )

    begin {
        if (-not $PSBoundParameters.ContainsKey('Verbose')) {
            $VerbosePreference = $PSCmdlet.GetVariableValue('VerbosePreference')
        }
    }
    
    end {
        
        Write-Verbose "Checking for a connected Azure session"
        $IsConnected = Get-AzSubscription -ErrorAction SilentlyContinue -OutVariable CurrentSubscription | `
            Measure-Object | `
            ForEach-Object { $($_.Count -eq 1) }
        
        if ($IsConnected -eq $false) {
            $IsConnected = Connect-AzAccount -Confirm -OutVariable CurrentSubscription | `
                Measure-Object | `
                ForEach-Object { $($_.Count -eq 1) }
        }
        
        if ($IsConnected -eq $true) {
            Write-Verbose "Connected to Azure with the following subscription: $($CurrentSubscription.SubscriptionId)"
        }
        else {
            Write-Error "Unabled to connect with Azure."
        }

        if ($PassThru.IsPresent) {
            $IsConnected
        }
    }
}
