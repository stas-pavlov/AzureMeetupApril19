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

# Create Azure Resource Group
az group create --name "${AZURE_RG_NAME}" --location "${AZURE_DC_LOCATION}"

# Create Azure Container Service with Kubernetes as orchestrator
# 1 master and 2 agent
# will use SSH pub key from ~/.ssh/ if exists and
# generate keys if doesn't'
az acs create --resource-group="${AZURE_RG_NAME}" \
  --location="${AZURE_DC_LOCATION}" \
  --orchestrator-type=kubernetes \
  --master-count=1 --agent-count=2 \
  --agent-vm-size="Standard_D2_v2" \
  --admin-username="stask8sadmin" \
  --generate-ssh-keys \
  --name="${AZURE_SERVICE_NAME}" \
  --dns-prefix="${AZURE_DNS_PREFIX}"

  read  -n 1 -p "Press any key to continue..."

# Downoad .kube configuration from created Kubernetes cluster to work with kubectl 
az acs kubernetes get-credentials --resource-group=$AZURE_RG_NAME --name=$AZURE_SERVICE_NAME

# Check that the cluster created and run
kubectl cluster-info