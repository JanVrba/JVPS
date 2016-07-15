# Name : RestoreFullRecoveryCheck.ps1
# Date : 07/07/2016
# Purpose : Script Restore last Full backup, diff + log backups to TEST SQL server and CheckDB
# Inspired by : https://www.simple-talk.com/sql/backup-and-recovery/backup-and-restore-sql-server-with-the-sql-server-2012-powershell-cmdlets/

Import-Module "SQLPS" -DisableNameChecking

# set Environment variables

$backupPath = ""
$database = ""
$sqlserver = ""
$backupPathFull = Join-Path $backupPath -ChildPath $database
$relocationPath = ""

# get backup files

$backupFileFull = (Get-ChildItem -path $backupPathFull -Filter "*.bak" | 
    Where-Object {-not $_.PSIsContainer} | 
    Sort-Object LastWriteTime | 
    Select-Object -last 1).Name

$backupfileDiff = (Get-ChildItem -path $backupPathFull -Filter "*.diff" | 
    Where-Object {-not $_.PSIsContainer} | 
    Sort-Object LastWriteTime | 
    Select-Object -last 1).Name

$backupfileDiffLastWriteTime = (Get-ChildItem -path $backupPathFull -Filter "*.diff" | 
    Where-Object {-not $_.PSIsContainer} | 
    Sort-Object LastWriteTime | 
    Select-Object -last 1).LastWriteTime

# get array of *.trn files
$backupfileLog = Get-ChildItem -path $backupPathFull -Filter "*.trn" | 
    Where-Object {-not $_.PSIsContainer} | 
    Where-Object {$_.LastWriteTime -gt $backupfileDiffLastWriteTime} |
    Sort-Object LastWriteTime
   
# full paths to backup files

$backupFileFullPath = Join-path $backupPathFull -ChildPath $backupFileFull
$backupFileDiffPath = Join-path $backupPathFull -ChildPath $backupFileDiff

# restore to time of last TranLog file

$restorePointTime = ($backupfileLog | select -last 1).LastWriteTime

# relocate files 

$mdfFilePath = Join-Path $relocationPath -ChildPath "$database.mdf"
$ldfFilePath = Join-Path $relocationPath -ChildPath "$database`_log.ldf"
 
$mdf = New-Object Microsoft.SqlServer.Management.Smo.RelocateFile($database, $mdfFilePath)
$ldf = New-Object Microsoft.SqlServer.Management.Smo.RelocateFile("$database`_log" , $ldfFilePath)

# Restore Last Full Backup

Restore-SqlDatabase -Database $database  -BackupFile $backupfileFullpath -ServerInstance $sqlserver -ReplaceDatabase -RelocateFile($mdf,$ldf) -NoRecovery -Verbose

# Restore Last Diff Backup

Restore-SqlDatabase -Database $database -BackupFile $backupfileDiffpath -ServerInstance $sqlserver -ReplaceDatabase -NoRecovery -Verbose

# Restore Transaction Log Backups

$recovery = 0
foreach ($file in $backupfileLog) {
    $backupFileLogPath = Join-path $backupPathFull -ChildPath $file.Name
    if ($file.LastWriteTime -lt $restorePointTime) {
            Restore-SqlDatabase -Database $database -BackupFile $backupFileLogPath -ServerInstance $sqlserver -ReplaceDatabase -NoRecovery -Verbose
    } else {
       if ($recovery -eq 0) {
            Restore-SqlDatabase -Database $database -BackupFile $backupFileLogPath -ServerInstance $sqlserver -ReplaceDatabase -ToPointInTime $restorePointTime -Verbose
            $recovery = 1       
       } # close if Recovery
    } # close if NoRecovery
} # close foreach

# DB CHECK
# Invoke-sqlcmd -ServerInstance $sqlserver -Query "DBCC CHECKDB ($database);" -Verbose #>
