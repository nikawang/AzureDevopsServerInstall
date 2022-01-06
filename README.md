# AzureDevopsServerInstall
Download the <b>[0.0.1](https://github.com/DanielWangZhanggui/AzureDevopsServerInstall/releases/tag/0.01)</b> version in release to test.
## Prerequisite
- Az cli has been installed and signed in
- The Windows Active Directory Domain Service has been deployed
- The VNET and subnet has been created
- The DNS Server in the VNET points to the Domain Service 
- The Azure DevOps Server installer has been uploaded to an Azure Storage 
  - It uses Azure DevOps Server 2020.1.1 in this repo. [Download Link](https://docs.microsoft.com/en-us/azure/devops/server/download/azuredevopsserver?view=azure-devops#download-the-latest-release)
## Topology

---

![Topology](https://user-images.githubusercontent.com/4372694/148360312-a3d838e0-8799-4c17-ba62-61a1fffe9e95.png)

The icons with orange color will be deployed in the script

---


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
2. Execute the <b>devops-server-install.sh</b> script to install
