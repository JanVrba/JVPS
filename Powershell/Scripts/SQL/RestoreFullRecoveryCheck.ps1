# Name : RestoreFullRecoveryCheck.ps1
# Date : 07/07/2016
# Purpose : Script Restore last Full backup, diff + log backups to TEST SQL server and CheckDB
# Inspired by : https://www.simple-talk.com/sql/backup-and-recovery/backup-and-restore-sql-server-with-the-sql-server-2012-powershell-cmdlets/

Import-Module "SQLPS" -DisableNameChecking

# set Environment variables

$backupPath = "C:\websites\www.allhires.com\Backup"
$database = "Apply4law3"
$sqlserver = "test-wc\sqlexpress"

# get backup files

$backupFileFull = (Get-ChildItem -path $backupPath -Filter "*.bak" | 
    Where-Object {-not $_.PSIsContainer} | 
    Sort-Object LastWriteTime | 
    Select-Object -last 1).Name

$backupfileDiff = (Get-ChildItem -path $backupPath -Filter "*.diff" | 
    Where-Object {-not $_.PSIsContainer} | 
    Sort-Object LastWriteTime | 
    Select-Object -last 1).Name

$backupfileDiffLastWriteTime = (Get-ChildItem -path $backupPath -Filter "*.diff" | 
    Where-Object {-not $_.PSIsContainer} | 
    Sort-Object LastWriteTime | 
    Select-Object -last 1).LastWriteTime

# get array of *.trn files
$backupfileLog = Get-ChildItem -path $backupPath -Filter "*.trn" | 
    Where-Object {-not $_.PSIsContainer} | 
    Where-Object {$_.LastWriteTime -gt $backupfileDiffLastWriteTime} |
    Sort-Object LastWriteTime
   
# full paths to backup files

$backupFileFullPath = Join-path $backupPath -ChildPath $backupFileFull
$backupFileDiffPath = Join-path $backupPath -ChildPath $backupFileDiff

# restore to time of last TranLog file

$restorePointTime = ($backupfileLog | select -last 1).LastWriteTime

# Restore Last Full Backup

Restore-SqlDatabase -Database $database  -BackupFile $backupfileFullpath -ServerInstance $sqlserver -ReplaceDatabase -NoRecovery

# Restore Last Diff Backup

Restore-SqlDatabase -Database $database -BackupFile $backupfileDiffpath -ServerInstance $sqlserver -ReplaceDatabase -NoRecovery

# Restore Transaction Log Backups

$recovery = 0
foreach ($file in $backupfileLog) {
    $backupFileLogPath = Join-path $backupPath -ChildPath $file.Name
    if ($file.LastWriteTime -lt $restorePointTime) {
            Restore-SqlDatabase -Database $database -BackupFile $backupFileLogPath -ServerInstance $sqlserver -ReplaceDatabase -NoRecovery
    } else {
       if ($recovery -eq 0) {
            Restore-SqlDatabase -Database $database -BackupFile $backupFileLogPath -ServerInstance $sqlserver -ReplaceDatabase -ToPointInTime $restorePointTime
            $recovery = 1       
       } # close if Recovery
    } # close if NoRecovery
} # close foreach

# DB CHECK
# Invoke-sqlcmd -ServerInstance $sqlserver -Query "DBCC CHECKDB ($database);" -Verbose


