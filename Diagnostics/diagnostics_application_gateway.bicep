targetScope = 'managementGroup'

output policyName string =  diagnosticSettingsResource.name
output policyId string = diagnosticSettingsResource.id

resource diagnosticSettingsResource 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: 'diagnosticsSettingsApplicationGateway'
  properties: {
    displayName: 'Enable Diagnostic Settings for Application Gateway - Log Analytics'
    description: 'Apply diagnostic settings for Azure Application Gateway to send data to central Log Analytics workspace'
    parameters: {
      logAnalytics: {
        type: 'String'
      }
      metricsEnabled:{
        type: 'String'
        defaultValue: 'true'
        allowedValues: [
          'true'
          'false'
        ]
      }
      ApplicationGatewayAccessLog:{
        type: 'String'
        defaultValue: 'true'
        allowedValues: [
          'true'
          'false'
        ]
      }
      ApplicationGatewayPerformanceLog:{
        type: 'String'
        defaultValue: 'true'
        allowedValues: [
          'true'
          'false'
        ]
      }
      ApplicationGatewayFirewallLog:{
        type: 'String'
        defaultValue: 'true'
        allowedValues: [
          'true'
          'false'
        ]
      }
    }
    policyRule: {
      if: {
        field: 'type'
        equals: 'Microsoft.Network/applicationGateways'
      }
      then: {
        effect: 'deployIfNotExists'
        details: {
          type: 'Microsoft.Insights/diagnosticSettings'
          roleDefinitionIds: [
            '/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c'
          ]
          existenceCondition: {
            allOf: [
              {
                field: 'Microsoft.Insights/diagnosticSettings/metrics.enabled'
                equals: '[parameters(\'metricsEnabled\')]'
              }
              {
                field: 'Microsoft.Insights/diagnosticSettings/logs.enabled'
                in: [
                  '[parameters(\'ApplicationGatewayFirewallLog\')]'
                  '[parameters(\'ApplicationGatewayPerformanceLog\')]'
                  '[parameters(\'ApplicationGatewayFirewallLog\')]'
                ]
              }
              {
                field: 'Microsoft.Insights/diagnosticSettings/workspaceId'
                matchInsensitively: '[parameters(\'logAnalytics\')]'
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
                  resourceName: {
                    type: 'string'
                  }
                  logAnalytics: {
                    type: 'string'
                  }
                  location: {
                    type: 'string'
                  }
                  metricsEnabled:{
                    type: 'string'
                  }
                  ApplicationGatewayAccessLog: {
                    type: 'string'
                  }
                  ApplicationGatewayPerformanceLog: {
                    type: 'string'
                  }
                  ApplicationGatewayFirewallLog: {
                    type: 'string'
                  }
                }
                variables: {}
                resources: [
                  {
                    type: 'Microsoft.Network/applicationGateways/providers/diagnosticSettings'
                    apiVersion: '2017-05-01-preview'
                    name: '[concat(parameters(\'resourceName\'), \'/\', \'Microsoft.Insights/setByPolicy\')]'
                    location: '[parameters(\'location\')]'
                    dependsOn: []
                    properties: {
                      workspaceId: '[parameters(\'logAnalytics\')]'
                      metrics: [
                        {
                          category: 'AllMetrics'
                          enabled: '[parameters(\'metricsEnabled\')]'
                          retentionPolicy: {
                            days: 0
                            enabled: false
                          }
                          timeGrain: null
                        }
                      ]
                      logs: [
                        {
                          category: 'ApplicationGatewayAccessLog'
                          enabled: '[parameters(\'ApplicationGatewayAccessLog\')]'
                        }
                        {
                          category: 'ApplicationGatewayPerformanceLog'
                          enabled: '[parameters(\'ApplicationGatewayPerformanceLog\')]'
                        }
                        {
                          category: 'ApplicationGatewayFirewallLog'
                          enabled: '[parameters(\'ApplicationGatewayFirewallLog\')]'
                        }
                      ]
                    }
                  }
                ]
                outputs: {}
              }
              parameters: {
                logAnalytics: {
                  value: '[parameters(\'logAnalytics\')]'
                }
                location: {
                  value: '[field(\'location\')]'
                }
                resourceName: {
                  value: '[field(\'name\')]'
                }
                metricsEnabled:{
                  value: '[parameters(\'metricsEnabled\')]'
                }
                ApplicationGatewayAccessLog:{
                  value: '[parameters(\'ApplicationGatewayAccessLog\')]'
                }
                ApplicationGatewayPerformanceLog:{
                  value: '[parameters(\'ApplicationGatewayPerformanceLog\')]'
                }
                ApplicationGatewayFirewallLog: {
                  value: '[parameters(\'ApplicationGatewayFirewallLog\')]'
                }
              }
            }
          }
        }
      }
    }
  }
}
