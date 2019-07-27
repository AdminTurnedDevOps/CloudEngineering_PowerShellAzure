Function New-AzureVM {
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low')]
    param(
        [parameter(Position = 0,
            HelpMessage = 'Please type in a VM name')]
        [ValidateNotNullOrEmpty()]
        [string]$VMName = "myubuntu",

        [parameter(Position = 1,
            HelpMessage = 'Please type in a resource group name')]
        [ValidateNotNullOrEmpty()]
        [string]$RGName = "CICD2",

        [parameter(Position = 2,
            HelpMessage = 'Please type in a VM name')]
        [ValidateNotNullOrEmpty()]
        [string]$Location = 'East US',

        [parameter(Position = 3)]
        [string]$subnet = "UbuntuSubnet",

        [parameter(Position = 4)]
        [Alias('SG')]
        [string]$SecurityGroup = "UbuntuSG",

        [parameter(Position = 5,
            HelpMessage = 'Please try in the virtual network for your VM')]
        [Alias('VirtualNetworkName')]
        [string]$vNet,

        [parameter(Position = 6)]
        [ValidateNotNullOrEmpty()]
        [string]$PubIPName = $VMName,

        [parameter(Position = 7,
        HelpMessage = 'Please choose an image. By default, Azure picks Windows Server 2016 Datacenter')]
        [ValidateNotNullOrEmpty()]
        [string]$VMImage = "Ubuntu Server 18.04 LTS"
    
    )

    begin {
        $checkVMs = Get-AzVM
        $CheckVMsOBJECT = [pscustomobject] @{
            'InstanceName' = $checkVMs.Name
        }
        if ($checkVMs -like $checkVMs) {
            Write-Host "VM Already Exists"
            break
        }
    }
    process {
        try {
            $VMParams = @{
                'ResourceGroupName' = $RGName
                'Name'              = $VMName
                'Location'          = $Location

            }

            $MyNewWindowsVM = New-AzVM @VMParams
            $MyNewWindowsVMOBJECT = [pscustomobject] @{
                'Name' = $MyNewWindowsVM.Name
                'FQDN' = $MyNewWindowsVM.FullyQualifiedDomainName

            }
            $MyNewWindowsVMOBJECT

        }#Try

        catch {
            Write-Warning 'WARNING: An error has occured. Please review the error code below'
            $PSCmdlet.ThrowTerminatingError($_)

        }#Catch
    }#Process
    end {}
}#Function
New-AzureVM
