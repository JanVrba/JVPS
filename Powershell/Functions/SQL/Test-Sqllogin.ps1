# Name :Test_SQLLogin.ps1
# Author : Ravikanth C, PowerShell Magazine
# Source : http://www.powershellmagazine.com/2013/08/14/pstip-validate-if-a-sql-login-exists-using-powershell/

Function Test-SQLLogin {
    
    param (
        [string]$SqlLogin
    )
    Add-Type -AssemblyName "Microsoft.SqlServer.Smo, Version=10.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91"
    $smo = New-Object Microsoft.SqlServer.Management.Smo.Server $env:ComputerName\SQLEXPRESS
    if (($smo.logins).Name -contains $SqlLogin) {
       $true
    } else {
       $false
    }
} # close function