@Sample
Feature: Low Code Clockify

  Background:
    Given base url $(env.base_url)
    And header x-api-key = $(env.xapikey)

  @GetWorkspace
  Scenario: Get all my Workspaces
    And endpoint /v1/workspaces
    When execute method GET
    Then the status code should be 200
    And response should be [4].name = Workspace create by API
    * define workspaceId = response[4].id

  @AddProject
  Scenario Outline: Add a new project
    And call Project.feature@GetWorkspace
    And endpoint /v1/workspaces/{{workspaceId}}/projects
    And header Content-Type = application/json
    And set value <nameProject> of key name in body /jsons/bodies/AddElement.json
    When execute method POST
    Then the status code should be 201

    Examples:
      | nameProject                          |
      | Projecte create by API 20240520-1548 |

  #@AddProject2
  #Scenario: Add a new project with dynamic Name
  #  And call Project.feature@GetWorkspace
  #  And endpoint /v1/workspaces/{{workspaceId}}/projects
  #  And header Content-Type = application/json
  #  And set value ProjectService.setProjectName() of key name in body /jsons/bodies/AddElement.json
  #  When execute method POST
  #  Then the status code should be 201

  @GetProject
  Scenario Outline: Find project by id
    And call Project.feature@GetWorkspace
    And endpoint /v1/workspaces/{{workspaceId}}/projects/<projectId>
    When execute method GET
    Then the status code should be 200
    And response should be name = <projectName>
    * define proyectoId = response.id

    Examples:
      | projectId               | projectName              |
      | 664260f8772ce2282cff049d | Project create by API 01 |

  @UpdateProject
  Scenario Outline: Update project to deactivate
    And call Project.feature@GetWorkspace
    And call Project.feature@GetProject
    And endpoint /v1/workspaces/{{workspaceId}}/projects/{{proyectoId}}
    And header Content-Type = application/json
    When execute method PUT
    And set value <namePJ> of key name in body /jsons/bodies/PutElement.json
    Then the status code should be 200
    And response should be name = <projectName>
    * define workspaceId = response.id

    Examples:
      | namePJ                  |
      | Proyecto Desactivado por API |