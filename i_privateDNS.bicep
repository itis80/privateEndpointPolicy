targetScope = 'managementGroup'

// PARAMETERS

// param customPolicyID string
param policySource string
param policyCategory string
param managementGroupId string
param blobPolicyId string
param postgrePolicyId string
// VARIABLES

var policySetName = 'enforcePrivateDns'
var policySetDisplayName = 'Enforce Private DNS record for Private Endpoints'
var policySetDescription = 'This policy initiative enforces the creation of Private Endpoint DNS-records to Private Zone'
var blobPolicydefid = '/providers/Microsoft.Management/managementGroups/${managementGroupId}/providers/${blobPolicyId}'
var postgrePolicydefid = '/providers/Microsoft.Management/managementGroups/${managementGroupId}/providers/${postgrePolicyId}'

// OUTPUTS

output initiativeID string = initiative.id

// RESOURCES

resource initiative 'Microsoft.Authorization/policySetDefinitions@2019-09-01' = {
  name: policySetName
  properties: {
    displayName: policySetDisplayName
    description: policySetDescription
    policyType: 'Custom'
    metadata: {
      category: policyCategory
      source: policySource
    }
    parameters: {
      blobDNSZoneID: {
        type: 'String'
        metadata: {
          displayName: 'BlobDNSZoneID'
          description: 'The ID of Blob Private DNS Zone'
        }
      }
      postgreDNSZoneID: {
        type: 'String'
        metadata: {
          displayName: 'PostgreDNSZoneID'
          description: 'The ID of Blob Private DNS Zone'
        }
      }
    }
    policyDefinitions: [
      {
        policyDefinitionId: blobPolicydefid
        policyDefinitionReferenceId: 'blob_zone'
        parameters: {
          privateDNSZoneID: {
            value: '[parameters(\'blobDNSZoneID\')]'
          }
        }
      }
      {
        policyDefinitionId: postgrePolicydefid
        policyDefinitionReferenceId: 'postgre_zone'
        parameters: {
          privateDNSZoneID: {
            value: '[parameters(\'postgreDNSZoneID\')]'
          }
        }
      }
      
    ]
  }
}
