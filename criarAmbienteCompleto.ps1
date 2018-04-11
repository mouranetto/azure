#Conectar no painel azure ARM
  Login-AzureRmAccount
  
#Consultar as subscriptions configuradas na conta
  Get-AzureRmSubscription
  
#Selecionar a subscription desejada
  Select-AzureRmSubscription -SubscriptionName "Nome da subscription"
  
#Declarando as variáveis
  $VNetName = "Nome da vnet"
  $FESubName = "Nome da rede front end"
  $BESubName = "Nome da rede back end"
  $GWSubName = "Nome da rede de gateway"
  $FEVNetPrefix = "192.168.0.0/16"
  $BEVNetPrefix = "10.254.0.0/16"
  $FESubPrefix = "192.168.1.0/24"
  $BESubPrefix = "10.254.1.0/24"
  $GWSubPrefix = "192.168.200.0/26"
  $VPNClientAddressPool = "172.16.201.0/24"
  $RG = "Nome do resource group"
  $Location = "br-south"
  $DNS = "8.8.8.8"
  $GWName = "Nome do gateway"
  $GWIPName = "Nome do ip publico do gateway"
  $GWIPConfName = "Nome da configuração do gateway"

#Comando para criar o Resource Group
  New-AzureRmResourceGroup -Name $RG -Location $Location
