# Name : ArchiveNuGetPackages.ps1
# Date : 30/06/2016
# Purpose : Script Archive Old version of NuGet packages

$source = "\\cc1\Bin\GBP\NuGet\master"
$archivePath = "\\cc1\archive"
$retentionTime = (get-date).AddDays(-31)

Get-Childitem -Path $source | 
    Where-Object {$_.LastWriteTime -lt $retentionTime} |
        ForEach {
            Move-Item $_.FullName -destination $archivePath -force -ErrorAction:SilentlyContinue
        } # close ForEach