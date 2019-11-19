using namespace System;

function New-RunBookSchedule {
    param(
        [Parameter(Position = 0, 
            HelpMessage = 'Please enter the Azure Automation account name that will be called')]
        [string]$automationAccountName,

        [Parameter(Position = 1,
            HelpMessage = 'Please enter schedule name')]
        [string]$scheduleName,

        [Parameter(Position = 2,
            HelpMessage = 'Please enter start time. Default is 12:00AM in military time')]
        [string]$startTime = '00:00',
        
        [Parameter(Position = 3,
            HelpMessage = 'Please enter a weekly interval. Default is 1')]
        [int]$weeklyInterval = 1,

        [Parameter(Position = 5,
            HelpMessage = 'Please enter resource group name')]
        [string]$rgName
    )

    $scheduleParams = @{
        'AutomationAccountName' = $automationAccountName
        'Name'                  = $scheduleName
        'StartTime'             = $startTime
        'WeekInterval'          = $weeklyInterval
        'DaysOfWeek'            = [System.DayOfWeek]::Tuesday
        'ResourceGroupName'     = $rgName
    }

    try {
        New-AzAutomationSchedule @scheduleParams
    }

    catch {
        Write-Warning 'An error has occurred'
        $PSCmdlet.ThrowTerminatingError($_)
    }
}