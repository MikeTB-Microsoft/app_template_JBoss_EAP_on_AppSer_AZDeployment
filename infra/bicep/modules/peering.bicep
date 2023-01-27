@description('Set the local VNet name')
param localVnetName string
@description('Set the remote VNet name')
param remoteVnetName string
@description('Sets the remote VNet Resource group')
param rgToPeerhub string
@description('Sets the remote VNet Resource group')
param rgToPeerspoke string

resource peerhub 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-02-01' = {
  name: '${localVnetName}/peering-to-${remoteVnetName}'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: resourceId(rgToPeerhub, 'Microsoft.Network/virtualNetworks', remoteVnetName)
    }
  }
}

resource peerspoke 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-02-01' = {
  name: '${remoteVnetName}/peering-to-${localVnetName}'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: resourceId(rgToPeerspoke, 'Microsoft.Network/virtualNetworks', localVnetName)
    }
  }
}
