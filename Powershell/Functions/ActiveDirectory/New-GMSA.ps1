# Name : New-GMSA
# Date : 02/06/2016
# Purpose : Function creates new group management service account at AD and return SAM account name

function New-GMSA {

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
