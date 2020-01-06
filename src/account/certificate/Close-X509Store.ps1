function Close-X509Store {
    Param(
        [switch]$Force
    )

    end {

        if ($Force.IsPresent) {
            
            Get-Job -Id $($Script:ClosingStoreJob.Id) -ErrorAction SilentlyContinue | Stop-Job
            
            if ($null -ne $script:X509Store) {
                $script:X509Store.Close()
                $script:X509Store = $null
            }
        }
        elseif (($null -ne $script:X509Store) -and ($script:X509Store.IsOpen -eq $true)) {
            
            # debounce Store.Close() for 60 seconds
            $IsJobRunning = $Script:ClosingStoreJob | `
                Select-Object -ExpandProperty State | `
                ForEach-Object { $($_ -eq 'Running') }
            
            if (-not $IsJobRunning) {
                
                $script:ClosingStoreJob = Start-Job -Name STJ {
                    Start-Sleep -Seconds 60
                    $script:X509Store.Close()
                    $script:X509Store = $null
                    Get-Job -Id $($Script:ClosingStoreJob).Id -ErrorAction SilentlyContinue | Stop-Job
                }
            }
        }
    }
}
