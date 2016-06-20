# Name : Get-NlbNodeStatusCode
# Purpose : Function check and return NLB Node Status Code like Default, Stopped etc.

Function Get-NlbNodeStatusCode {

[CmdletBinding()]
    param (        
              
           [Parameter()]
           [String]
           $ComputerName            
                   
    ) # close param

(Get-NlbClusterNode -Hostname $ComputerName -NodeName $ComputerName).State.NodeStatusCode

} # close function