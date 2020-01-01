function Connect-XAzAccount {
    [CmdletBinding()]
    [OutputType(
        [pscustomobject]
    )]
    Param(
        [switch]$PassThru
    )

    begin {
        if (-not $PSBoundParameters.ContainsKey('Verbose')) {
            $VerbosePreference = $PSCmdlet.GetVariableValue('VerbosePreference')
        }
    }
    
    end {
        
        Write-Verbose "Checking for an Azure context"
        
        $IsConnected = Get-AzContext -ErrorAction SilentlyContinue -OutVariable SelectedContext | `
            Measure-Object | `
            ForEach-Object { $($_.Count -ge 1) }
        
        if ($IsConnected -eq $false) {
            $IsConnected = Connect-AzAccount -Confirm -OutVariable SelectedContext | `
                Measure-Object | `
                ForEach-Object { $($_.Count -ge 1) }
        }
        
        if ($IsConnected -eq $true) {
            Write-Verbose @"
The selected Azure context will be used: 
$SelectedContext
"@
        }
        else {
            Write-Error "Unabled to select an Azure context."
        }

        if ($PassThru.IsPresent) {
            $SelectedContext
        }
    }
}
