targetScope = 'managementGroup'

// PARAMETERS
param policySource string
param policyCategory string
param managementGroupId string
param assignmentIdentityLocation string
param assignmentEnforcementMode string
param initiativeID string 
param blobZoneId string
param postgreZoneId string

// VARIABLES
var assignmentName = 'PrivateDNSEnforce'
var defInitiativeId = '/providers/Microsoft.Management/managementGroups/${managementGroupId}/providers/${initiativeID}'

// OUTPUTS
output assignmentID string = assignment.id
output assignmentMiID string = reference(resourceId('Microsoft.Authorization/policyAssignments', assignmentName),'2019-01-01', 'Full').identity.principalId



// RESOURCES

resource assignment 'Microsoft.Authorization/policyAssignments@2020-09-01' = {
  
  name: assignmentName
  location: assignmentIdentityLocation
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    displayName: assignmentName
    description: '${assignmentName} via ${policySource}'
    enforcementMode: assignmentEnforcementMode
    metadata: {
      source: policySource
      version: '0.1.0'
    }
    policyDefinitionId: defInitiativeId
    parameters: {
      blobDNSZoneID: {
        value: blobZoneId
      }
      postgreDNSZoneID: {
        value: postgreZoneId
      }
    }
  }
}
