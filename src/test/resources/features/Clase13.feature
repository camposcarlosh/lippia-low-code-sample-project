@EjemploClaseNro_13
Feature: Low Code Clockify
#para ejecutarlo:
# mvn clean test -Dcucumber.tags=@Do -Denvironment=default_clase13
  @AddWorkspace
  Scenario Outline: Add Workspace
    Given base url https://api.clockify.me/api
    And endpoint /v1/workspaces
    And header Content-Type = application/json
    And header x-api-key = ZGNkNmU0MTctMjc3My00YjY4LTkzZGEtZDU4YzgwYjM0ZjBk
    And set value <nameWorkspace> of key name in body /jsons/bodies/TP8_AddWs.json
    When execute method POST
    Then the status code should be 201

    Examples:
      | nameWorkspace                         |
      | Workspace create by API 20240518-0940 |


#defino las varialbles de entorno en el arnchivo lippia.conf
  @AddWorkspaceVariableEntorno
  Scenario Outline: Add Workspace with variable
    Given base url $(env.base_url)
    And endpoint /v1/workspaces
    And header Content-Type = application/json
    And header x-api-key = $(env.x-api-key)
    And set value <nameWorkspace> of key name in body /jsons/bodies/AddWs.json
    When execute method POST
    Then the status code should be 201

    Examples:
      | nameWorkspace                         |
      | Workspace create by API 20240518-0940 |

  @GetWorkspace
  Scenario: Get all my Workspaces
    Given base url $(env.base_url)
    And endpoint /v1/workspaces
    #And header x-api-key = $(env.x-api-key)
    And header x-api-key = ZGNkNmU0MTctMjc3My00YjY4LTkzZGEtZDU4YzgwYjM0ZjBk
    When execute method GET
    Then the status code should be 200
    And response should be [7].name = Workspace create by API 20240518-0940
    * define espacioDeTrabajo = response[7].id

#con response o $. me trae el ultimo response ejecutado
#    * define espacioDeTrabajo = $.id

  #Caso 1 - Necesito tener el id del ws entonces copio los pasos de la prueba anterior como parte de la condicion
  @GetClientWorkspace1
  Scenario: Get all client from a Workspaces
    #caso anterior como pre condición
    Given base url https://api.clockify.me/api
    And endpoint /v1/workspaces
    And header x-api-key = ZGNkNmU0MTctMjc3My00YjY4LTkzZGEtZDU4YzgwYjM0ZjBk
    And execute method GET
    And the status code should be 200
    And response should be [7].name = Workspace create by API 20240518-0940
    * define espacioDeTrabajo = response[7].id
    #condiciones del caso actual
    And base url https://api.clockify.me/api
    And endpoint /v1/workspaces/{{espacioDeTrabajo}}/clients/
    And header x-api-key = ZGNkNmU0MTctMjc3My00YjY4LTkzZGEtZDU4YzgwYjM0ZjBk
    When execute method GET
    Then the status code should be 200

  #Caso 1 - Reutiliando los casos de prueba los pasos de la prueba anterior como parte de la condicion
  @GetClientWorkspace2
  Scenario: Get all client from a Workspaces with CALL
    #caso anterior como pre condición
    Given call Clase13.feature@GetWorkspace
    #condiciones del caso actual
    #Nombre del feature @ tag del escenario a llamar
    And base url $(env.base_url)
    And endpoint /v1/workspaces/{{espacioDeTrabajo}}/clients/
    #And header x-api-key = $(env.x-api-key)
    And header x-api-key = ZGNkNmU0MTctMjc3My00YjY4LTkzZGEtZDU4YzgwYjM0ZjBk
    When execute method GET
    Then the status code should be 200
    * define idCliente = response[0].id

  @AddClientWorkspace
  Scenario: Add client from a Workspaces
    Given call Clase13.feature@GetWorkspace
    And base url $(env.base_url)
    And endpoint /v1/workspaces/{{espacioDeTrabajo}}/clients/
    #And header x-api-key = $(env.x-api-key)
    And header x-api-key = ZGNkNmU0MTctMjc3My00YjY4LTkzZGEtZDU4YzgwYjM0ZjBk
    And header Content-Type = application/json
    And set value NuevoClienteForAPI of key name in body /jsons/bodies/AddClient.json
    When execute method POST
    Then the status code should be 201

  @DeleteClientWorkspace @Do
  Scenario: Delete client from a Workspaces
    Given call Clase13.feature@GetClientWorkspace2
    And base url $(env.base_url)
    And endpoint /v1/workspaces/{{espacioDeTrabajo}}/clients/{{idCliente}}
    #And header x-api-key = $(env.x-api-key)
    And header x-api-key = ZGNkNmU0MTctMjc3My00YjY4LTkzZGEtZDU4YzgwYjM0ZjBk
    And header Content-Type = application/json
    And set value NuevoClienteForAPI of key name in body /jsons/bodies/AddClient.json
    When execute method DELETE
    Then the status code should be 200