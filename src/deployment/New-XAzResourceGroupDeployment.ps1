using module .\..\internal\ParameterCompleters.ps1

Register-ArgumentCompleter `
    -CommandName New-XAzResourceGroupDeployment `
    -ParameterName ContainerRegistryName `
    -ScriptBlock $ContainerRegistryNameCompleter

Register-ArgumentCompleter `
    -CommandName New-XAzResourceGroupDeployment `
    -ParameterName Image `
    -ScriptBlock $ImageCompleter

Register-ArgumentCompleter `
    -CommandName New-XAzResourceGroupDeployment `
    -ParameterName TemplateName `
    -ScriptBlock $TemplateNameCompleter

function New-XAzResourceGroupDeployment {
    
    [CmdletBinding(PositionalBinding = $true)]
    [OutputType()]
    param (
        [Parameter(
            Mandatory = $false,
            ValueFromPipeline = $true,
            HelpMessage = "The resource group names available from the current Azure subscription."
        )]
        [hashtable]$TemplateParameterObject,

        [Parameter(
            Mandatory = $true,
            HelpMessage = "The resource group names available from the current Azure subscription.",
            Position = 0
        )]
        [string]$ContainerRegistryName,

        [Parameter(
            Mandatory = $true,
            HelpMessage = "The image in the container registry. This defined set is determined by the 
            ContainerRegistryName parameter.",
            Position = 1
        )]
        [string]$Image,

        [Parameter(
            Mandatory = $true,
            ParameterSetName = "ByTemplateName",
            HelpMessage = "The file names of Json files located in the `${PWD}/build/templates` folder.",
            Position = 2
        )]
        [string]$TemplateName,

        [Parameter(
            Mandatory = $true,
            ParameterSetName = "ByTemplateFile",
            HelpMessage = "The location of a Template file.",
            Position = 2
        )]
        [string]$TemplateFile,

        [Parameter(
            Mandatory = $false,
            HelpMessage = "Specifies the name of the resource group deployment to create. A name 
            will be generated if one isn't given.",
            Position = 3
        )]
        [string]$Name,

        [Parameter(
            Mandatory = $false,
            Position = 4
        )]
        [ValidateSet("Incremental", "Complete")]
        [string]$Mode = "Incremental",

        [switch]
        $AsJob,

        [switch]
        $Force,

        [switch]
        $WhatIf
    )

    begin {
        # check to see if there is a current Azure session, if not prompt to initiate one
        try {
            Get-AzSubscription | Out-Null
        }
        catch {
            Write-Warning "The function 'Get-AzSubscription' didn't return information indicating that you are in a PowerShell Azure session. Would you like to connect?" -WarningAction Inquire
            Connect-AzAccount
        }
        
        $ImageRegistryCredentials = Get-XAzRegistryCredentials $ContainerRegistryName

        if ($TemplateName.Length -gt 0) { 
            $TemplateFile = Join-Path -Path . -ChildPath 'build/templates' -AdditionalChildPath $TemplateName -Resolve
        }
        # from this point down $TemplateFile will only be used

        # if no name for this deployment, generated a one
        if ($Name.Length -eq 0) { 
            $Name = 'xAzGenResource' + $(Get-Random -Minimum 12345 -Maximum 999999)
        }

        $CommandParameterObject = @{
            ResourceGroupName = $ImageRegistryCredentials.ResourceGroupName
            TemplateFile      = $TemplateFile
            Mode              = $Mode
            AsJob             = $AsJob.IsPresent 
            Force             = $Force.IsPresent
        }
    }

    process {
        # keep $TemplateParameterObject out of begin block as it may have been piped
        if ($TemplateParameterObject -eq $null) {
            $TemplateParameterObject = @{ }
        }

        $TemplateParameterObject.Add('containerGroupName', $Name)
        $TemplateParameterObject.Add('registryImageUrl', $ImageRegistryCredentials.Image.server + "/" + $Image)
        $TemplateParameterObject.Add('imageRegistryCredentials', $ImageRegistryCredentials.Image )
    }

    end {

        if ($WhatIf.IsPresent -eq $false) {

            Write-Warning @"
Scalar parameters to be used: 
$($CommandParameterObject | Format-Table | Out-String)
And TemplateParameterObject:
$($TemplateParameterObject | Format-Table | Out-String -Width 100)

You are about to execute New-AzResourceGroupDeployment command with the above values.
"@ -WarningAction Inquire

            New-AzResourceGroupDeployment `
                @CommandParameterObject `
                -TemplateParameterObject $TemplateParameterObject
        }
        else {

            Test-AzResourceGroupDeployment `
                -ResourceGroupName $ImageRegistryCredentials.ResourceGroupName `
                -TemplateFile $TemplateFile `
                -Mode $Mode `
                -TemplateParameterObject $TemplateParameterObject
        }
    }
}