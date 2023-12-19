# Log in to az
az login
az account list -o table

# Install CLI extentions 
az extension add --name containerapp --upgrade  
az provider register --namespace Microsoft.App  
az provider register --namespace Microsoft.OperationalInsights

# Variables 
loc=centralus
rg=tk-ca-rg
caeName="tk-cae"
caName="tk-ca"

# Create rg
az group create -n $rg -l $loc

# Create container app environment 
az containerapp env create -n $caeName -g $rg -l $loc

# Create container app (using `containerapps-helloworld` image)
az containerapp create \
    -n $caName \
    -g $rg \
    --environment $caeName \
    --image mcr.microsoft.com/azuredocs/containerapps-helloworld:latest \
    --target-port 80 \
    --ingress 'external' \
    --query properties.configuration.ingress.fqdn

# Use FQDN retunred to check if container app resource is running 

# Updat container app
# Update environment variables, compute resources, scale parameters, and deploy a different image
az containerapp update \
  -n $caName \
  -g $rg \
  --image <IMAGE_NAME>

# list all revisions associated with container app
az containerapp revision list \
  -n $caName \
  -g $rg \
  -o table

#define secret when creating continer app
az containerapp create \
  --resource-group "my-resource-group" \
  --name queuereader \
  --environment "my-environment-name" \
  --image demos/queuereader:v1 \
  --secrets "queue-connection-string=$CONNECTION_STRING"
#######################################
# Clean up resources
az group delete -n $rg -y

# Reference
# https://learn.microsoft.com/en-us/training/modules/implement-azure-container-apps/3-exercise-deploy-app