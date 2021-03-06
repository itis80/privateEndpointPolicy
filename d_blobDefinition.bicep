targetScope = 'managementGroup'

// PARAMETERS

// VARIABLES

// OUTPUTS
output blobPolicyID string = blobPrivateDNS.id

// RESOURCES

resource blobPrivateDNS 'Microsoft.Authorization/policyDefinitions@2018-05-01' = {
  name: 'blobPrivateDNS'
  properties: {
    policyType: 'Custom'
    mode: 'All'
    displayName: 'Create Storage Account Private Endpoint DNS-record'
    description: 'Creates Storage Account Private Endpoint DNS record to Private DNS Zone automatically'
    parameters: {
      privateDnsZoneId: {
        type: 'String'
        metadata: {
          displayName: 'privateDnsZoneId'
          description: null
          strongType: 'Microsoft.Network/privateDnsZones'
        }
      }
    }
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            equals: 'Microsoft.Network/privateEndpoints'
          }
          {
            count: {
              field: 'Microsoft.Network/privateEndpoints/privateLinkServiceConnections[*].groupIds[*]'
              where: {
                field: 'Microsoft.Network/privateEndpoints/privateLinkServiceConnections[*].groupIds[*]'
                equals: 'blob'
              }
            }
            greaterOrEquals: 1
          }
        ]
      }
      then: {
        effect: 'deployIfNotExists'
        details: {
          type: 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups'
          roleDefinitionIds: [
            '/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c'
          ]
          existenceCondition: {
            allOf: [
              {
                field: 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups/privateDnsZoneConfigs[*].privateDnsZoneId'
                equals: '[parameters(\'privateDnsZoneId\')]'
              }
            ]
          }
          deployment: {
            properties: {
              mode: 'incremental'
              template: {
                '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
                contentVersion: '1.0.0.0'
                parameters: {
                  privateDnsZoneId: {
                    type: 'string'
                  }
                  privateEndpointName: {
                    type: 'string'
                  }
                  location: {
                    type: 'string'
                  }
                }
                resources: [
                  {
                    name: '[concat(parameters(\'privateEndpointName\'), \'/deployedByPolicy\')]'
                    type: 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups'
                    apiVersion: '2020-03-01'
                    location: '[parameters(\'location\')]'
                    properties: {
                      privateDnsZoneConfigs: [
                        {
                          name: 'storageBlob-privateDnsZone'
                          properties: {
                            privateDnsZoneId: '[parameters(\'privateDnsZoneId\')]'
                          }
                        }
                      ]
                    }
                  }
                ]
              }
              parameters: {
                privateDnsZoneId: {
                  value: '[parameters(\'privateDnsZoneId\')]'
                }
                privateEndpointName: {
                  value: '[field(\'name\')]'
                }
                location: {
                  value: '[field(\'location\')]'
                }
              }
            }
          }
        }
      }
    }
  }
}
