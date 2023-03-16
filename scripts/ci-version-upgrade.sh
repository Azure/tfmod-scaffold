set -e
az login --identity --username $MSI_ID > /dev/null
export ARM_SUBSCRIPTION_ID=$(az login --identity --username $MSI_ID | jq -r '.[0] | .id')
export ARM_TENANT_ID=$(az login --identity --username $MSI_ID | jq -r '.[0] | .tenantId')
docker run --rm -v $(pwd):/src -w /src --network=host -e GITHUB_TOKEN -e MSI_ID -e ARM_SUBSCRIPTION_ID -e ARM_TENANT_ID -e ARM_USE_MSI=true mcr.microsoft.com/azterraform:latest make version-upgrade-test
sudo chown -R $USER ./