function Get-PublicInstances {
    [cmdletbinding(SupportsShouldProcess, DefaultParameterSetName = 'pubIP', ConfirmImpact = 'low')]
    param(
        [parameter(Mandatory,
            Position = 0,
            ParameterSetName = 'pubIP',
            HelpMessage = 'Please enter a subscription name')]
        [Alias('sub')]
        [string]$subscription

    )

    begin {
        $getSub = Get-AzContext

        if (-not ($getSub)) {
            Write-Output "Setting subscription to: $getSub"
            Set-AzContext -Subscription $subscription
        }

        else {
            $null
        }
    }

    process {
        try {
            Write-Output 'Collecting VMs that have public IP addresses'

            if ($PSCmdlet.ShouldProcess('Subscription')) {

                Write-Host -ForegroundColor Green 'Printing VMs that have public IPs and NSGs that have a source port range of ANY or a destination port range of ANY'
                $vms = Get-AzPublicIpAddress | Select Name, ResourceGroupName, PublicIpAllocationMethod, IpAddress
                $vms

                $openPorts = Get-AzNetworkSecurityGroup -Name * | Get-AzNetworkSecurityRuleConfig | where { $_SourcePortRange -or $_DestinationAddressPrefix -like "*" } | select Name
                $openPorts
            
            }
        }

        catch {
            Write-Warning 'An error has occurred'
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }

    end { }
}