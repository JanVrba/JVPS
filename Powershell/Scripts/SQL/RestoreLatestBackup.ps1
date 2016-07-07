# Name : RestoreLatestBackup.ps1
# Date : 06/07/2016
# Purpose : Script will use latest backup and perform restore


Import-Module "SQLPS" -DisableNameChecking
$backupPath = "C:\SQLBackup"
$backupFile = (Get-ChildItem -path $backupPath -Filter "*.bak" | 
    Where-Object {-not $_.PSIsContainer} | 
    Sort-Object -Property $_.creationtime | 
    Select-Object -last 1).Name

$backupFilePath = Join-path $backupPath -ChildPath $backupFile

$restoreToDatabase =  "Apply4law3TEST"
$dbserver = "test-wc\sqlexpress"

$mdf = New-Object Microsoft.SqlServer.Management.Smo.RelocateFile("Apply4law3", "C:\SQLBACKUP\Apply4law3TEST.mdf")
$ldf = New-Object Microsoft.SqlServer.Management.Smo.RelocateFile("Apply4law3_Log", "C:\SQLBACKUP\Apply4law3TEST.Apply4law3TEST_Log.ldf")

Restore-SqlDatabase -Database $restoreToDatabase -BackupFile $backupfilepath -ServerInstance $dbserver -RelocateFile @($mdf,$ldf)