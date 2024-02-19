param location string = 'westeurope'

var storageAccName = 'sa${uniqueString(resourceGroup().id)}'

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' ={
  name: storageAccName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties:{
    accessTier: 'Hot'
    allowBlobPublicAccess: true
    supportsHttpsTrafficOnly: true
  }
}

resource storageService 'Microsoft.Storage/storageAccounts/blobServices@2023-01-01' = {
  parent: storageAccount
  name: 'default'
  properties: {
    automaticSnapshotPolicyEnabled: true
    changeFeed: {
      enabled: true
      retentionInDays: 7
    }
    isVersioningEnabled: true
    lastAccessTimeTrackingPolicy: {
      enable: true
    }
     deleteRetentionPolicy: {
      enabled: true
      days: 7
      allowPermanentDelete: false
     }
    restorePolicy: {
      enabled: true
      days: 3
    }
  }
}

resource storageContainer1 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = {
  parent:storageService
  name: 'container1'
  properties: {
    publicAccess: 'Blob'
  }
}
