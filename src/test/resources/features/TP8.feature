@Sample
Feature: Low Code Clockify

  Background:
    Given base url $(env.base_url)
    And header x-api-key = $(env.xapikey)

#CAMINO FELIZ Endpoint /projects

  @GetWorkspace
  Scenario: Get all my Workspaces
    And endpoint /v1/workspaces
    When execute method GET
    Then the status code should be 200
    And response should be [4].name = Workspace create by API
    * define workspaceId = response[4].id

  @AddProject
  Scenario Outline: Add a new project
    And call TP8.feature@GetWorkspace
    And endpoint /v1/workspaces/{{workspaceId}}/projects
    And header Content-Type = application/json
    And set value <nameProject> of key name in body /jsons/bodies/AddElement.json
    When execute method POST
    Then the status code should be 201
    * define proyectoId = response.id
    * define proyectoNombre = response.name
    Examples:
      | nameProject               |
      | New Project create by API |

  @GetProject
  Scenario: Find project by id
    And call TP8.feature@AddProject
    And endpoint /v1/workspaces/{{workspaceId}}/projects/{{proyectoId}}
    When execute method GET
    Then the status code should be 200
    And response should be name = New Project create by API
   # And response should be name = proyectoNombre

  @UpdateProject
  Scenario Outline: Update project to deactivate
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
    And call TP8.feature@UpdateProject
    And endpoint /v1/workspaces/{{workspaceId}}/projects/{{proyectoId}}
    When execute method DELETE
    Then the status code should be 200
    And response should be name = Proyecto Desactivado por API

#CASOS DE ERROR Endpoint /projects
#  •	No Autorizado (Status Code 401)

#  •	Proyecto no encontrado (Status Code 404)

#  •	Bad Request (Status Code 400)
  @GetProject400 @Do
  Scenario: Find a project in-existent in one workspace especificate
    And endpoint /v1/workspaces/6617122bc1fa070824829969/projects/664bf18c3880ba14b5303864
    When execute method GET
    Then the status code should be 400