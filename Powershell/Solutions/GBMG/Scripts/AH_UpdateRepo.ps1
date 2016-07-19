# AH_UpdateRepo.ps1
# Date : 07/06/2016
# Purpose : Script DeployA AHNF  from Repo to Test server

cls
$today = (Get-Date).ToString('hhmmddMMyyyy')
$sourceBck = "C:\websites\www.allhires.com\AHNewFirm\Code"
$dstBack = "C:\websites\www.allhires.com\AHNewFirm\#backup\AH_$today.zip"

if (Test-Path $sourceBck) {
    
    Add-Type -assembly "system.io.compression.filesystem"
    [io.compression.zipfile]::CreateFromDirectory($SourceBck, $dstBack)
    Remove-Item "$sourceBck\*" -Recurse -Force
}



$source = "\\tsclient\C\Users\jvrba\Source\Repos\AHnewFirm_WorkflowAutomation\AH_NewFirm_WorkflowAutomation\*"  
$dest = "C:\websites\www.allhires.com\AHNewFirm\Code"

cp $source $dest -Recurse -Force



$RunScript = "$dest\AH.NewFirm.Run.ps1"

ii (C:\Users\jvrba\Desktop\PowerShell_ISE.lnk -file $RunScript) -ErrorAction SilentlyContinue