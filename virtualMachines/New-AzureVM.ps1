Function New-AzureVM {
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low')]
    param(
        [parameter(Position = 0,
            Mandatory = $true,
            HelpMessage = 'Please type in a VM name')]
        [ValidateNotNullOrEmpty()]
        [string]$VMName,

        [parameter(Position = 1,
            Mandatory = $true,
            HelpMessage = 'Please type in a resource group name')]
        [ValidateNotNullOrEmpty()]
        [string]$RGName,

        [parameter(Position = 2,
            HelpMessage = 'Please type in a VM name')]
        [ValidateNotNullOrEmpty()]
        [string]$Location = 'East US',

        [parameter(Position = 3,
            Mandatory = $true)]
        [string]$subnet,

        [parameter(Position = 4,
            Mandatory = $true)]
        [Alias('SG')]
        [string]$SecurityGroup,

        [parameter(Position = 5,
            Mandatory = $true,
            HelpMessage = 'Please try in the virtual network for your VM')]
        [Alias('VirtualNetworkName')]
        [string]$vNet,

        [parameter(Position = 6)]
        [ValidateNotNullOrEmpty()]
        [string]$PubIPName = $VMName,

        [parameter(Position = 7,
        HelpMessage = 'Please choose an image. By default, Azure picks Windows Server 2016 Datacenter')]
        [ValidateNotNullOrEmpty()]
        [string]$VMImage
    
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
            if ($PSCmdlet.ShouldProcess($VMName)) {

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
            }

        }#Try

        catch {
            Write-Warning 'WARNING: An error has occured. Please review the error code below'
            $PSCmdlet.ThrowTerminatingError($_)

        }#Catch
    }#Process
    end {}
}#Function
