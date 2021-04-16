#!/bin/bash
# invoke via source
# relies on FULL_APP_NAME, RESOURCE_GROUP_NAME and FUNC_STORAGE_NAME in env variables
# and having performed az login prior to invoking
# note: Azure can be a little slow at making resources available for other calls,
# may need to retry or add a sleep 60 (or unit of seconds of your choice)
set -e

LOCATION=westus2

# test for resource existance, don't make if it does
GROUP_EXISTS=$(az group exists --name ${RESOURCE_GROUP_NAME})
if [ ${GROUP_EXISTS} == true ]; then
  echo "Resource ${RESOURCE_GROUP_NAME} is already present, not creating resources"
else
  echo "Going to create resources under ${RESOURCE_GROUP_NAME}"
  az group create --name ${RESOURCE_GROUP_NAME} --location ${LOCATION}
  # make storage account to hold function app
  az storage account create --name ${FUNC_STORAGE_NAME} --location ${LOCATION} --resource-group ${RESOURCE_GROUP_NAME} --sku Standard_LRS
  # make the function app. Will nuke the contents of existing app if one is present
  az functionapp create --resource-group ${RESOURCE_GROUP_NAME} --consumption-plan-location ${LOCATION} --name ${FULL_APP_NAME} --storage-account ${FUNC_STORAGE_NAME}
  # make function app use node 8
  az functionapp config appsettings set --name ${FULL_APP_NAME} \
    --resource-group ${RESOURCE_GROUP_NAME} \
    --settings WEBSITE_NODE_DEFAULT_VERSION=8.11.1 \
    FUNCTIONS_EXTENSION_VERSION="~2"
  # and enable msi on the empty function app so it can use key vault (still needs to be connected to key vault manually)
  az webapp identity assign --name ${FULL_APP_NAME} --resource-group ${RESOURCE_GROUP_NAME}
  echo "Made the resources and created empty function app for ${FULL_APP_NAME}"
fi