# Name : Set-Credential
# Date : 20/06/2016
# Purpose : Function creates Cred object which includes username and password

function Set-Credential {

    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidateNotNullOrEmpty()] 
		[String]
        $Username, 	

        [Parameter()]
        [ValidateNotNullOrEmpty()] 
		[String]
		$Password

    ) # close param
    
$pass = ConvertTo-SecureString -AsPlainText $Password -Force
$Cred = New-Object System.Management.Automation.PSCredential -ArgumentList $Username,$pass
$Cred

} # close Function