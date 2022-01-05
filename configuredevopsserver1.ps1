#Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
#choco install jdk8 -y
cd "C:\Program Files\Azure DevOps Server 2020\Tools"
wget -o basic-new.ini https://keyvaultrgdiag572.blob.core.windows.net/files/basic-new.ini
./tfsconfig unattend /configure  /unattendfile:basic-new.ini