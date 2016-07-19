#
# AH.DSC.LCMConf.ps1
# Configuration for DSC Local Configuration Manager

[DSCLocalConfigurationManager()]
configuration LCMConfig
{
    $allnodes.nodeName.foreach({
        Node $_{

            Settings{

                ConfigurationMode = 'ApplyOnly'

            } # close settings
        } # close node 
    }) # close foreach
} # close Configuration