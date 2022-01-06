# AzureDevopsServerInstall
Use the 0.0.1 version to test.
## Prerequisite
- az cli has been installed and signed in
- The Windows Active Directory Domain Service has been deployed
- The VNET and subnet has been created
- The DNS Server in the VNET points to the Domain Service 
- The installer has been uploaded to an Azure Storage 
## Architecture



## Variables 
| Name      | Description |
| :---  | :--- |
| rg    | Resource Group Name, 
| vmNameBase | The prefix of VM Name, we user create multiple VMs to set up the cluster
| vmCount | Count of DevOps Server VMs|
| image | Windows VM image used to deploy DevOps Server | 
| vnetName | The VNET Name used to deploy DevOps Server|
| subnet | The Subnet Name in the VNET used to deploy DevOps Server |
| nsgName | The NSG Name in the VNET used to deploy DevOps Server |
| size | DevOps Server VM size |
| location | which Region |
| userName | VM admin user name , and it exisits in the AD Domain |
| passwd | The password of the VM admin user|
| domainName | AD Domain Name |
| sqlName | The Azure SQL Name, as the databases backend of the DevOps Server |
| miName | User Managed Identity Name, use as admin of the Azure SQL, binding to the devops server VMs |
| storageAccountName | Use to store the Azure DevOps Server configuration files and DevOps Server installer |
| containerName | the container name of the storage account to store the files |
| LBName | the internal LB of the DevOps Servers |
| lbPrivateIP | the front private IP of the LB |

## Set up
1. Assign the variables  in <b>devops-server-install.sh</b>  script
2. execute the <b>devops-server-install.sh</b> script 