# Name : ArchiveNuGetPackagesLast5.ps1
# Date : 30/06/2016
# Purpose : Script Archive Old version of NuGet packages
# JIRA : http://jira1.intranet.gbp.co.uk/browse/DO-32

# environment variables

$sourceFolderPath = "c:\temp"
$archiveFolderPath = "c:\temp\archive"
$countOfLatestPackages = 5

$packagesGroups = Get-ChildItem $sourceFolderPath | 
    Group-Object {($_.Name -replace ("v\d+.\d+\.nupkg" , ""))} | 
    Where-Object {$_.count -gt 5} | Sort-Object Count -Descending |
    Group-Object Name -AsHashTable

$archivedPackages = $packagesGroups.Keys.ForEach({
    $packagesGroups.$_.Group | Sort-Object LastwriteTime  | select -SkipLast 5 |
    Group-Object {($_.Name.Split(".")[0] + $_.Name.Split(".")[1])} 
    }) | sort count -Descending


$remainingPackages = $packagesGroups.Keys.ForEach({

	$packagesGroups.$_.Group | Sort-Object LastwriteTime  | select -Last 5 | 
    Group-Object {($_.Name.Split(".")[0] + $_.Name.Split(".")[1])} 
    }) | sort name

$archivedPackages.group.ForEach({
   $sourceFilePath = $_.FullName
   Move-Item $sourceFilePath -destination $archiveFolderPath -force -ErrorAction:SilentlyContinue
   write-host "Moving file $($_.name)" -ForegroundColor Magenta
 }) 