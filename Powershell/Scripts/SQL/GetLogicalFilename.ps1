$srvObject = new-object ('Microsoft.SqlServer.Management.Smo.Server') $sqlserver
$restoreObject = new-object('Microsoft.SqlServer.Management.Smo.Restore')
$backupDevice = new-object ('Microsoft.SqlServer.Management.Smo.BackupDeviceItem') ($backupFileFullPath, 'File')
$restoreObject.Devices.Add($backupDevice)
$logicalNames = ($restoreObject.ReadFileList($srvObject).logicalname)
$databaseDataFile = $logicalNames[0]
$databaseLogFile = $logicalNames[1]
 
$mdf = New-Object Microsoft.SqlServer.Management.Smo.RelocateFile($databaseDataFile, $mdfFilePath) 
$ldf = New-Object Microsoft.SqlServer.Management.Smo.RelocateFile($databaseLogFile , $ldfFilePath) 