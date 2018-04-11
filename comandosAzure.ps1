###Conectar no azure via powershell###

#Conectar Azure
  Login-AzureRmAccount

#Verificar as subinscrições
  Get-AzureRmSubscription

#Selecionar uma subinscrição
  Select-AzureRmSubscription -SubscriptionId "<subscriptionID>"
  
###Comandos para consulta###

#Verificar os Resources Groups
	Get-AzureRmResource

#Verificar as contas de storage
	Get-AzureRmStorageAccount
  
###Comandos para criação###  

#Criar um Resource Group
	New-AzureRmResourceGroup -Name Netpiedade -location "brazilsouth"
