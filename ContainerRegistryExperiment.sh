# Log in to az
az login
az account list -o table

# Variables 
loc=centralus
rg=tk-acr-rg
acrName=tktesttestacr  

# Create rg
az group create -n $rg -l $loc

# Create ACR
az acr create -n $acrName -g $rg --sku Basic

#push image from dockefile
az acr build --image sample/hello-world:v1  \
    --registry $acrName \
    --file Dockerfile .

# List repos in ACR
az acr repository list --name $acrName --output table

#show tags
az acr repository show-tags --name $acrName --repository sample/hello-world --output table  

# Run the image in the ACR
az acr run --registry $acrName \
    --cmd 'tktesttestacr.azurecr.io/sample/hello-world:v1' /dev/null

#######################################
# Clean up resources
az group delete -n $rg -y

# Reference
# https://learn.microsoft.com/en-us/training/modules/publish-container-image-to-azure-container-registry/6-build-run-image-azure-container-registry