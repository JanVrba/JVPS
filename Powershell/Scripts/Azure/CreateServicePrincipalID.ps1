# source : https://azure.microsoft.com/en-gb/documentation/articles/resource-group-authenticate-service-principal/ 

# 1. Login to Azure

Login-AzureRmAccount 

# 2. Get Subcription - TenantId

Get-AzureRmSubscription

# set tenant to variable
 
 $tenant = (Get-AzureRmSubscription -TenantId 49609590-02a8-49e5-9cea-83476ab25461).TenantId

 # create new Azure AD appilication

 $appArgs = @{
     DisplayName = "TestADApp"
     HomePage = "rennouxtestad.azurewebsites.net"
     IdentifierUris = "rennouxtestad.azurewebsites.net/rennouxtestad"
     Password = "Dev0p$+2016"
 }

 $azureAdApplication = New-AzureRmADApplication @appArgs