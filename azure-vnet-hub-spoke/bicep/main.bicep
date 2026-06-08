param location string = resourceGroup().location

resource hubVnet 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: 'vnet-hub'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'management-subnet'
        properties: {
          addressPrefix: '10.0.1.0/24'
        }
      }
    ]
  }
}

resource spoke1Vnet 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: 'vnet-spoke-app'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.1.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'app-subnet'
        properties: {
          addressPrefix: '10.1.1.0/24'
          networkSecurityGroup: {
            id: appNsg.id
          }
        }
      }
    ]
  }
}

resource spoke2Vnet 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: 'vnet-spoke-db'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.2.0.0/16'
      ]
    }
    subnets: [
      {
        
          name: 'db-subnet'
          properties: {
            addressPrefix: '10.2.1.0/24'
            networkSecurityGroup: {
              id: dbNsg.id
          }
        }
      }
    ]
  }   
}

resource hubtoApp 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-11-01' = {
  name: 'vnet-hub/hub-to-app'
  properties: {
    remoteVirtualNetwork: {
      id: spoke1Vnet.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}

resource apptoHub 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-11-01' = {
  name: 'vnet-spoke-app/app-to-hub'
  properties: {
    remoteVirtualNetwork: {
      id: hubVnet.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}

resource dbtoHub 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-11-01' = {
  name: 'vnet-spoke-db/db-to-hub'
  properties: {
    remoteVirtualNetwork: {
      id: hubVnet.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}

resource hubtoDB 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-11-01' = {
  name: 'vnet-hub/hub-to-db'
  properties: {
    remoteVirtualNetwork: {
      id: spoke2Vnet.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}

resource appNsg 'Microsoft.Network/networkSecurityGroups@2023-11-01' = {
  name: 'nsg-app'
  location: location
  properties: {
    securityRules: []
  }
}

resource dbNsg 'Microsoft.Network/networkSecurityGroups@2023-11-01' = {
  name: 'nsg-db'
  location: location
  properties: {
    securityRules: []
  }
}
