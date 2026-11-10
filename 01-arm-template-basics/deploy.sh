#!/usr/bin/env bash
# Deploys the lab templates to Azure. Run in Azure Cloud Shell (Bash) or any shell with the Azure CLI.
#
# Usage:
#   ./deploy.sh blank     # deploy the empty template (tests the process)
#   ./deploy.sh storage   # deploy the storage account template
#   ./deploy.sh cleanup   # delete the resource group and everything in it

set -euo pipefail

RESOURCE_GROUP="rg-az104-armlab-weu"
LOCATION="westeurope"
TODAY=$(date +"%d-%b-%Y")

case "${1:-}" in
  blank)
    az group create --name "$RESOURCE_GROUP" --location "$LOCATION" --output none
    az deployment group create \
      --resource-group "$RESOURCE_GROUP" \
      --name "blanktemplate-$TODAY" \
      --template-file azuredeploy-blank.json
    ;;
  storage)
    az group create --name "$RESOURCE_GROUP" --location "$LOCATION" --output none
    az deployment group create \
      --resource-group "$RESOURCE_GROUP" \
      --name "addstorage-$TODAY" \
      --template-file azuredeploy-storage.json \
      --parameters azuredeploy.parameters.json
    ;;
  cleanup)
    az group delete --name "$RESOURCE_GROUP" --yes --no-wait
    echo "Deleting $RESOURCE_GROUP in the background."
    ;;
  *)
    echo "Usage: $0 {blank|storage|cleanup}"
    exit 1
    ;;
esac
