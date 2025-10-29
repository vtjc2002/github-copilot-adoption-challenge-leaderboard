#!/bin/bash
# Bash script to deploy infra.bicep for the Leaderboard App without Docker (runtime = built-in .NET)

RESOURCE_GROUP="${1:-leaderboardAppDeploy6}"
LOCATION="${2:-australiaeast}"
POSTGRES_ADMIN="${3:-pgadmin}"
POSTGRES_PASSWORD="${4:-pgpassword}"

# Create the resource group if it doesn't exist
az group create \
  --name "$RESOURCE_GROUP" \
  --location "$LOCATION"

echo "Deploying infra.bicep (built-in App Service runtime)..."
az deployment group create \
  --resource-group "$RESOURCE_GROUP" \
  --template-file "./infra.bicep" \
  --parameters postgresAdmin="$POSTGRES_ADMIN" postgresPassword="$POSTGRES_PASSWORD" location="$LOCATION"

# Retrieve the App Service name and Key Vault name from the deployment outputs
# Get the deployment name for infra.bicep (filter by templateLink.uri containing 'infra.bicep')
deploymentName="infra"
webAppName=$(az deployment group show --resource-group "$RESOURCE_GROUP" --name "$deploymentName" --query "properties.outputs.webAppName.value" -o tsv | tr -d '\r' | tr -d '\n' | xargs)
keyVaultName=$(az deployment group show --resource-group "$RESOURCE_GROUP" --name "$deploymentName" --query "properties.outputs.keyVaultName.value" -o tsv | tr -d '\r' | tr -d '\n' | xargs)
appGatewayIp=$(az deployment group show --resource-group "$RESOURCE_GROUP" --name "$deploymentName" --query "properties.outputs.appGatewayPublicIp.value" -o tsv | tr -d '\r' | tr -d '\n' | xargs)
appServiceHost=$(az deployment group show --resource-group "$RESOURCE_GROUP" --name "$deploymentName" --query "properties.outputs.appServiceHost.value" -o tsv | tr -d '\r' | tr -d '\n' | xargs)

# Get the managed identity principalId for the App Service
webAppPrincipalId=$(az webapp identity show --name "$webAppName" --resource-group "$RESOURCE_GROUP" --query principalId -o tsv | tr -d '\r' | tr -d '\n' | xargs)
echo "App Service PrincipalId: $webAppPrincipalId"
echo "Key Vault Name: $keyVaultName"

# Assign Key Vault Secrets User role to the App Service managed identity
az role assignment create \
  --assignee "$webAppPrincipalId" \
  --role "Key Vault Secrets User" \
  --scope "/subscriptions/$(az account show --query id -o tsv | tr -d '\r' | tr -d '\n' | xargs)/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.KeyVault/vaults/$keyVaultName"

echo "Assigned Key Vault Secrets User role to App Service managed identity."

echo "Enabling VNet integration for the App Service..."

subscription=$(az account show --query id -o tsv | tr -d '\r' | tr -d '\n' | xargs)

az webapp config set --resource-group "$RESOURCE_GROUP" --subscription "$subscription" --name "$webAppName" --generic-configurations '{"vnetRouteAllEnabled": true}'

echo "VNet integration enabled for App Service."

echo "Deployment complete."
printf "Add this to your hosts (C:\Windows\System32\drivers\etc\hosts) file to test the application:\n"
echo "$appGatewayIp $appServiceHost"
echo "Then navigate to http://$appServiceHost in your browser - make sure you use HTTP in this case - HTTPS can be configured with a CA cert in App Gateway if needed."