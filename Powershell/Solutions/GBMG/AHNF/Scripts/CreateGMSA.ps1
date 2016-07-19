# Name : CreateGMSA.ps1
# Date : 31/05/2016
# Purpose :  Script creates GMSA and Add Account to AppPool
# Version : 0.0.1

[CmdletBinding(SupportsShouldProcess=$True)]

param(
		[Parameter()]
        [ValidateNotNullOrEmpty()] 
		[String]
		$FirmName
)

# Functions used from Module AHNewFirm.psm1
#
# New-GMSA
# Add-GMSA
#
# ---------------------------------------------
# Variables used from AH.Environment.[Env] data
# 
# $gmsaPrefix
# $DNS
# $ADSecurityGroup
# $ADusersGroup
# $AppPool
#
# ---------------------------------------------


Write-Information "[CreateGMSA.ps1] Starting ..."

#region check Firname Length
$gmsaMax = 14 - ($gmsaPrefix.Length)

If ($Firmname.Length -gt $gmsaMax) {

    Write-Warning "Name $Firmname is too long for gMSA account which is limited to 15 characters!`
    `nUse Maximum $gmsaMAx characters long abbreviation (prefix $gMSAPrefix will be added to name)"

    Do {
        $FirmOK = $True
        $FirmnameGmsa = Read-Host -Prompt "Enter new Firmname(abbreviation)"            
        If ($FirmnameGmsa.Length -gt $gmsaMax) {            
            Write-Warning "Use Maximum $gmsaMAx characters long abbreviation"
            $FirmOK = $false
        } # close if
        
    } until ($FirmOK)

} else { 
    $FirmnameGmsa = $Firmname 
} # close else

#endregion check Firname Length

if(-not (Get-WindowsFeature -Name RSAT-AD-Powershell).Installed) {
	Add-WindowsFeature RSAT-AD-PowerShell
} 

#region New GMSA



Write-Information "Creating gMSA...at $DNS domain"

$NewGMSA = New-GMSA -FirmName $FirmnameGmsa -gMSA_Prefix $gMSAPrefix -Domain $DNS -ADSecurityGroup $ADSecurityGroup -ErrorAction SilentlyContinue

Write-Information "Adding account $NewGMSA to group $ADusersGroup"

Add-ADGroupMember -identity $ADusersGroup -members $NewGMSA

Write-Information "[$ManagementHost] Installing $NewGMSA to $ManagementHost"

Install-AdServiceAccount $NewGMSA -Verbose

If (Test-AdServiceaccount $NewGMSA) {
			Write-Information "[$ManagementHost] Account $NewGMSA installed to server $ManagementHost"
		} # close if test

#endregion New GMSA

#region Add GMSA to AppPool

$NewAppPool = $AppPool + "-$Firmname"
$credential = (Get-Credential "$env:USERDOMAIN\$env:USERNAME")

$AddedGmsa = Add-GMSA -AppPool $NewAppPool -GMSA $NewGMSA -Domain $SQLDomain 

Write-Information "[$ManagementHost] Service account $AddedGmsa added to AppPool $NewAppPool"

$servers.nodename.foreach({
	If(-not ($_ -eq $ManagementHost)) {
		$serverFQDN = "$_" + "." + "$DNS"
		$server = $_
		$session = New-PSSession -ComputerName $serverFQDN -Credential $credential -Authentication Credssp

		Invoke-Command -Session $session -ArgumentList $NewAppPool,$NewGMSA,$ManagementHost,$server,$SQLDomain { 
		       
			param($NewAppPool,$NewGMSA,$ManagementHost,$server,$SQLDomain)  

	        $ErrorActionPreference = "Stop"
	          
            Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
			Unblock-file  "\\$ManagementHost\websites\www.allhires.com\AHNewFirm\Code\Module\AHModule.psm1" 
			Import-Module "\\$ManagementHost\websites\www.allhires.com\AHNewFirm\Code\Module\AHModule.psm1" -DisableNameChecking
			if(-not (Get-WindowsFeature -Name RSAT-AD-Powershell).Installed) {
				Add-WindowsFeature RSAT-AD-PowerShell
			} # close if windows feature

			Write-Information "[$server] Installing $NewGMSA to server $server ..."

			Install-AdServiceaccount $NewGMSA -Verbose

			If (Test-AdServiceaccount $NewGMSA) {
				Write-Information "[$server] Account $NewGMSA installed to server $server"
			} # close if test

			$AddedGmsa = Add-GMSA -AppPool $NewAppPool -GMSA $NewGMSA -Domain $SQLDomain        
			Write-Information "[$server] Service account $AddedGmsa added to AppPool $NewAppPool"

		} # close script block Invoke Commnand
	} # close If

}) # close foreach

#endregion Add GMSA to AppPool