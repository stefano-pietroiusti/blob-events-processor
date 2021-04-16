# File Manager Processor

* When customer upload file to blob storage triggers Azure Function to scan the virus
* Scheduled Azure Function to check the virus scan report every 5 minutes

## Tech Stacks
* Azure Function App
* Azure Blob Storage
* Azure CosmosDB
* Azure Application Insight (monitoring)
* OPSWAT Metadefender API

## Azure Magic Notes
host.json: https://docs.microsoft.com/en-us/azure/azure-functions/functions-host-json
function.json/layout/bin: https://docs.microsoft.com/en-us/azure/azure-functions/functions-reference-node#folder-structure

## Error Codes Reference
[master source](https://bitbucket.org/accordogroup/file-manager/src/master/src/exceptions/errorCodes.js?at=master&fileviewer=file-view-default)

## API Documentation
[swagger](https://bitbucket.org/accordogroup/file-manager/src/master/docs/swagger.yml?at=master&fileviewer=file-view-default)

## Get Started
```
npm i
npm run lint
npm t
```

## Build 

**Run on build server**  
Bitbucket Pipeline build (bitbucket-pipelines.yml), when commit pushes to origin it triggers the build

## Deploy
All very first deployments to a new environment will need someone to go to Azure and install the binding extensions on at least one of the functions created and then redeploy in order for the triggers to work. Install by deleting existing trigger, remaking the trigger and clicking on the install link that appears.

Azure deployment creates new resource group per environment and one function per trigger type.

**Run feature branch on dev build server**  
Bitbucket Pipeline custom deploy-to-dev

* go to Bitbucket Branches page
* click the "..." on the right side of the feature branch you want to deploy
* select "Run pipeline for branch"
* select custom: deploy-to-dev

** this will deploy your feature branch in DEV

## Test
`npm test`

### Unit Test
`npm run test:unit`

### Component Test
`npm run test:component`