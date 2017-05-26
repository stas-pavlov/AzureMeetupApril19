# Azure Resource Group name
export AZURE_RG_NAME=stas-k8s-win-rg			 
# Azure DC Location
export AZURE_DC_LOCATION=southcentralus		
# Azure Container Service name
export AZURE_SERVICE_NAME=stas-k8s-win-acs		
# Azure DNS Prefix for Azure Container Service
export AZURE_DNS_PREFIX=stas-k8s-win			
# Admin password for Windows K8S servers 

export AZURE_WINADMIN_PWD=StrongestEverPasswordForK8SWindowsAzure2017!	

# Create Azure Resource Group
az group create --name "${AZURE_RG_NAME}" --location "${AZURE_DC_LOCATION}"

# Create Azure Container Service with Kubernetes as orchestrator
# use Windows as a base OS
# 1 master and 2 agent
# use SSH pub key from ~/.ssh/
az acs create --resource-group="${AZURE_RG_NAME}" \
  --location="${AZURE_DC_LOCATION}" \
  --orchestrator-type=kubernetes \
  --master-count=1 --agent-count=2 \
  --agent-vm-size="Standard_D2_v2" \
  --name="${AZURE_SERVICE_NAME}" \
  --dns-prefix="${AZURE_DNS_PREFIX}" \
  --windows --admin-username="stask8sadmin" \
  --admin-password="${AZURE_WINADMIN_PWD}"
  

# Downoad .kube configuration from created Kubernetes cluster to work with kubectl 
az acs kubernetes get-credentials --resource-group=$AZURE_RG_NAME --name=$AZURE_SERVICE_NAME

# Check that the cluster created and run
kubectl cluster-info