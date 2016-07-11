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

If (test-path $backupFolderPath\*.trn ) {
    $now = Get-Date
    
    $lastBackupFileCreationTime = (get-childitem -Path $backupFolderPath -filter "*.trn" | 
        Where-Object {-not $_.PSIsContainer} |    
        Sort-Object Creationtime | select -Last 1).CreationTime

    $timeDiff = (New-Timespan $lastBackupFileCreationTime $now).TotalSeconds

    If ($timeDiff -gt $timespanSecs) { 
        return $false
    } # close if TimeDiff
		
    return $true

} else {
    Write-Error " No Backup *.trn file at $backupFolderPath exists!!!"

} # close If Test-path
} # close function