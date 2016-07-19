# AH.NewFirm.Run.ps1
# Date : 07/06/2016
# Purpose : Script execute AHNewFirm automation workflow

[CmdletBinding(SupportsShouldProcess=$True)]

# script will stop at first error

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

# need to run this script as an administrative user - 
# source http://blogs.technet.com/b/heyscriptingguy/archive/2011/05/11/check-for-admin-credentials-in-a-powershell-script.aspx 
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Warning "You do not have Administrator rights to run this script. Please re-run this script as an Administrator"
    Break
} # close If

Import-Module "$PSScriptRoot\Module\AHModule.psm1" -DisableNameChecking

# run AHNewFirm automation using DSC - 
# steps 1 - Create Folders, 
#       3.1. - Create IIS application pools
#       3.2. - Create web applications

. $PSScriptRoot\DSC\AH.DSCconf.ps1 

# run AHNewFirm automation using Scripts
# steps 2 - Create gMSA and add it to Application pool

. $PSScriptRoot\Scripts\CreateGMSA.ps1 -Firmname $Firmname 

# 4 - Copy Config

# . c:\websites\Scripts\Copy-Config.ps1 -Verbose 

# 5 - Run SQL scripts(logins,schemas)

 . $PSScriptRoot\Scripts\RunSQLScripts.ps1 -Firmname $Firmname -NewGMSA $NewGMSA  

 # 6.1 - Clone Project - Octopus Deploy

 . $PSScriptRoot\Scripts\CloneOctopusProject.ps1 -Firmname $Firmname

 # 6.2 - Change Variables - Octopus Deploy

 . $PSScriptRoot\Scripts\ChangeOctopusProjectVariables.ps1 -Firmname $Firmname

 # 8. Add New Firm to Jenkins - manual step

 Start-Process "http://jenkins-ci.intranet.gbp.co.uk/job/AllHires%20Graduate%20Octopus%20Deploy%20to%20Test/configure#"
