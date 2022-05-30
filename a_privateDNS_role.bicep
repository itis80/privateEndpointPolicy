param roleNameGuid string = guid(resourceGroup().id)
param assignmentMiID string


resource roleAssignment 'Microsoft.Authorization/roleAssignments@2018-01-01-preview' = {
  name: roleNameGuid
  properties: {
    roleDefinitionId: '/providers/Microsoft.Authorization/roleDefinitions/b12aa53e-6015-4669-85d0-8515ebb3ae7f'
    principalId: assignmentMiID
  }
}
