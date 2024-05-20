@Sample
Feature: Low Code Clockify

  Background:
    Given base url $(env.base_url)
    And header x-api-key = ZGNkNmU0MTctMjc3My00YjY4LTkzZGEtZDU4YzgwYjM0ZjBk


  @AddWorkspace
  Scenario Outline: (ok) Add Workspace
    And endpoint /v1/workspaces
    And header Content-Type = application/json
    And set value <nameWorkspace> of key name in body /jsons/bodies/TP8_AddWs.json
    When execute method POST
    Then the status code should be 201

    Examples:
      | nameWorkspace                         |
      | Workspace create by API 20240518-0940 |

  @GetWorkspace
  Scenario: (ok) Get all my Workspaces
    Given base url https://api.clockify.me/api
    And endpoint /v1/workspaces
    And header x-api-key = ZGNkNmU0MTctMjc3My00YjY4LTkzZGEtZDU4YzgwYjM0ZjBk
    When execute method GET
    Then the status code should be 200
    And response should be [7].name = Workspace create by API 20240518-0940
    * define espacioDeTrabajo = response[7].id

  
