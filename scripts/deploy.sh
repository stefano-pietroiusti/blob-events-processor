#!/bin/bash
# relies on receiving environment, function app and storage account name when called
# and needs to have login credentials from global
set -e

ENVIRONMENT=$1
FUNC_APP_NAME=$2
# Storage account names must be between 3 and 24 characters in length and may contain numbers and lowercase letters only
FUNC_STORAGE_NAME=$3

# branch and build info
export GIT_BRANCH=${BITBUCKET_BRANCH:-n/a}
export GIT_COMMIT=$(git rev-parse HEAD | cut -c1-7)
source ./scripts/tag.sh
export GIT_TAG=${BUILD_TAG:-n/a}

# stores the build information for access
echo "repo: file-manager.processor, build: ${GIT_TAG}, branch: ${GIT_BRANCH}, commit: ${GIT_COMMIT}" > ./deployments/build.txt

# how the zip file should look. We have a deployment script to install bin, but need to add our production node_modules
# https://docs.microsoft.com/en-us/azure/azure-functions/functions-reference-node#folder-structure
# https://docs.microsoft.com/en-us/azure/azure-functions/deployment-zip-push
echo "Creating and zipping deployments"
cp -r ./src/* ./deployments
cp ./package.json ./deployments
(cd ./deployments && npm install --production)
zip -r ./deployment.zip ./deployments/*

echo "Logging in to azure"
az login --service-principal -u ${azureServicePrincipalClientId} -p ${azureServicePrincipalPassword} --tenant ${azureServicePrincipalTenantId}

echo "Logged in, making resources if required"
FULL_APP_NAME=${ENVIRONMENT}-${FUNC_APP_NAME}
# Match the way serverless makes resource group names in case we go back to it
RESOURCE_GROUP_NAME=${FULL_APP_NAME}-rg

# create resources (if needed)
source ./scripts/createResource.sh

echo "setting auto build and environment variables"
az functionapp config appsettings set --name ${FULL_APP_NAME} \
                                      --resource-group ${RESOURCE_GROUP_NAME} \
                                      --settings \
                                      SCM_DO_BUILD_DURING_DEPLOYMENT=true \
                                      FUNCTION_APP_EDIT_MODE=readonly \
                                      WEBSITE_MAX_DYNAMIC_APPLICATION_SCALE_OUT=50 \
                                      stage="${ENVIRONMENT}" > /dev/null

echo "about to deploy for '${ENVIRONMENT}' for tag '${GIT_TAG}' on commit '${GIT_COMMIT}'"
az functionapp deployment source config-zip --name ${FULL_APP_NAME} \
                                            --resource-group ${RESOURCE_GROUP_NAME} \
                                            --src ./deployment.zip
				                                    #--debug (full logs)
echo "Upload complete"
