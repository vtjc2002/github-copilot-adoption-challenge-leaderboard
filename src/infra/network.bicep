param appName string
param location string


var subnetConfigs = [
  {
    name: 'appsvc'
    addressPrefix: '10.10.1.0/24'
    delegations: [
      {
        name: 'delegation'
        properties: {
          serviceName: 'Microsoft.Web/serverFarms'
        }
      }
    ]
  }
  {
    name: 'db'
    addressPrefix: '10.10.2.0/24'
    delegations: []
  }
  {
    name: 'webapp-pe'
    addressPrefix: '10.10.3.0/24'
    delegations: []
  }
  {
    name: 'keyvault-pe'
    addressPrefix: '10.10.4.0/24'
    delegations: []
  }
]


resource nsgs 'Microsoft.Network/networkSecurityGroups@2022-09-01' = [for subnet in subnetConfigs: {
  name: '${appName}-${subnet.name}-nsg'
  location: location
  properties: {
    securityRules: []
  }
}]

resource vnet 'Microsoft.Network/virtualNetworks@2022-07-01' = {
  name: '${appName}-vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [ '10.10.0.0/16' ]
    }
    subnets: [for (subnet, i) in subnetConfigs: {
      name: subnet.name
      properties: union({
        addressPrefix: subnet.addressPrefix
        networkSecurityGroup: {
          id: nsgs[i].id
        }
      },
        length(subnet.delegations) > 0 ? { delegations: subnet.delegations } : {}
      )
    }]
  }
}


output vnetId string = vnet.id
output subnets array = vnet.properties.subnets
