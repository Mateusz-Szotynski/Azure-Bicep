
param locations array = [
  'westus3'
  'westeurope'
  'eastasia'
]

var subnetCount = 2

resource virtualNetworks 'Microsoft.Network/virtualNetworks@2023-06-01' = [for (location, i) in locations: {
  name: 'vnet-${i}'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.${i}.0.0/16'
      ]
    }
    subnets: [for j in range(1,subnetCount): {
      name: 'subnet-${j}'
      properties: {
        addressPrefix: '10.${i}.${j}.0/24'
      }
    }]
  }
}]
