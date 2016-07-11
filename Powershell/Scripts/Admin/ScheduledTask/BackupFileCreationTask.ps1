# Name : AH.BackupFileCreation.Setup.ps1
# Date : 11/07/2016
# Purpose : Script Set Scheduled task for check of backup file creation.


$taskAction = [ordered]@{

    Execute = "Powershell.exe"
    Argument =   '-NoProfile -WindowStyle Hidden -File "C:\websites\www.allhires.com\AHBackup\AH.BackupFileCreationCheck.ps1"'   
  
} # close taskAction

$action = New-ScheduledTaskAction @taskAction
$timeSpanInterval =  New-TimeSpan -Minutes 5
$timeSpanDuration = ([TimeSpan]::MaxValue) 
$trigger = New-ScheduledTaskTrigger -RepetitionInterval $timeSpan -Once -At "00:00" -RepetitionDuration $timeSpanDuration

Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "AH.BackupFileCreationCheck" -Description "Task check every 5 minutes if Transaction log file was created, latest 150 seconds ago and sent email if not"
