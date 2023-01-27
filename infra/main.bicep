targetScope = 'subscription'
@minLength(1)
@maxLength(64)
@description('Name of the the environment which is used to generate a short unique hash used in all resources.')
param environmentName string
@minLength(1)
@description('Primary location for all resources')
param location string = 'eastus'
param appServicePlanName string = ''
param webServiceName string = ''
// serviceName is used as value for the tag (azd-service-name) azd uses to identify
param serviceName string = 'web'

//@description('Id of the user or app to assign application roles')
//param principalId string = ''
var abbrs = loadJsonContent('./abbreviations.json')
var resourceToken = toLower(uniqueString(subscription().id, environmentName, location))
var tags = { 'azd-env-name': environmentName }

// Organize resources in a resource group
resource hubrg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'petstore_AZD_eastus'
  location: location
  tags: {env: 'dev', dept: 'jbosseap'}
}

module hub_networking './bicep/modules/hub_network.bicep' = {
  name: 'petstore_AZD_eastus'
  scope: hubrg
  params: {
    hubVnetName: 'petstore_AZD_vnet'
    hubVnetAddressPrefix: '10.0.0.0/16'
    tags: {env: 'dev', dept: 'jbosseap'}
    azFwSubnetCidr: '10.0.0.0/26'
    bastionSubnetCidr: '10.0.0.64/26'
    jumpboxSubnetName: 'jumpbox-subnet'
    jumpboxSubnetCidr: '10.0.1.0/24'
    location: location
    }
}

module deploy_firewall './bicep/modules/firewall.bicep' = {
  name: 'firewall'
  scope: hubrg
  params: {
    fw_pip_name: 'aro-fw-pip'
    fw_pip_sku_type: 'Standard'
    fw_pip_tier_name: 'Regional'
    azfw_name: 'aro-fw'
    azfw_sku_name: 'AZFW_VNet'
    azfw_sku_tier: 'Standard'
    azfw_threat_intel_mode: 'Alert'
    azfw_enable_dns: 'true'
    location: location
    hubVnetName: 'petstore_AZD_vnet'
    fwPrivateIP: '10.0.0.4'
  }
}

module deploy_bastion './bicep/modules/bastion.bicep' = {
  name: 'bastion-service'
  scope: hubrg
  params: {
    bastion_ip_name: 'bastion-ip'
    bastion_service_name: 'bastion-service'
    hubVnetName: 'petstore_AZD_vnet'
    location: location
    }
  }
  

// The application workload
module web './bicep/modules/appservice.bicep' = {
  name: 'azd-service-name'
  scope: hubrg
  params: {
    name: !empty(webServiceName) ? webServiceName : '${abbrs.webSitesAppService}web-${resourceToken}'
    location: location
    tags: union(tags, { 'azd-service-name': serviceName })
    appServicePlanId: appServicePlan.outputs.id
    runtimeName: 'java'
    runtimeVersion: '11'
  }
}

// Create an App Service Plan to group applications under the same payment plan and SKU
module appServicePlan './bicep/modules/appserviceplan.bicep' = {
  name: 'appserviceplan'
  scope: hubrg
  params: {
    name: !empty(appServicePlanName) ? appServicePlanName : '${abbrs.webServerFarms}${resourceToken}'
    location: location
    tags: {env: 'dev', dept: 'jbosseap'}
    sku: {
      name: 'P1v3'
    }
  }
 }
 
// App outputs
output AZURE_LOCATION string = location
output AZURE_TENANT_ID string = tenant().tenantId
output JBOSS_EAP_WEB_BASE_URL string = web.outputs.uri
