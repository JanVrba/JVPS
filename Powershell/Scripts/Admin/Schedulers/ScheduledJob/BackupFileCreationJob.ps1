# Name : AH.BackupFileCreation.Setup.ps1
# Date : 11/07/2016
# Purpose : Script Set Scheduled job for check of backup file creation.


$file = ".ps1"
$timeSpanInterval =  New-TimeSpan -Minutes 5
$timeSpanDuration = ([TimeSpan]::MaxValue) 
$trigger = New-JobTrigger -RepetitionInterval $timeSpanInterval -Once -At "12:20" -RepetitionDuration $timeSpanDuration

Register-ScheduledJob -FilePath $file -Name "AH.BackupFileCreation" -Trigger $trigger 