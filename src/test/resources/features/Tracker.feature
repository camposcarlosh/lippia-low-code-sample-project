@Tracker
Feature: Low Code Clockify

  Background:
    Given base url $(env.base_url)
    And header x-api-key = $(env.xapikey)
    And header Content-Type = application/json

  @GetUser
  Scenario: Get currently logged-in user's info
    And endpoint /v1/user
    When execute method GET
    Then the status code should be 200
    And response should be name = Camposcarlosh
    * define userId = response.id

  @GetWorkspace
  Scenario: Get all my Workspaces
    And endpoint /v1/workspaces
    When execute method GET
    Then the status code should be 200
    And response should be [4].name = Workspace create by API
    * define workspaceId = response[4].id

  @GetProject
  Scenario: Get all projects on workspace
    And call Tracker.feature@GetWorkspace
    And endpoint /v1/workspaces/{{workspaceId}}/projects
    When execute method GET
    Then the status code should be 200
    And response should be [1].name = New Project create by API 01
    * define projectId = response[2].id

  @GetTimeEntry @Punto_2a @Do
  Scenario: Get time entries for a user on workspace
    And call Tracker.feature@GetUser
    And call Tracker.feature@GetWorkspace
    And endpoint /v1/workspaces/{{workspaceId}}/user/{{userId}}/time-entries
    When execute method GET
    Then the status code should be 200
    * define entryId = response[-1].id

  @AddTimeEntry @Punto_2b @Do
  Scenario Outline: Add a new time entry
    And call Tracker.feature@GetProject
    And endpoint /v1/workspaces/{{workspaceId}}/time-entries
    And set value <billable> of key billable in body /jsons/bodies/addTimeEntry.json
    And set value <description> of key description in body /jsons/bodies/addTimeEntry.json
    And set value <end> of key end in body /jsons/bodies/addTimeEntry.json
    And set value {{projectId}} of key projectId in body /jsons/bodies/addTimeEntry.json
    And set value <start> of key start in body /jsons/bodies/addTimeEntry.json
    When execute method POST
    Then the status code should be 201
    And response should be description = <description>

    Examples:
      | billable | description                 | end                  | start                |
      | true     | New Time entry description. | 2024-06-04T15:00:00Z | 2024-06-04T14:40:00Z |

  @UpdateTimeEntry @Punto_2c @Do
  Scenario Outline: Update time entry on workspace
    And call Tracker.feature@GetTimeEntry
    And endpoint /v1/workspaces/{{workspaceId}}/time-entries/{{entryId}}
    And set value <billable> of key billable in body /jsons/bodies/updateTimeEntry.json
    And set value <description> of key description in body /jsons/bodies/updateTimeEntry.json
    And set value <start> of key start in body /jsons/bodies/updateTimeEntry.json
    When execute method PUT
    Then the status code should be 200
    And response should be description = <description>

    Examples:
      | billable | description        | start                |
      | true     | Time entry updated | 2024-06-04T14:35:00Z |

  @DeleteTimeEntry @Punto_2d @Do
  Scenario: Delete time entry from workspace
    And call Tracker.feature@GetTimeEntry
    And endpoint /v1/workspaces/{{workspaceId}}/time-entries/{{entryId}}
    When execute method DELETE
    Then the status code should be 204



