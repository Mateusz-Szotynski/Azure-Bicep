param location string = 'westeurope'

@secure()
param sqlServerAdminLogin string

@secure()
param sqlServerAdminPassword string

param sqlServerDbSku object


var sqlServerName = 'sqlServer-${uniqueString(resourceGroup().id)}'
var sqlServerDatabaseName = 'sqlDb${uniqueString(resourceGroup().id)}'

resource sqlServer 'Microsoft.Sql/servers@2023-05-01-preview' = {
  name: sqlServerName
  location: location
  properties: {
    administratorLogin: sqlServerAdminLogin
    administratorLoginPassword: sqlServerAdminPassword
  }
}

resource sqlServerDatabase 'Microsoft.Sql/servers/databases@2023-05-01-preview' = {
  parent: sqlServer
  name: sqlServerDatabaseName
  location: location
  sku: sqlServerDbSku
}
