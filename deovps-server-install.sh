#!/bin/bash
rg='addevops'
vmNameBase='devopsa'
vmCount=3
image='Win2016Datacenter'
vnetName='addevops-vnet'
subnet='default'
nsgName='ad1-nsg'
size='Standard_DS3_v2'
location='southeastasia'
userName="zhawadministrator"
passwd="\!@#QWEqwe123"
domainName="qijige.info"
sqlName="dandevopssql"
miName=$rg
storageAccountName="keyvaultrgdiag572"
containerName="files"
LBName="devopslb"
lbPrivateIP="172.18.0.100"
###
#create user managed identity
az group create -n $rg -l $location
az identity create -g $rg -n $miName

###
#create sql server and databases
az sql server create -n  $sqlName -g $rg --identity-type SystemAssigned,UserAssigned -u $userName -p $passwd -l $location
miID=`az identity show -n $rg -g $rg  --query principalId --output tsv` 
az sql server ad-admin create -g $rg --server-name $sqlName  --object-id $miID -u $rg
az sql server vnet-rule create --server $sqlName --name aadevopsvnet -g $rg --subnet $subnet --vnet-name $vnetName
az sql db create -g addevops -s $sqlName  -n AzureDevOps_Configuration -e GeneralPurpose -f Gen5 -c 2 --backup-storage-redundancy GEO
az sql db create -g addevops -s $sqlName  -n AzureDevOps_DefaultCollection -e GeneralPurpose -f Gen5 -c 2 --backup-storage-redundancy GEO

###
#create devops server vms
for i in $(seq $vmCount)
do 
    vmName="$vmNameBase$i" 
    echo "creating VM $vmName.." 
    az vm create -n $vmName -g $rg --vnet-name $vnetName --subnet $subnet --size $size --nsg $nsgName  --image $image --location $location --admin-username $userName --admin-password $passwd --public-ip-address ""
done 

###
#add vm to domain controllers. Can skip these steps if not necessary.
cp ./addtodc.temp.ps1 ./addtodc.ps1
sed -i "s/{userName}/$userName/g" ./addtodc.ps1
sed -i "s/{domainName}/$domainName/g" ./addtodc.ps1
sed -i "s/{password}/$passwd/g" ./addtodc.ps1

for i in $(seq $vmCount)
do
  vmName="$vmNameBase$i" 
  echo "adding VM $vmName to domain.."
  az vm run-command invoke --command-id RunPowerShellScript --name $vmName -g $rg --scripts "@addtodc.ps1"
  #the file will be uploaded to "C:\\Packages\\Plugins\\Microsoft.CPlat.Core.RunCommandWindows\\1.1.9\\Downloads"
done 
#rm -rf addtodc.ps1


###
#assign user idenity to vms
for i in $(seq $vmCount)
do 
    vmName="$vmNameBase$i" 
    echo "assign Managed Identity to VM $vmName.." 
    az vm identity assign -g $rg -n $vmName --identities $miName
done 

###
#create devops server
cp ./createdevopsserver.temp.ps1 ./createdevopsserver.ps1
sed -i "s/{storageAccountName}/$storageAccountName/g" ./createdevopsserver.ps1
sed -i "s/{containerName}/$containerName/g" ./createdevopsserver.ps1

for i in $(seq $vmCount)
do
  vmName="$vmNameBase$i" 
  echo "install devops server to $vmName .."
  az vm run-command invoke --command-id RunPowerShellScript --name $vmName -g $rg --scripts "@createdevopsserver.ps1"
done

###
#configure devops server
cp ./basic-new.temp.ini ./basic-new.ini
sed -i "s/{userName}/$userName/g" ./basic-new.ini
sed -i "s/{sqlName}/$sqlName/g" ./basic-new.ini
sed -i "s/{domainName}/$domainName/g" ./basic-new.ini
sed -i "s/{password}/$passwd/g" ./basic-new.ini
cp ./basic-existing.temp.ini ./basic-existing.ini
sed -i "s/{userName}/$userName/g" ./basic-existing.ini
sed -i "s/{domainName}/$domainName/g" ./basic-existing.ini
sed -i "s/{password}/$passwd/g" ./basic-existing.ini

cp ./configuredevopsserver1.temp.ps1 ./configuredevopsserver1.ps1    
cp ./configuredevopsserver2.temp.ps1 ./configuredevopsserver2.ps1 
sed -i "s/{storageAccountName}/$storageAccountName/g" ./configuredevopsserver1.ps1
sed -i "s/{containerName}/$containerName/g" ./configuredevopsserver1.ps1
sed -i "s/{storageAccountName}/$storageAccountName/g" ./configuredevopsserver2.ps1
sed -i "s/{containerName}/$containerName/g" ./configuredevopsserver2.ps1
for i in $(seq $vmCount)
do
  vmName="$vmNameBase$i" 
  if [ $i -eq 1 ]
  then
    echo "configure VM $vmName .."
    sed -i "s/{vmName}/$vmName/g" ./basic-new.ini
    az storage blob upload --container-name $containerName --file basic-new.ini --account-name $storageAccountName
    az vm run-command invoke --command-id RunPowerShellScript --name $vmName -g $rg --scripts "@configuredevopsserver1.ps1"
  else
    echo "configure VM $vmName .."
    sed -i "s/{vmName}/$vmName/g" ./basic-existing.ini
    az storage blob upload --container-name $containerName --file basic-existing.ini --account-name $storageAccountName
    az vm run-command invoke --command-id RunPowerShellScript --name $vmName -g $rg --scripts "@configuredevopsserver2.ps1"
  fi
done
###
#create LB
az network lb create --name $LBName -g $rg --private-ip-address $lbPrivateIP  --sku Standard --subnet $subnet --vnet-name $vnetName --backend-pool-name $rg -l $location
az network lb probe create -g $rg --lb-name $LBName  --name $rg --protocol tcp --port 80
az network lb rule create --resource-group $rg --lb-name $LBName --name $rg --protocol tcp --frontend-port 80 --backend-port 80 --backend-pool-name $rg --probe-name $rg 
for i in $(seq $vmCount)
do
  nicName="$vmNameBase$i"VMNic
  az network nic ip-config address-pool add --address-pool $rg --ip-config-name ipconfig$vmNameBase$i --nic-name $nicName --resource-group $rg --lb-name $LBName
done