targetScope = 'managementGroup'

// PARAMETERS
param policySource string = 'Github repository '
param policyCategory string = 'Custom'
param blobZoneId string = ''
param postgreSqlDnsZoneId string = ''
param assignmentEnforcementMode string = 'Default'
param assignmentIdentityLocation string = 'westeurope'
param managementGroupId string = ''
param resourceGroupId string = ''
param subscriptionId string = ''

output miID string = assignments.outputs.assignmentMiID

// RESOURCES

module blobDefinition './d_blobDefinition.bicep' = {
  name: 'blobDefinition'
  params: {}
}

module postgreDefinition 'postgreSqlDefinition-po-de.bicep' = {
  name: 'postgreDefinition'
  params: {}
}

module initiatives './i_privateDNS.bicep' = {
  name: 'initiatives'
  params: {
    policySource: policySource
    managementGroupId: managementGroupId
    policyCategory: policyCategory
    blobPolicyId: blobDefinition.outputs.blobPolicyID
    postgrePolicyId: postgreDefinition.outputs.postgreSqlPolicyId
  }
}

 module assignments './a_privateDNS.bicep' = {
  name: 'assignments'
  params: {
   policySource: policySource
   managementGroupId: managementGroupId
   policyCategory: policyCategory
   assignmentIdentityLocation: assignmentIdentityLocation
   assignmentEnforcementMode: assignmentEnforcementMode
   blobZoneId: blobZoneId
   postgreZoneId: postgreSqlDnsZoneId
   initiativeID: initiatives.outputs.initiativeID

 }
}

module roleassignMg './a_privateDNS_MgRole.bicep' = {
  name: 'roleassign'
  scope: managementGroup()
  params: {
   assignmentMiID: assignments.outputs.assignmentMiID
 }
}

module roleassignDns './a_privateDNS_role.bicep' = {
  name: 'roleassign'
  scope: resourceGroup(subscriptionId, resourceGroupId)
  params: {
   assignmentMiID: assignments.outputs.assignmentMiID
 }
}
