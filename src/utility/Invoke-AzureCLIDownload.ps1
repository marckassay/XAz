function Invoke-AzureCLIDownload {

    <#
    .SYNOPSIS
    Short description
    
    .DESCRIPTION
    Long description
    
    .PARAMETER Version
    Parameter description
    
    .PARAMETER Path
    Parameter description
    
    .PARAMETER AutoExecute
    Parameter description
    
    .EXAMPLE
    An example
    
    .NOTES
    General notes
    #>
    
    [CmdletBinding(PositionalBinding = $true)]
    [OutputType()]
    param(
        [Parameter(
            Mandatory = $true,
            HelpMessage = "The Azure CLI semver.",
            Position = 0
        )]
        [ValidatePattern("(\d\.){2}(\d)")]
        [string]$Version,

        [Parameter(
            Mandatory = $false,
            HelpMessage = "The location where the file will be downloaded.",
            Position = 1
        )]
        [string]$Path = '.',

        [switch]
        $AutoExecute
    )

    $BaseName = "azure-cli-" + $Version + ".msi"
    $FullName = Join-Path $Path $BaseName
    $Url = "https://azurecliprod.blob.core.windows.net/msi/" + $BaseName;

    Write-Host ("Step 1 of 2: Invoking-WebRequest with a Uri value of: " + $Url)
    $Response = Invoke-WebRequest -Uri $Url -ErrorAction Stop
    
    Write-Host ("Step 2 of 2: Writing Bytes of downloaded file to: " + $FullName)
    try {
        [io.file]::WriteAllBytes($FullName, $Response.Content)

        if ($AutoExecute.IsPresent) {
            Write-Host ("Executing " + $BaseName + " now.")
            Invoke-Expression -Command $FullName
        }
        else {
            Write-Host ("The file is located here: " + $Path)
        }
    }
    catch {
        Write-Host ("An error occurred writing the file to :" + $Path)
    }
}
