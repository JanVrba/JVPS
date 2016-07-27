# create Artifacts locatian and Artifacts SAS token

$ResourceGroupName = ""
$StorageAccountName =""
$StorageContainerName = $ResourceGroupName.ToLowerInvariant() + '-stageartifacts'
$StorageAccountContext = (Get-AzureRmStorageAccount | Where-Object{$_.StorageAccountName -eq $StorageAccountName}).Context
$ArtifactsLocation = $StorageAccountContext.BlobEndPoint + $StorageContainerName

 $ArtifactsLocationSasToken = New-AzureStorageContainerSASToken -Container $StorageContainerName -Context $StorageAccountContext -Permission r -ExpiryTime (Get-Date).AddHours(4)
 $ArtifactsLocationSasToken = ConvertTo-SecureString $ArtifactsLocationSasToken -AsPlainText -Force
 $OptionalParameters[$ArtifactsLocationSasTokenName] = $ArtifactsLocationSasToken