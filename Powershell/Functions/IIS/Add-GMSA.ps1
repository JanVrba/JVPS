# Name : Add-GMSA.ps1
# Date : 02/06/2016
# Purpose : Function add GMSA to IIS AppPool

function Add-GMSA {

    [CmdletBinding()]
    param (
           [Parameter()]
           [String]
           $AppPool ,
           [Parameter()]
           $GMSA
    ) # close param

$AppPoolModify = Get-Item IIS:\AppPools\$AppPool
$AppPoolModify.processModel.username = $GMSA
$AppPoolModify | Set-Item
$AppPoolModify.Stop()
$AppPoolModify.Start()
return $AppPoolModify.processModel.username
} # close function