@description('The name of the cosmos db account')
param cosmosDBAccountName string = 'toyrnd-${uniqueString(resourceGroup().id)}'

@description('The throughput in the database')
param cosmosDBDatabaseThroughput int = 400

@description('The Azure region locations where resources have to be deployed')
param location string = resourceGroup().location

@description('The name of the storage account')
param storageAccountName string

@description('The name of the cosmos database')
var cosmosDBDatabaseName = 'FlightTests'

@description('The name of the cosmos database container')
var cosmosDBContainerName = 'FlightTests'

@description('The partition key of the cosmos database container')
var cosmosDBContainerPartitionKey = '/droneId'

@description('The logs analytics workspace name')
var loganalyticsWorkspaceName = 'ToyLogs'

@description('The storage account diagnostic settings name')
var storageAccountBlobDiagnosticSettingsName = 'route-logs-to-log-analytics'

resource cosmosDBAccount 'Microsoft.DocumentDB/databaseAccounts@2023-11-15' = {
  name: cosmosDBAccountName
  location: location
  properties: {
    databaseAccountOfferType: 'Standard'
    locations: [
      {
        locationName: location
      }
    ]
  }
}

resource cosmosDBDatabase 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2023-11-15' = {
  parent:cosmosDBAccount
  name: cosmosDBDatabaseName
  properties: {
    resource: {
      id: cosmosDBDatabaseName
    }
    options:{
      throughput: cosmosDBDatabaseThroughput
    }
  }

  resource container 'containers' = {
    name: cosmosDBContainerName
    properties: {
      resource: {
        id: cosmosDBContainerName
        partitionKey: {
          kind: 'Hash'
          paths: [
            cosmosDBContainerPartitionKey
          ]
        }
      }
    }
  }
}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
  name: loganalyticsWorkspaceName
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' existing = {
  name: storageAccountName

  resource blobService 'blobServices' existing = {
    name: 'default'
  }
}

resource storageAccountBlobDiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  scope: storageAccount::blobService
  name: storageAccountBlobDiagnosticSettingsName
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    logs: [
      {
        category: 'StorageRead'
        enabled:true
      }
      {
        category: 'StorageWrite'
        enabled: true
      }
      {
        category: 'StorageDelete'
        enabled: true
      }
    ]
  }
}
