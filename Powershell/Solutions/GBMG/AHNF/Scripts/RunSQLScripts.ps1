# Name : RunSQLScripts.ps1
# Date : 17/05/2016
# Purpose : Script prepare SQL scripts for creating of logins and schemas and execute them

[CmdletBinding()]
param(
		[Parameter()]
        [ValidateNotNullOrEmpty()] 
		[String]
		$FirmName,

		[Parameter()]
        [ValidateNotNullOrEmpty()] 
		[String]
		$NewGMSA
	)


# ---------------------------------------------

# Variables used from AH.Environment.[Env] data
# 
# $SQLDomain
# $SQLserver
# $DBMaster
#
# ---------------------------------------------

Write-Information "[RunSQLScripts.ps1] Starting ..."

# Import module needed for manage SQL server
# path to SQL modules folder have to be added to PSModulePath
# --> $env:PsModulepath=$env:PsModulepath +";" + "C:\Program Files (x86)\Microsoft SQL Server\120\Tools\PowerShell\Modules"

Import-Module "sqlps" -DisableNameChecking -Verbose:$false

#region Create new files from templates

If (-not (Test-Path "$PSScriptRootData\SQL")) {
	md $PSScriptRootData\SQL | Out-Null
} # close if

$SQLFirmDev = ("$PSScriptRootData\SQL\NewDev_{0}.sql" -f ($Firmname))
$SQLFirmLive = ("$PSScriptRootData\SQL\NewLive_{0}.sql" -f ($Firmname))

Copy-Item $PSScriptRootParent\SQL\Templates\NewDev.sql $SQLFirmDev -Force
Copy-Item $PSScriptRootParent\SQL\Templates\NewLive.sql $SQLFirmLive -Force

#endregion Create new files from templates

#region Change Values with Firmname 

# only Name of script will be used
$SQLFirmDevSplit = split-path $SQLFirmDev -Leaf

Write-Information "[DEV SQL] Changing Username values at $SQLFirmDevSplit ..." 

(get-content $SQLFirmDev ) -creplace '\[USERNAME\]', $Firmname | set-content $SQLFirmDev

# only Name of script will be used
$SQLFirmLiveSplit = split-path $SQLFirmLive -Leaf

Write-Information "[LIVE/TEST SQL] : Changing Username values at $SQLFirmLiveSplit ..."

(get-content $SQLFirmLive) -creplace 'GBP',  $SQLDomain | set-content $SQLFirmLive
(get-content $SQLFirmLive) -creplace 'ISUR_A4L_USERNAME', $NewGMSA | set-content $SQLFirmLive
(get-content $SQLFirmLive) -creplace '\[USERNAME\]', $Firmname | set-content $SQLFirmLive

#endregion Change Values with Firmname 

#region 5. Run SQL scripts(logins,schemas)  - Run SQL scripts


Write-Information "[$SQLserverDev] Executing script $SQLFirmDevSplit ..." 
Invoke-Sqlcmd -inputfile $SQLFirmDev  -serverinstance $SQLserverDev -database $DBMaster -Verbose

Write-Information "[$SQLserverLive] : Executing script $SQLFirmLiveSplit ..." 
Invoke-Sqlcmd -inputfile $SQLFirmLive  -serverinstance $SQLserverLive -database $DBMaster -Verbose

cd $HOME

#endregion 5. Run SQL scripts(logins,schemas)  - Run SQL scripts
