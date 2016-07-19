# Name : AH.Configuration.ps1
# Date : 31/05/2016
# Purpose : PS DSC configuration file which automate AH new firm worklow

[CmdletBinding(SupportsShouldProcess=$True)]

Configuration AHNewFirmDSCConf {

param(
		[Parameter(Mandatory=$true, 
		Position=0)]
		[String]
		$FirmName

) # close param

    #region Import DSC Resources

    Write-Verbose "[AHNewFirmDSCConfiguration.ps1] Importing DSC resources"

    Import-DscResource –ModuleName 'PSDesiredStateConfiguration'
    Import-DscResource -ModuleName 'xWebAdministration'

    #endregion Import DSC Resources    

    #region DSC Configuration

    # use values from ConfData hashtable

    Node $allnodes.nodeName {
        
        #region 3.1 Create IIS application pools

        $NodeEnvPool = ($node.AppPool).ToString()
        $NewAppPool = "$NodeEnvPool-$FirmName"

        xWebAppPool "$NewAppPool" {

                Name = "$NewAppPool"
                Ensure = 'Present'
                identityType = 'SpecificUser'
				managedRuntimeVersion = 'v4.0'

        } # close resource xWebAppPool   
            
        #endregion 3.1 Create IIS application pools (..assign gMSA..not implemented yet) 
       
        # Keys are names of Environments - GradTest, GradLive, ExpTest,ExpLive
        # Start - ForEach loop , create folders and webapp at each environment

        $node.environment.Keys.foreach({ 

            #region 1. Create Folders

            $NodeEnvRoot = ($node.environment.$_.rootfolder).ToString()
            $NewFolder = join-path $NodeEnvRoot -ChildPath $FirmName           
            
            File "$NewFolder" {

                Type = 'Directory'  
                DestinationPath = "$NewFolder"
                Ensure = 'Present' 

            } # close File resource 

            #endregion 1. Create Folders

            #region 3.2 Create IIS web applications 
           
            $NodeEnvWebsite = ($node.environment.$_.website).ToString()
            $NewWebApp = "$NodeEnvWebsite/$FirmName"
                    
            xWebApplication $NewWebApp {

                Name = "$Firmname"
                Website = "$NodeEnvWebsite"
                WebAppPool = "$NewAppPool"
                PhysicalPath = "$NewFolder"           

            } # close resource xWebApplication 

            #endregion 3.2 Create IIS web applications  
                   
        }) # close $node.environment foreach loop  

    }# close $Node

    #endregion DSC Configuration

}# close Configuration