cd C:\
#upload the azure devops server installer to the storage account first..
wget -o azuredevopsserver.exe https://{storageAccountName}.blob.core.windows.net/{containerName}/azuredevopsserver2020.1.1.exe
./azuredevopsserver.exe /Silent
while(1 -eq 1){
    $azuredevopsserver= Get-Process azuredevopsserver -ErrorAction SilentlyContinue
    if ($azuredevopsserver) {
        echo "azure devops server installation is still running.."
    }
    else
    {
        echo "running completed.."
        $installed=Test-Path -Path "C:\Program Files\Azure DevOps Server 2020\Tools\tfsconfig.exe" -PathType Leaf
        if($installed)
        {
            echo "Files copy completed"
            Break
        }
        echo "Please check if it's need rerun the exe file.."
    }
    sleep 10
}

Restart-Computer -Force
