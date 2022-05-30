targetScope = 'managementGroup'

//PARAMETERS

param actions array = [
  'Microsoft.Resources/deployments/*'
  'Microsoft.Network/privateEndpoints/privateDnsZoneGroups/write'
  'Microsoft.Network/privateEndpoints/privateDnsZoneGroups/read'
]
param managementGroupId string = 'Management-Mg'


param notActions array = []
param roleDescription string = 'Enable Private DNS record Policy Assignment remediations'
param roleDefName string = 'dns-policy-remediation'

//VARIABLES

//OUTPUTS

output roleIdGuid string = roleDef.id 

var roleId = guid('dns-policy-remediation')

//RESOURCES

resource roleDef 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' = {
  name: roleId
  properties: {
    roleName: roleDefName
    description: roleDescription
    type: 'customRole'
    permissions: [
      {
        actions: actions
        notActions: notActions
      }
    ]
    assignableScopes: [
      '/providers/Microsoft.Management/managementgroups/${managementGroupId}'
    ]
  }
}
