@TP8
Feature: Low Code Clockify

  Background:
    Given base url $(env.base_url)

#CAMINO FELIZ Endpoint /projects

  @GetWorkspace
  Scenario: Get all my Workspaces
    And header x-api-key = $(env.xapikey)
    And endpoint /v1/workspaces
    When execute method GET
    Then the status code should be 200
    And response should be [4].name = Workspace create by API
    * define workspaceId = response[4].id

  @AddProject
  Scenario Outline: Add a new project
    And header x-api-key = $(env.xapikey)
    And call TP8.feature@GetWorkspace
    And endpoint /v1/workspaces/{{workspaceId}}/projects
    And header Content-Type = application/json
    And set value <nameProject> of key name in body /jsons/bodies/AddElement.json
    When execute method POST
    Then the status code should be 201
    * define proyectoId = response.id
    * define proyectoNombre = response.name
    Examples:
      | nameProject           |
      | Project create by API |

  @GetProject
  Scenario: Find project by id
    And header x-api-key = $(env.xapikey)
    And call TP8.feature@AddProject
    And endpoint /v1/workspaces/{{workspaceId}}/projects/{{proyectoId}}
    When execute method GET
    Then the status code should be 200
    And response should be name = Project create by API
   # And response should be name = proyectoNombre

  @UpdateProject
  Scenario Outline: Update project to deactivate
    And header x-api-key = $(env.xapikey)
    And call TP8.feature@GetProject
    And endpoint /v1/workspaces/{{workspaceId}}/projects/{{proyectoId}}
    And header Content-Type = application/json
    And set value <nameProject> of key name in body /jsons/bodies/PutElement.json
    When execute method PUT
    Then the status code should be 200
    And response should be name = Proyecto Desactivado por API

    Examples:
      | nameProject                       |
      | Proyecto Desactivado por API |

  @DeleteProject @Do
  Scenario: Delete project
    And header x-api-key = $(env.xapikey)
    And call TP8.feature@UpdateProject
    And endpoint /v1/workspaces/{{workspaceId}}/projects/{{proyectoId}}
    When execute method DELETE
    Then the status code should be 200
    And response should be name = Proyecto Desactivado por API

#CASOS DE ERROR Endpoint /projects
  #  •	No encontrado (Status Code 404)
  @GetProject404 @Do
  Scenario: Find project by id
    And header x-api-key = $(env.xapikey)
    And endpoint /v1/workspaces{{workspaceId}}/projects/{{proyectoId}}
    When execute method GET
    Then the status code should be 404

#  •	No Autorizado (Status Code 401)
  @GetProject401 @Do
  Scenario: Find a project with invalid api key
    And header x-api-key = $(env.xapikey_fail)
    And endpoint /v1/workspaces/6617122bc1fa070824829969/projects/664bf18c3880ba14b5303864
    When execute method GET
    Then the status code should be 401

#  •	Bad Request (Status Code 400)
  @GetProject400 @Do
  Scenario: Find a project in-existent in one workspace especificate
    And header x-api-key = $(env.xapikey)
    And endpoint /v1/workspaces/6617122bc1fa070824829969/projects/664bf18c3880ba14b5303864
    When execute method GET
    Then the status code should be 400