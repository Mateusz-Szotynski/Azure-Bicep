param location string = 'westeurope'
param tenantId string = '97d6536d-49da-4c2a-8fdb-882ffec9e5bf'
param objectId string = 'e72b4921-c780-4e89-b608-5e87bf0a5275'

var keyVaultName = 'KV-${uniqueString(resourceGroup().id)}'
var keyVaultSku = {
  family: 'A'
  name: 'standard'
}


resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: keyVaultName
  location: location
  properties: {
    accessPolicies: [
      {
        objectId: objectId
        permissions: {
          certificates:[
            'all'
          ]
          keys: [
            'all'
          ]
          secrets: [
            'all'
          ]
          storage: [
            'all'
          ]
        }
        tenantId: tenantId
      }
    ]
    sku: keyVaultSku
    tenantId: tenantId
    enabledForTemplateDeployment: true
  }
}
