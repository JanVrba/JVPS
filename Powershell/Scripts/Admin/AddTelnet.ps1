# server 
import-module servermanager 
add-windowsfeature telnet-client

# win 10 workstation

dism /online /Enable-Feature /FeatureName:TelnetClient
