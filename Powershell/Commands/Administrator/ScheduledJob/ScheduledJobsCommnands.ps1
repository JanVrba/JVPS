# source : https://blogs.technet.microsoft.com/heyscriptingguy/2014/05/12/introduction-to-powershell-scheduled-jobs/

#  list of commands

Get-Command -Module PSScheduledJob | sort verb

# new trigger

$trigger = New-JobTrigger -Once -At 13:45

# register job (run as administrator)

Register-ScheduledJob -Name GPS -Trigger $trigger -ScriptBlock {GPS}

# get job definition 

Get-ScheduledJob -Id 1

# get job options

Get-ScheduledJobOption -Id 1

# get job trigger

Get-ScheduledJob -Id 1 | Get-JobTrigger

# if job running - get job result

get-job -Id 2 | Receive-Job -Id 2 -Keep 

# delete scheduled job

Get-ScheduledJob | Unregister-ScheduledJob
