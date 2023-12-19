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
    --cpu 2 --memory 3.5 \
    --restart-policy OnFailure

# ex2 (with env var)
aiName2=tk-test2-ci

az container create \
    -g $rg \
    -n $aiName2 \
    --image mcr.microsoft.com/azuredocs/aci-wordcount:latest \
    --restart-policy OnFailure \
    --environment-variables 'NumWords'='6' 'MinLength'='8'

# ex3 (with secure var)
az container create \
    -g $rg \
    --file nginx-ci.yaml 

#ex 4 with file mount (linux container)
az container create \
    -g $rg \
    --name hellofiles \
    --image mcr.microsoft.com/azuredocs/aci-hellofiles \
    --dns-name-label aci-demo \
    --ports 80 \
    --azure-file-volume-account-name $ACI_PERS_STORAGE_ACCOUNT_NAME \
    --azure-file-volume-account-key $STORAGE_KEY \
    --azure-file-volume-share-name $ACI_PERS_SHARE_NAME \
    --azure-file-volume-mount-path /aci/logs/
    
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