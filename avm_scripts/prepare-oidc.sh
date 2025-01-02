#!/bin/bash
set -e

declare -A secrets
eval "$(echo $SECRETS_CONTEXT | jq -r 'to_entries[] | @sh "secrets[\(.key|tostring)]=\(.value|tostring)"')"

declare -A variables
eval "$(echo $VARS_CONTEXT | jq -r 'to_entries[] | @sh "variables[\(.key|tostring)]=\(.value|tostring)"')"

for key in "${!secrets[@]}"; do
  if [[ $key = \TF_VAR_* ]]; then
    lowerKey=$(echo "$key" | tr '[:upper:]' '[:lower:]')
    finalKey=${lowerKey/tf_var_/TF_VAR_}
    export "$finalKey"="${secrets[$key]}"
  fi
done

for key in "${!variables[@]}"; do
  if [[ $key = \TF_VAR_* ]]; then
    lowerKey=$(echo "$key" | tr '[:upper:]' '[:lower:]')
    finalKey=${lowerKey/tf_var_/TF_VAR_}
    export "$finalKey"="${variables[$key]}"
  fi
done

echo -e "Custom environment variables:\n$(env | grep TF_VAR_ | grep -v ' "TF_VAR_')"

# Set up the Azure Provider Environment Variables
tenantId=$ARM_TENANT_ID_OVERRIDE
if [ -z "$tenantId" ]; then
  tenantId=$ARM_TENANT_ID
fi
echo "tenantId: $tenantId"

subscriptionId=$ARM_SUBSCRIPTION_ID_OVERRIDE
if [ -z "$subscriptionId" ]; then
  subscriptionId=$ARM_SUBSCRIPTION_ID
fi

clientId=$ARM_CLIENT_ID_OVERRIDE
if [ -z "$clientId" ]; then
  clientId=$ARM_CLIENT_ID
fi

export ARM_TENANT_ID=$tenantId
export ARM_SUBSCRIPTION_ID=$subscriptionId
export ARM_CLIENT_ID=$clientId
export ARM_OIDC_REQUEST_TOKEN=$ACTIONS_ID_TOKEN_REQUEST_TOKEN
export ARM_OIDC_REQUEST_URL=$ACTIONS_ID_TOKEN_REQUEST_URL