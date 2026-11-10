# Lab 01 – ARM template basics

Based on the Microsoft Learn exercise *Create and deploy an Azure Resource Manager template*.

## What this lab covers

- The structure of an ARM template (`parameters`, `variables`, `resources`, `outputs`)
- Deploying a template to a resource group with the Azure CLI
- Adding a real resource (a storage account)
- Making a template reusable with parameters and a parameters file
- Returning information after deployment with outputs

## Files

| File | What it is |
|------|------------|
| `azuredeploy-blank.json` | Empty template. Deploys nothing; proves the process works. |
| `azuredeploy.json` | Where I got to in the exercise (unit 3): storage account with a `storageName` parameter. Starting point for unit 5. |
| `azuredeploy-storage.json` | Extended version: name and SKU as parameters, security settings and an output. |
| `azuredeploy.parameters.json` | Values for the storage template. Change `storageName` to something unique before deploying. |
| `deploy.sh` | Helper script to deploy and clean up. |

## How to run

In Azure Cloud Shell (Bash):

```bash
git clone https://github.com/wais-mus/az104-labs.git
cd az104-labs/01-arm-template-basics
chmod +x deploy.sh

./deploy.sh blank      # test deployment, creates nothing
./deploy.sh storage    # creates the storage account
./deploy.sh cleanup    # deletes everything when finished
```

Or run the commands by hand:

```bash
az group create --name rg-az104-armlab-weu --location westeurope

az deployment group create \
  --resource-group rg-az104-armlab-weu \
  --name addstorage-$(date +"%d-%b-%Y") \
  --template-file azuredeploy-storage.json \
  --parameters azuredeploy.parameters.json
```

Override a parameter without editing the file:

```bash
--parameters azuredeploy.parameters.json storageName=waislab98765
```

## Check the result

Portal → **Resource groups → rg-az104-armlab-weu → Deployments**. Each deployment shows its inputs, outputs and the exact template used.

## What I learned

- A template describes the end state; Azure works out how to get there.
- Deploying the same template again doesn't create duplicates. Azure updates what's there to match (incremental mode).
- Parameters turn a one-off template into one I can reuse for other environments or sites.
- Storage account names must be globally unique, 3–24 characters, lowercase letters and numbers (no hyphens, despite what the Learn guide says).
- West Europe wasn't accepting new storage accounts for my free subscription ("region not accepting new customers"). I kept the resource group in West Europe and set the storage account's location to `swedencentral`. A resource group's region and its resources' regions are independent.
- Pasting long heredocs into Cloud Shell can corrupt the JSON. Pasting into `code azuredeploy.json` is more reliable, and `python3 -m json.tool azuredeploy.json` checks the file before deploying.

## Clean up

Always delete the resource group after a lab so nothing keeps costing money:

```bash
az group delete --name rg-az104-armlab-weu --yes --no-wait
```
