# using module .\.\Get-ScriptFile.ps1

function New-Storage {
    [CmdletBinding(DefaultParameterSetName = "ParameterSetName",
        # ConfirmImpact = <String>,
        # HelpURI = <URI>,
        # SupportsPaging = $false,
        # SupportsShouldProcess = $false,
        PositionalBinding = $true)]
    [OutputType([string], ParameterSetName = "ParameterSetName")]
    Param(

    )
    <#
    DynamicParam {
        if ($path -match ".HKLM.:") {
            $attributes = New-Object -Type `
                System.Management.Automation.ParameterAttribute
            $attributes.ParameterSetName = "__AllParameterSets"
            $attributes.Mandatory = $false
            $attributeCollection = New-Object `
                -Type System.Collections.ObjectModel.Collection[System.Attribute]
            $attributeCollection.Add($attributes)

            $dynParam1 = New-Object -Type `
                System.Management.Automation.RuntimeDefinedParameter("dp1", [Int32],
                $attributeCollection)

            $paramDictionary = New-Object `
                -Type System.Management.Automation.RuntimeDefinedParameterDictionary
            $paramDictionary.Add("dp1", $dynParam1)
            return $paramDictionary
        }
    }
    #>
    begin {
    }
    
    process {



    }
    
    end {
        # Change these four parameters as needed
        $ACI_PERS_RESOURCE_GROUP = 'orldataResourceGroupV'
        $ACI_PERS_STORAGE_ACCOUNT_NAME = 'orldatastorageaccount1'
        $ACI_PERS_LOCATION = 'eastus'
        $ACI_PERS_SHARE_NAME = 'orldatafileshare'

        az webapp config appsettings set `
            --resource-group $ACI_PERS_RESOURCE_GROUP `
            --name 'orldataWebApp' `
            --settings WEBSITES_ENABLE_APP_SERVICE_STORAGE=true

        # Create the storage account with the parameters
        $A = az storage account create `
            --resource-group $ACI_PERS_RESOURCE_GROUP `
            --name $ACI_PERS_STORAGE_ACCOUNT_NAME `
            --location $ACI_PERS_LOCATION `
            --sku Standard_LRS

        # Create the file share
        $B = az storage share create `
            --name $ACI_PERS_SHARE_NAME `
            --account-name $ACI_PERS_STORAGE_ACCOUNT_NAME
    }
}
