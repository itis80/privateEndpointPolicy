targetScope='managementGroup'

param assignmentMiID string
param roleNameGuid string = guid(assignmentMiID)


resource roleAssignment 'Microsoft.Authorization/roleAssignments@2018-01-01-preview' = {
  name: roleNameGuid
  scope: managementGroup()
  properties: {
    roleDefinitionId: '/providers/Microsoft.Authorization/roleDefinitions/dad099f1-edbf-5c8b-b3b7-45393254d745'
    principalId: assignmentMiID
  }
}
