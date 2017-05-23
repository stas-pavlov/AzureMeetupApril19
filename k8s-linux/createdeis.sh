# Azure Resource Group name
export AZURE_RG_NAME=stas-k8s-rg			 
# Azure DC Location
export AZURE_DC_LOCATION=southcentralus		
# Azure Container Service name
export AZURE_SERVICE_NAME=stas-k8s-acs		
# Azure DNS Prefix for Azure Container Service
export AZURE_DNS_PREFIX=stas-k8s			
# Azure Storage Account name for DEIS usage
export AZURE_SA_NAME=stask8sdeisstorage		

# Init Helm localy and install Tiller at Kubernetes cluster
helm init

# Add Deis repository to helm
helm repo add deis https://charts.deis.com/workflow

# Create Azure Storage Account
az storage account create -n $AZURE_SA_NAME -l $AZURE_DC_LOCATION -g $AZURE_RG_NAME --sku Standard_LRS

# Take Azure Account Key to pass it to helm install to use by Deis
export AZURE_SA_KEY=`az storage account keys list -n $AZURE_SA_NAME -g $AZURE_RG_NAME --query [0].value --output tsv`

# Install Deis in Kubernetes cluster to deis namespace
helm install deis/workflow --namespace=deis --set global.storage=azure,azure.accountname=$AZURE_SA_NAME,azure.accountkey=$AZURE_SA_KEY,azure.registry_container=registry,azure.database_container=database,azure.builder_container=builder

# Check that Desi pods are starting at Kubernetes cluster
kubectl --namespace=deis get pods