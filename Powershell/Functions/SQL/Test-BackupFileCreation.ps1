# Name : Test-BackupFileCreation.ps1
# Date : 02/06/2016
# Purpose : Function add GMSA to IIS AppPool

function Test-BackupFileCreation {

[CmdletBinding()]
param (
       [Parameter()]
       [String]
       $backupFolderPath ,

       [Parameter()]
       [String]
       $timespanSecs

) # close param

$now = Get-Date

$lastBackupFileCreationTime = (get-childitem -Path $backupFolderPath -filter "*.trn" | 
    Where-Object {-not $_.PSIsContainer} |    
    Sort-Object -Property $_.creationtime | select -Last 1).CreationTime

$timeDiff = (New-Timespan $lastBackupFileCreationTime $now).TotalSeconds

If ($timeDiff -gt $timespanSecs) { 
    return $false}

return $true

} # close function