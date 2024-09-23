set -e
export ARM_OIDC_REQUEST_TOKEN=$ACTIONS_ID_TOKEN_REQUEST_TOKEN
export ARM_OIDC_REQUEST_URL=$ACTIONS_ID_TOKEN_REQUEST_URL
if [ -z "$ACTIONS_ID_TOKEN_REQUEST_URL" ]; then
  export ARM_USE_OIDC=true
fi
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v $(pwd):/src -w /src --network=host -e GITHUB_TOKEN -e ARM_SUBSCRIPTION_ID -e ARM_TENANT_ID -e ARM_CLIENT_ID -e ARM_OIDC_REQUEST_TOKEN -e ARM_OIDC_REQUEST_URL -e ARM_USE_OIDC -e TF_IN_AUTOMATION -e TF_VAR_enable_telemetry mcr.microsoft.com/azterraform:latest make version-upgrade-test
sudo chown -R $USER ./