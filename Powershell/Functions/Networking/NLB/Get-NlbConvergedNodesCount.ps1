# Name : Get-NlbConvergedNodesCount
# Purpose : Function check number of converged nodes by provided Interface name

Function Get-NlbConvergedNodesCount {

[CmdletBinding()]
 param (        
           
           [Parameter()]
           [String]
           $InterfaceName ,

           [Parameter()]
           [String]
           $HostName  
                        
    ) # close param
$count = 0
$nlbClusterNodes = (Get-NlbClusterNode -InterfaceName $InterfaceName -Hostname $HostName ).Name
$nlbClusterNodes.foreach({
    $nodeStatus = (Get-NlbNodeStatusCode -ComputerName $_).ToString()
    If ($nodeStatus.Equals("Default") -or $nodeStatus.Equals("Converged")) {
        $count++
	} # close If
}) # close foreach

$count
} # close function Get-NlbConvergedNodesCount