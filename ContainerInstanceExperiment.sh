# Log in to az
az login
az account list -o table

# Variables 
loc=centralus
rg=tk-acr-rg
aiName=tk-test-ci
dnsName=tk-$RANDOM-ci
# Create rg
az group create -n $rg -l $loc   

# Create Container Instance 
az container create -g $rg \
    -n $aiName \
    --image mcr.microsoft.com/azuredocs/aci-helloworld \
    --ports 80 \
    --dns-name-label $dnsName \
    -l $loc \
    --cpu 2 --memory 3.5

# Check container status
az container show -g $rg \
    -n $aiName \
    --query "{FQDN:ipAddress.fqdn,ProvisioningState:provisioningState}" \
    --out table 


#######################################
# Clean up resources
az group delete -n $rg -y --no-wait

# Reference
# https://learn.microsoft.com/en-us/training/modules/create-run-container-images-azure-container-instances/3-run-azure-container-instances-cloud-shell