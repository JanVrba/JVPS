# Name : AH.DSCconf.ps1
# Date : 31/05/2016
# Purpose : Create MOF file and start DSC configuration for AH new firm automation workflow


[CmdletBinding(SupportsShouldProcess=$True)]

param(
		[Parameter(Mandatory=$true, HelpMessage="Input name of New Firm")]
        [ValidateNotNullOrEmpty()] 
		[String]
		$FirmName,

        [parameter(Mandatory=$true,HelpMessage="Choose AH Environment: Dev or Live")]
        [ValidateSet('Dev','Live')]
        [String]
		$AH_Environment,

	    [Parameter()]
		[String]
		$ConfigurationDataPath = "$PSScriptRoot\DSC\Environment\AH.Environment.ps1"
) # close param

#region preferences for PS Behavior

$ErrorActionPreference = "Stop"

#endregion preferences for PS Behavior

Write-Information "[AH.DSCconf.ps1] Starting ..."

#region use Environment variables for specified Environment

Switch ($AH_Environment) {

    Dev {

        Write-Information "[AH.DSCconf.ps1] Loading Values for $AH_Environment Environment"
    
        . "$PSScriptRoot\Environment\AH.Environment.Dev.ps1"

    } # close Dev
    
    Live {

        Write-Information "[AH.DSCconf.ps1] Loading Values for $AH_Environment Environment"
    
        . "$PSScriptRoot\Environment\AH.Environment.Live.ps1"

    } # close Live

} # close Switch

#endregion use nodes names from specified Environment

#region load DSC ConfData

# load DSC Configuration Data

$ConfigurationDataPathSplit = split-path $ConfigurationDataPath -Leaf

Write-Information "[AH.DSCconf.ps1] Loading Configuration Data $ConfigurationDataPathSplit"

. "$ConfigurationDataPath"    

#endregion load new DSC ConfData

#region load DSC Configuration File

Write-Information "[AH.DSCconf.ps1] Loading DSC Configuration file"

$ConfigurationFilePath = "$PSScriptRoot\Configuration\AH.Configuration.ps1"

. "$ConfigurationFilePath"

#endregion load DSC Configuration File AHNewFirm

#region load DSC Configuration for LCM


Write-Information "[AH.DSCconf.ps1] Loading DSC Configuration file for LCM"

$ConfigurationLCMPath = "$PSScriptRoot\Configuration\AH.DSC.LCMConf.ps1"

. "$ConfigurationLCMPath"

#endregion load DSC Configuration for LCM

#region Create MOF file

# Create MOF file

Write-Information "[AH.DSCconf.ps1] Creating MOF file(s) ..."

$PSScriptRootParent =  split-path $PSScriptRoot -Parent

$PSScriptRootData = "$PSScriptRootParent\..\Data"

AHNewFirmDSCConf -FirmName $Firmname -ConfigurationData $ConfData -OutputPath "$PSScriptRootData\MOF"

#endregion Create MOF file


#region Create MOF file MetaConfiguration for LCM

Write-Information "[AH.DSCconf.ps1] Creating MOF file(s) for LCM..."


LCMConfig -ConfigurationData $ConfData -OutputPath "$PSScriptRootData\MOF"

#endregion Create MOF file MetaConfiguration for LCM

#region apply DSC configuration for LCM
# apply DSC configuration

Write-Information "[AH.DSCconf.ps1] Applying DSC configuration for LCM ..."

Set-DscLocalConfigurationManager "$PSScriptRootData\MOF" -Verbose -Force

#endregion apply DSC configuration for LCM

#region apply DSC configuration
# apply DSC configuration

Write-Information "[AH.DSCconf.ps1] Applying DSC configuration ..."

Start-DscConfiguration "$PSScriptRootData\MOF" -Wait -Verbose -Force

#endregion apply DSC configuration