function Test-GmsaExist {

# Name : Test-GMSAExists.ps1
# Date : 05/07/2016
# Purpose : Function test if GMSA account exists
    [CmdletBinding()]
    param (
           [Parameter()]
           $GMSA
    ) # close param

Try {
    Get-ADServiceAccount $GMSA -ErrorAction SilentlyContinue | Out-Null
    return $true
} # close try
Catch {
    return $false
} # close catch

} # close function