# Name : AH.BackupFileCreation.Setup.ps1
# Date : 11/07/2016
# Purpose : Script Set Scheduled task for check of backup file creation.


$taskAction = [ordered]@{

    Execute = "Powershell.exe"
    Argument =   '-NoProfile -WindowStyle Hidden -File "{[ps1 file path]}"'   
  
} # close taskAction

$action = New-ScheduledTaskAction @taskAction
$timeSpanInterval =  New-TimeSpan -Minutes 5
$timeSpanDuration = ([TimeSpan]::MaxValue) 
$trigger = New-ScheduledTaskTrigger -RepetitionInterval $timeSpanInterval -Once -At "00:00" -RepetitionDuration $timeSpanDuration
$principal = New-ScheduledTaskPrincipal -UserID gbp\gAHBackup$ -LogonType Password

Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "AH.BackupFileCreationCheck" -Description "Task check every 5 minutes if Transaction log file was created, latest 150 seconds ago and sent email if not" -Principal $principal