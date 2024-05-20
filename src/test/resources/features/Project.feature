@Sample
Feature: Low Code Clockify

  Background:
    Given base url $(env.base_url)
    And header x-api-key = ZGNkNmU0MTctMjc3My00YjY4LTkzZGEtZDU4YzgwYjM0ZjBk

  @GetWorkspace
  Scenario: Get all my Workspaces
    And endpoint /v1/workspaces
    When execute method GET
    Then the status code should be 200
    And response should be [4].name = Workspace create by API
    * define workspaceId = response[4].id

  @AddProject @Do
  Scenario Outline: Add a new project
    And call Project.feature@GetWorkspace
    And endpoint /v1/workspaces/{{workspaceId}}/projects
    And header Content-Type = application/json
    And set value <nameProject> of key name in body /jsons/bodies/AddElement.json
    When execute method POST
    Then the status code should be 201

    Examples:
      | nameProject                          |
      | Projecte create by API 20240519-2236 |