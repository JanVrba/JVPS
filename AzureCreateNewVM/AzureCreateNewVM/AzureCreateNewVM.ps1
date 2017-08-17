# 9.5.2017
# AzureCreateNewVM.ps1
# source > https://docs.microsoft.com/cs-cz/azure/virtual-machines/virtual-machines-windows-ps-create

[CmdletBinding(SupportsShouldProcess=$True)]

param(		
) # close param

# Azure RM module
# if fail : Save-Module -Name AzureRM -Path <path> - modules folder

Install-Module AzureRM
Import-Module AzureRM -Verbose

# Login to Azure
# before  : Login-AzureRmAccount ,  Save-AzureRmContext -Path “C:\Temp\AzureProfile.json”

$AzureProfile = "C:\Temp\AzureProfile.json"

Import-AzureRmContext -path $AzureProfile -Verbose

# Create Resource Group

$location = "westeurope"

$myResourceGroup = "PSTestResourceGroup"

New-AzureRmResourceGroup -Name $myResourceGroup -Location $location -Verbose

# Create Storage Account

$myStorageAccountName = "pstestrennouxsa"

$parms = @{
			'ResourceGroupName'= $myResourceGroup;
			'Name'= $myStorageAccountName;
			'SkuName'='Standard_LRS';
			'Kind'='Storage';
			'Location' = $location
          }

$myStorageAccount = New-AzureRmStorageAccount @parms -Verbose

# Create Subnet

$mySubnet = New-AzureRmVirtualNetworkSubnetConfig -Name "mySubnet" -AddressPrefix 10.0.0.0/24 -Verbose

$parms = @{
			'Name'= 'myVnet';
			'ResourceGroupName'= $myResourceGroup;
			'Location' = $location;
			'AddressPrefix'= '10.0.0.0/16';
			'Subnet' = $mySubnet
          }

$myVnet = New-AzureRmVirtualNetwork @parms -Verbose

# Create Public IP

$parms = @{
			'Name'= 'myPublicIp';
			'ResourceGroupName'= $myResourceGroup;
			'Location' = $location;
			'AllocationMethod'= 'Dynamic'
          }

$myPublicIp = New-AzureRmPublicIpAddress @parms -Verbose

# Create newtwork interface

$parms = @{
			'Name'= 'myNIC';
			'ResourceGroupName'= $myResourceGroup;
			'Location' = $location;
			'SubnetId'= $myVnet.Subnets[0].Id;
			'PublicIpAddressId' = $myPublicIp.Id
          }

$myNIC = New-AzureRmNetworkInterface @parms -Verbose

$cred = Get-Credential -Message "Type the name and password of the local administrator account."

# Create VM

$myVM = New-AzureRmVMConfig -VMName "myVM" -VMSize "Standard_DS1_v2" -Verbose

$parms = @{
			'VM'= $myVM;	  
            'ComputerName' = 'PSTRennoux';
			'Credential'= $cred	   
          }

$myVM = Set-AzureRmVMOperatingSystem @parms -windows -ProvisionVMAgent -EnableAutoUpdate -Verbose

$parms = @{
			'VM'= $myVM;	  
			'PublisherName' = 'MicrosoftWindowsServer';
			'Offer' = 'WindowsServer';
			'Skus'= '2012-R2-Datacenter';
			'Version'= 'latest'	   
          }

$myVM = Set-AzureRmVMSourceImage @parms -Verbose

$myVM = Add-AzureRmVMNetworkInterface -VM $myVM -Id $myNIC.Id -Verbose

$blobPath = "vhds/myOsDisk1.vhd"

$osDiskUri = $myStorageAccount.PrimaryEndpoints.Blob.ToString() + $blobPath

$parms = @{
			'VM'= $myVM;	  
			'Name' = 'myOsDisk1';
			'VhdUri' = $osDiskUri;
			'CreateOption'= 'fromImage'	      
          } 

$myVM = Set-AzureRmVMOSDisk @parms -Verbose

$parms = @{
			'ResourceGroupName'= $myResourceGroup;	  
			'Location' = $location;
			'VM' = $myVM	 	      
          }

New-AzureRmVM @parms -Verbose
