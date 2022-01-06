cd C:\
#upload the azure devops server installer to the storage account first..
wget -o azuredevopsserver.exe https://{storageAccountName}.blob.core.windows.net/{containerName}/azuredevopsserver2020.1.1.exe
./azuredevopsserver.exe /Silent