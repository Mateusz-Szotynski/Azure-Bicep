param location string = 'westeurope'

resource vnet 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: 'vnet01'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'subnet01'
        properties: {
          addressPrefix: '10.0.1.0/24'
        }
      }
      {
        name: 'subnet02'
        properties: {
          addressPrefix: '10.0.2.0/24'
        }
      }
    ]
  }
}
