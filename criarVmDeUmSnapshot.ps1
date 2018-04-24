#Conectar Azure
	Login-AzureRmAccount

#Verificar as subinscrições
	Get-AzureRmSubscription

#Selecionar uma subscrição
	Select-AzureRmSubscription -SubscriptionId "b40efdad-97cd-43b7-a9ea-210da50f17b7"

#Fornecer o nome do seu grupo de recursos
	$resourceGroupName ='AZ-NETPDD-BRSOUTH'

#Fornecer o nome do instantaneo que sera usado para criar o disco do SO
	$snapshotName = 'teste-snapshot'

#Fornecer o nome do disco do SO que será criado usando o instantâneo
	$osDiskName = 'meuTesteSnap'

#Fornecer o nome de uma rede virtual existente em que a máquina virtual será criada
	$virtualNetworkName = 'VNET-NETPDD-PROD'

#Fornecer o nome da máquina virtual
	$virtualMachineName = 'teste-SnapshotScript'

#Fornecer o tamanho da máquina virtual
#e.g. Standard_DS3
#Obtenha todos os tamanhos de vm em uma região usando o script abaixo:
#e.g. Get-AzureRmVMSize -Location brazilsouth
	$virtualMachineSize = 'Standard_B1s'

#Definir o contexto para o ID de assinatura em que o Disco gerenciado será criado
	$snapshot = Get-AzureRmSnapshot -ResourceGroupName $resourceGroupName -SnapshotName $snapshotName
 
	$diskConfig = New-AzureRmDiskConfig -Location $snapshot.Location -SourceResourceId $snapshot.Id -CreateOption Copy
 
	$disk = New-AzureRmDisk -Disk $diskConfig -ResourceGroupName $resourceGroupName -DiskName $osDiskName

#Inicialize a configuração da máquina virtual
	$VirtualMachine = New-AzureRmVMConfig -VMName $virtualMachineName -VMSize $virtualMachineSize

#Use o ID de recurso de disco gerenciado para anexá-lo à máquina virtual. Por favor, altere o tipo de sistema operacional para Linux se o disco do SO tiver o SO Linux
	$VirtualMachine = Set-AzureRmVMOSDisk -VM $VirtualMachine -ManagedDiskId $disk.Id -CreateOption Attach -Linux

#Crie um IP público para a VM
	$publicIp = New-AzureRmPublicIpAddress -Name ($VirtualMachineName.ToLower()+'_ip') -ResourceGroupName $resourceGroupName -Location $snapshot.Location -AllocationMethod Dynamic

#Obtenha a rede virtual em que a máquina virtual será hospedada
	$vnet = Get-AzureRmVirtualNetwork -Name $virtualNetworkName -ResourceGroupName $resourceGroupName

#Criar NIC na primeira sub-rede da rede virtual
	$nic = New-AzureRmNetworkInterface -Name ($VirtualMachineName.ToLower()+'_nic') -ResourceGroupName $resourceGroupName -Location $snapshot.Location -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $publicIp.Id

	$VirtualMachine = Add-AzureRmVMNetworkInterface -VM $VirtualMachine -Id $nic.Id

#Crie a máquina virtual com o disco gerenciado
	New-AzureRmVM -VM $VirtualMachine -ResourceGroupName $resourceGroupName -Location $snapshot.Location
