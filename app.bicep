param environmentType string
param location string

var appServicePlanName = 'toy-product-launch-plan}'
var appServiceAppName = 'toy-launch${uniqueString(resourceGroup().id)}'

var appServicePlanSkuName = (environmentType == 'prod') ? 'P2v3' : 'F1'

resource appServicePlan 'Microsoft.Web/serverfarms@2023-01-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: appServicePlanSkuName
  }
}

resource appServiceApp 'Microsoft.Web/sites@2023-01-01' = {
  name: appServiceAppName
  location: location
  properties: {
    httpsOnly: true
    serverFarmId: appServicePlan.id
  }
}

output appServiceAppHostName string = appServiceApp.properties.defaultHostName
