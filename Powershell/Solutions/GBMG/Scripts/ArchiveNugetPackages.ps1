# Name : ArchiveNuGetPackages.ps1
# Date : 30/06/2016
# Purpose : Script Archive Old version of NuGet packages

# environment variables

$sourceFolderPath = "\\cc1\Bin\GBP\NuGet\master"
$archiveFolderPath = "\\cc1\archive"
$retentionTimeDays = 31

Function Backup-NuGetPackageToArchive {
    [CmdletBinding()]

    param (
    [Parameter()]
    [string]$sourceFolderPath,
     
    [Parameter()]
    [string]$archiveFolderPath,

    [Parameter()]
    [int]$retentionTimeDays
    ) # close param

$retentionTime = (get-date).AddDays(-$retentionTimeDays)

Get-Childitem -Path $sourceFolderPath | 
    Where-Object {$_.LastWriteTime -lt $retentionTime} |
        ForEach {
            Move-Item $_.FullName -destination $archiveFolderPath -force -ErrorAction:SilentlyContinue
        } # close ForEach

} # close Function

Backup-NuGetPackageToArchive -sourceFolderPath $sourceFolderPath -archiveFolderPath $archiveFolderPath -retentionTimeDays $retentionTimeDays