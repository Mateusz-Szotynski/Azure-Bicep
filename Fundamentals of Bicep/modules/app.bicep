@description('The Azure location into which the resources should be deployed')
param location string

@description('The name of the App Service app')
param appServiceAppName string

@description('The name of the App Service plan')
param appServicePlanName string

@description('The name of the App Service plan SKU')
param appServicePlanSkuName string

resource appServicePlan 'Microsoft.Web/serverfarms@2023-01-01' ={
  name: appServicePlanName
  location: location
  sku:{
    name: appServicePlanSkuName
  }
}

resource appServiceApp 'Microsoft.Web/sites@2023-01-01' = {
  name: appServiceAppName
  location: location
  properties:{
    serverFarmId: appServicePlan.id
    httpsOnly: true
  }
}


output appServiceHostName string = appServiceApp.properties.defaultHostName
