function Get-PublicAZInstances {
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact = 'low')]
    param(
        [Parameter(Mandatory = $true, 
            position = 0,
            HelpMessage = 'Please enter the VM name that you wish to search for')]
        [ValidateNotnullOrEmpty()]
        [string]$myvm
    )

    begin {
        $VMArray = @()
        $NewVMList = $myvm += $VMArray
    }

    process {
        $PublicIP = Get-AzPublicIpAddress | where-object {$_.Name -like "*$NewVMList*"}
        $PublicIPOBJECT = [pscustomobject] @{
            'IP' = $PublicIP.IpAddress
        }
        Write-Host "Please copy the IP address below" -ForegroundColor Green
        $PublicIPOBJECT | Out-String
        Pause
        
        $TheIP = Read-Host "Please enter the IP"
        Write-Output "Starting network testing on your public IP address"
        Write-Output "Starting ICMP test"
        $testPing = Test-Connection $TheIP

        if (-not ($testPing.StatusCode)) {
            Write-Host -ForegroundColor Red "No connection to: $TheIP"
        }

        Write-Output "Starting Telnet test"
        $telnetPort = Read-Host "Please enter telnet port"
        $testTelnet = New-Object System.Net.Sockets.TcpClient($TheIP, $telnetPort) | Out-String
        $testTelnet
        if ($testTelnet.Connected -like 'False') {
            Write-Host -ForegroundColor Orange 'No Telnet is available on that port'
        }

        else {
            Write-Host -ForegroundColor Green 'Telnet: Successful'}

        Write-Output "Starting Curl Test"
        $curlTest = Invoke-WebRequest -Uri $TheIP
        $curlTestOBJECT = [pscustomobject] @{
            'StatusCode'=$curlTest.StatusCode
        }

    }#Process
    end {}
}#Function