# Declarando a URL do VHD que será o Sistema operacional
$imageURI = "https://azjotateistorage01.blob.core.windows.net/vhds/DiskOS-UC-JEW-APP4.VHD"
$imageURI1 = "https://azjotateistorage01.blob.core.windows.net/vhds/DiskDADOS1-UC-JEW-APP4.VHD"

# Declarando o nome do grupo de recurso já criado no AZURE
$rgName = “AZ-JW-RG-US-EAST2”

# Declarando a subnet no azure
$subnetName = “AZ-VNET-2590”
 
# Criando a subnet da network
#$singleSubnet = New-AzureRmVirtualNetworkSubnetConfig -Name $subnetName -AddressPrefix 192.168.1.0/24
        
#Definindo a região que será lancada a VM
$location = "eastus2"
 
# Nome da Network da VM
$vnetName = “AZ-VNET-2590”
 
# Criando a network
#$vnet = New-AzureRmVirtualNetwork -Name $vnetName -ResourceGroupName $rgName -Location $location -AddressPrefix 192.168.1.0/24 -Subnet $singleSubnet

#Declarando O IP
$ipName = “AZ-JEW-APP4-IP-PUBLIC”

# Criando o IP
$pip = New-AzureRmPublicIpAddress -Name $ipName -ResourceGroupName $rgName -Location $location -AllocationMethod Static

# Declarando a interface de REDE
$nicName = “NIC_AZ-JEW-APP4”

#Criando a variável da virtual network
$vnet = Get-AzureRmVirtualNetwork -ResourceGroupName $rgName -Name $vnetName

# Criando 
$nic = New-AzureRmNetworkInterface -Name $nicName -ResourceGroupName $rgName -Location $location -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id -PrivateIpAddress 10.20.12.4

# Declarando o grupo de segurança
#$nsgName = “NSG_MDMSOLUCOES”

# Criando as regras de Grupo de segurança
#$rdpRule = New-AzureRmNetworkSecurityRuleConfig -Name myRdpRule -Description "Allow RDP" `
#   -Access Allow -Protocol Tcp -Direction Inbound -Priority 110 `
#  -SourceAddressPrefix Internet -SourcePortRange * `
# -DestinationAddressPrefix * -DestinationPortRange 3389

# Criando o Grupo de segurança
#$nsg = New-AzureRmNetworkSecurityGroup -ResourceGroupName $rgName #-Location $location `
#    -Name $nsgName -SecurityRules $rdpRule
# Enter a new user name and password to use as the local administrator account 
    # for remotely accessing the VM.
#$cred = Get-Credential
 
#Informar o storage account name
$storageAccName = "azjotateistorage01”
 
# Name of the virtual machine. This example sets the VM name as "myVM".
$vmName = “AZ-JEW-APP4”
 
# Size of the virtual machine. This example creates "Standard_D2_v2" sized VM. 
# See the VM sizes documentation for more information: 
# https://azure.microsoft.com/documentation/articles/virtual-machines-windows-sizes/
$vmSize = "Standard_D4s_v3”
 
# Computer name for the VM. This examples sets the computer name as "myComputer".
$computerName = “AZ-JEW-APP4”
 
# Name of the disk that holds the OS. This example sets the 
# OS disk name as "OsDisk"
$osDiskName = “OsDisk_AZ-JEW-APP4”
$dataDiskName = “DataDisk_AZ-JEW-APP4”
 
# Assign a SKU name. This example sets the SKU name as "Standard_LRS"
# Valid values for -SkuName are: Standard_LRS - locally redundant storage, Standard_ZRS - zone redundant
# storage, Standard_GRS - geo redundant storage, Standard_RAGRS - read access geo redundant storage,
# Premium_LRS - premium locally redundant storage. 
$skuName = "Standard_LRS"
 
# Get the storage account where the uploaded image is stored
$storageAcc = Get-AzureRmStorageAccount -ResourceGroupName $rgName -AccountName $storageAccName
 
# Set the VM name and size
$vmConfig = New-AzureRmVMConfig -VMName $vmName -VMSize $vmSize
 
#Set the Windows operating system configuration and add the NIC
#$vm = Set-AzureRmVMOperatingSystem -VM $vmConfig -Windows -ComputerName $computerName -Credential $cred -ProvisionVMAgent -EnableAutoUpdate
$vm = Add-AzureRmVMNetworkInterface -VM $vmConfig -Id $nic.Id
 
# Create the OS disk URI
$osDiskUri = '{0}vhds/{1}-{2}.vhd' -f $storageAcc.PrimaryEndpoints.Blob.ToString(), $vmName.ToLower(), $osDiskName
 
# Configure the OS disk to be created from the existing VHD image (-CreateOption Attach).
$vm = Set-AzureRmVMOSDisk -VM $vm -Name $osDiskName -VhdUri $imageURI -CreateOption Attach -Windows
$vm = Add-AzureRmVMDataDisk -VM $vm -Name $DataDiskName -VhdUri $imageURI1 -LUN 1 -CreateOption Attach
 
##Ultimo Passo
# Create the new VM
New-AzureRmVM -ResourceGroupName $rgName -Location $location -VM $vm
