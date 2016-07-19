# Name : AHNewFirm.psm1
# Date : 07/06/2016
# Purpose : Module with functions for AH new firm workflow

#region Import Needed PS Modules

Add-PSSnapin WebAdministration -ErrorAction SilentlyContinue
Import-Module WebAdministration -ErrorAction SilentlyContinue 

#endregion Import Needed PS Modules
#region AH Functions
function New-GMSA {

# Name : New-GMSA
# Date : 02/06/2016
# Purpose : Function creates new group management service account at AD and return SAM account name

    [CmdletBinding()]
    param(
		[Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()] 
		[String]
		$FirmName,

		[Parameter(Mandatory=$true)]
		[String]
		$gMSA_Prefix,

		[Parameter(Mandatory=$true)]
		[String]
		$Domain,

		[Parameter(Mandatory=$true)]
		[String]
		$ADSecurityGroup
	)

	$gMSA = ($gMSA_Prefix + '_' + $FirmName)
	$gMSAFQDN = $gMSA + '.' + $Domain

If (-not (Test-GmsaExist $gMSA)) {
    New-ADServiceAccount -Name $gMSA -DNSHostName $gMSAFQDN -PrincipalsAllowedToRetrieveManagedPassword $ADSecurityGroup
}
$NewGMSA = (Get-ADServiceAccount -Identity $gMSA).SamAccountName
return $NewGMSA

} # close function

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

function Add-GMSA {
# Name : Add-GMSA.ps1
# Date : 02/06/2016
# Purpose : Function add GMSA to IIS AppPool
    [CmdletBinding()]
    param (
           [Parameter()]
           [String]
           $AppPool ,
           [Parameter()]
           $GMSA ,
		   [Parameter()]
           $Domain
    ) # close param

$DomainGMSA = $Domain + "\" + $GMSA
$AppPoolModify = Get-Item IIS:\AppPools\$AppPool

if (-not($AppPoolModify.processModel.username -eq $DomainGMSA))
{
    $AppPoolModify.processModel.username = $DomainGMSA
    $AppPoolModify | Set-Item

    If ($AppPoolModify.state -eq "Started")
    {
        $AppPoolModify.Stop()
		Sleep -Seconds 5
    }
}

If ($AppPoolModify.state -eq "Stopped")
{
    $AppPoolModify.Start()
}

return $AppPoolModify.processModel.username
} # close function

Function Test-OctopusProjectExists{
[CmdletBinding()]
# Name : Test-OctopusProjectExists.ps1
# Date : 12/07/2016
# Purpose : Function using RESTAPI and Method GET of to test if Octopus project already exists
Param(  

    [Parameter()]
    [string]$OctopusUrl,

    [Parameter()]
    [string]$ApiKey,

	 [Parameter()]
    [string]$projectSlug
    )

$uri = "$OctopusUrl" + "/api/projects" + "/$projectSlug" + "`?apiKey=$ApiKey"

Try { 
    Invoke-RestMethod -Uri $uri -Method Get | out-null 
    return $true
} # close Try
Catch { 
    return $false 
} # close Catch
    
} # close function

Function Edit-OctopusProjectVariable{
# Name : Edit-OctopusProjectVariable.ps1
# Date : 13/07/2016
# Purpose : Function change value of Octopus project varible using Octopus Client .NET
# Inspired by : https://github.com/OctopusDeploy/OctopusDeploy-Api/blob/master/Octopus.Client/PowerShell/Variables/UpdateVariableInProject.ps1

[CmdletBinding()]
Param(
    [Parameter()]
    [string]$octopusURL,
     
    [Parameter()]
    [string]$octopusAPIKey,

    [Parameter()]
    [string]$projectName,

    [Parameter(ParameterSetName=’varName’)]
    [string]$varName,

    [Parameter(ParameterSetName=’varID’)]
    [string]$varID,
  
    [Parameter()]
    [string]$newValue

    )


# if is called  from Octopus server

Add-Type -Path "C:\Program Files\Octopus Deploy\Octopus\Newtonsoft.Json.dll"
Add-Type -Path "C:\Program Files\Octopus Deploy\Octopus\Octopus.Client.dll" 

<#  or if from Tentacle
Add-Type -Path "C:\Program Files\Octopus Deploy\Tentacle\Newtonsoft.Json.dll"
Add-Type -Path "C:\Program Files\Octopus Deploy\Tentacle\Octopus.Client.dll"
 #>

$endpoint = new-object Octopus.Client.OctopusServerEndpoint ($octopusURL, $octopusAPIKey)
$octoRepo = new-object Octopus.Client.OctopusRepository $endpoint

#Get Project
$project = $octoRepo.Projects.FindByName($projectName)

#Get Project's variable set
$variableSet = $octoRepo.VariableSets.Get($project.links.variables)

#Get variable to update 
Switch($PSCmdlet.ParameterSetName){
    "varName" { 
        $variable = $variableSet.Variables | Where-Object {$_.name -eq $varName}
     } # close switch varName

     "varID" {
        $variable = $variableSet.Variables | Where-Object {$_.Id -eq $varID}
     } # close switch varID
} # close switch

#Update variable
$variable.Value = $newValue
$Variable.IsSensitive = $false #Set to $true if you want to treat this variable as sensitive 

#Save variable set
$octoRepo.VariableSets.Modify($variableSet) | out-null

} # close function 

Function New-OctopusMachineKey {

# Mixture of code from
# - https://support.microsoft.com/en-us/kb/2915218
# - http://jeffgraves.me/2012/06/05/read-write-net-machine-key-with-powershell/
# - New code by Dan Bradley 26/11/2015
# - Modified by Jan Vrba 13/07/2016 - for Purpose of AHNewFirm Automation

  [CmdletBinding()]
  param (
    [ValidateSet("AES", "DES", "3DES", "MD5", "SHA1", "HMACSHA256", "HMACSHA384", "HMACSHA512")]
    [string]$algorithm = 'AES'
  )
  process {
    function BinaryToHex {
        [CmdLetBinding()]
        param($bytes)
        process {
            $builder = new-object System.Text.StringBuilder
            foreach ($b in $bytes) {
              $builder = $builder.AppendFormat([System.Globalization.CultureInfo]::InvariantCulture, "{0:X2}", $b)
            }
            $builder
        }
    }
    switch ($algorithm) {
      "AES" { 
        $decryptionObject = new-object System.Security.Cryptography.AesCryptoServiceProvider
        $decryptionObject.KeySize = 256
      }
      "DES" { $decryptionObject = new-object System.Security.Cryptography.DESCryptoServiceProvider }
      "3DES" { $decryptionObject = new-object System.Security.Cryptography.TripleDESCryptoServiceProvider }
      "MD5" { $decryptionObject = new-object System.Security.Cryptography.HMACMD5 }
      "SHA1" { $decryptionObject = new-object System.Security.Cryptography.HMACSHA1 }
      "HMACSHA256" { $decryptionObject = new-object System.Security.Cryptography.HMACSHA256 }
      "HMACSHA385" { $decryptionObject = new-object System.Security.Cryptography.HMACSHA384 }
      "HMACSHA512" { $decryptionObject = new-object System.Security.Cryptography.HMACSHA512 }
    }
    $decryptionObject.GenerateKey()
    $decryptionKey = BinaryToHex($decryptionObject.Key)
    $decryptionObject.Dispose()
    
    $decryptionKey
  }
} # close function
#endregion AH Functions

set-location $HOME
