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

<# 
    TODO: Split this function in 2; the first 2 parameters can be in a function that can be piped
    into this one.
#>
function New-XAzResourceGroupDeployment {

    <##
    .SYNOPSIS
    Creates a resource deployment under the Resource Group specified by the $ContainerRegistryName
    parameter.

    .DESCRIPTION
    Before calling this function, the PS session must have a current Azure session. Check by 
    verifying that Get-AzSubscription returns a value. The $ContainerRegistryName parameter 
    specifies which Resource Group to use by name from the current Azure subscription.

    .NOTES

    .PARAMETER ContainerRegistryName
    Autocompleter enabled. The container name to retrieve the credentials from.

    .PARAMETER TemplateName
    Autocompleter enabled. The file name of the template to be used for deployment. This is a dynamic ValidateSet param.
    It searches templates in the `$PWD/builds/templates` folder

    .PARAMETER TemplateFile
    The local path to a template file to be used for deployment.

    .PARAMETER Image
    Autocompleter enabled. The image to be used in the deployment that is registered in the 
    Container specified by ContainerRegistryName.

    .PARAMETER Mode
    Specifies the deployment mode. The acceptable values for this parameter are:
        Complete: In complete mode, Resource Manager deletes resources that exist in the resource
        group but are not specified in the template.
        
        Incremental: In incremental mode, Resource Manager leaves unchanged resources that exist
        in the resource group but are not specified in the template

    .PARAMETER AsJob
    Run cmdlet in the background

    .PARAMETER Force
    Forces the command to run without asking for user confirmation.

    .PARAMETER WhatIf
    A switch to call `Test-AzResourceGroupDeployment` function instead of its counterpart `New`.

    .EXAMPLE
    Get-DeploymentTemplateObject -SslKeyPath 'D:\Google Drive\Documents\Programming\orldata\ssl.key' | New-XAzResourceGroupDeployment -ContainerRegistryName orldataContainerRegistry -Image orldata/prod:0.0.1 -Name orldata-deploygroup -TemplateName deploy-orldata-ssl.json
    WARNING: Scalar parameters to be used:

    Name                           Value
    ----                           -----
    TemplateFile                   E:\marckassay\orldata\build\templates\deploy-orldata-ssl.json
    AsJob                          False
    Force                          False
    ResourceGroupName              orldataResourceGroup
    Mode                           Incremental


    And TemplateParameterObject:

    Name                           Value
    ----                           -----
    containerGroupName             orldata-deploygroup
    nginxConf                      IyBuZ2lueCBDb25maWd1cmF0aW9uIEZpbGUNCiMgaHR0cHM6Ly93aWtpLm5naW54Lm9y…
    sslCrt                         LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tDQpNSUlEcWpDQ0FwSUNDUUM4bHNhRWdH…
    registryImageUrl               orldatacontainerregistry.azurecr.io/orldata/prod:0.0.1
    sslKey                         LS0tLS1CRUdJTiBQUklWQVRFIEtFWS0tLS0tDQpNSUlFdkFJQkFEQU5CZ2txaGtpRzl3…
    imageRegistryCredentials       {orldataContainerRegistry}



    You are about to execute New-AzResourceGroupDeployment command with the above values.

    Confirm
    Continue with this operation?
    [Y] Yes  [A] Yes to All  [H] Halt Command  [S] Suspend  [?] Help (default is "Y"): A

    Id     Name            PSJobTypeName   State         HasMoreData     Location             Command
    --     ----            -------------   -----         -----------     --------             -------
    1      Long Running O… AzureLongRunni… Running       True            localhost            New-AzResourceGroupDeplo…

    E:\marckassay\orldata [master ≡]> Get-Job 1 | Format-List

    HasMoreData          : True
    Location             : localhost
    StatusMessage        : Completed
    CurrentPSTransaction :
    Host                 : System.Management.Automation.Internal.Host.InternalHost
    Command              : New-AzResourceGroupDeployment
    JobStateInfo         : Completed
    Finished             : System.Threading.ManualResetEvent
    InstanceId           : 232b9d4f-604d-411f-a560-b720a4c90b95
    Id                   : 1
    Name                 : Long Running Operation for 'New-AzResourceGroupDeployment'
    ChildJobs            : {}
    PSBeginTime          : 8/4/2019 11:06:39 PM
    PSEndTime            : 8/4/2019 11:06:47 PM
    PSJobTypeName        : AzureLongRunningJob`1
    Output               : {Microsoft.Azure.Commands.ResourceManager.Cmdlets.SdkModels.PSResourceGroupDeployment}
    Error                : {}
    Progress             : {}
    Verbose              : {11:06:40 PM - Template is valid., 11:06:41 PM - Create template deployment 'deploy-orldata-ssl', 11:06:41 PM - Checking deployment status in 5 seconds, 11:06:46 PM -
                        Resource Microsoft.ContainerInstance/containerGroups 'orldata-deploygroup' provisioning status is succeeded}
    Debug                : {[AzureLongRunningJob]: Starting cmdlet execution, setting for cmdlet confirmation required: 'False', [AzureLongRunningJob]: Completing cmdlet execution in RunJob}
    Warning              : {}
    Information          : {}
    State                : Completed

    # TODO: explaination

    .FUNCTIONALITY
        PowerShell Language
    #>
    
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
            Position = 1
        )]
        [string]$ContainerRegistryName,

        [Parameter(
            Mandatory = $true,
            HelpMessage = "The image in the container registry. This defined set is determined by the 
            ContainerRegistryName parameter.",
            Position = 2
        )]
        [string]$Image,

        [Parameter(
            Mandatory = $true,
            ParameterSetName = "ByTemplateName",
            HelpMessage = "The file names of Json files located in the `${PWD}/build/templates` folder.",
            Position = 3
        )]
        [string]$TemplateName,

        [Parameter(
            Mandatory = $true,
            ParameterSetName = "ByTemplateFile",
            HelpMessage = "The location of a Template file.",
            Position = 3
        )]
        [string]$TemplateFile,

        [Parameter(
            Mandatory = $false,
            HelpMessage = "Specifies the name of the resource group deployment to create. A name 
            will be generated if one isn't given.",
            Position = 4
        )]
        [string]$Name,

        [Parameter(
            Mandatory = $false,
            Position = 5
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

        Write-Warning @"
Scalar parameters to be used: 
$($CommandParameterObject | Format-Table | Out-String)
And TemplateParameterObject:
$($TemplateParameterObject | Format-Table | Out-String -Width 100)

You are about to execute New-AzResourceGroupDeployment command with the above values.
"@ -WarningAction Inquire

        if ($WhatIf.IsPresent -eq $false) {

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