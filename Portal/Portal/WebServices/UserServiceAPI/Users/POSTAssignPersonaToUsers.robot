*** Settings ***
Library  String
Library  Collections
Library  otr_robot_lib.ws.RestAPI.RestAPIService
Library  otr_robot_lib.ws.UserServiceAPI.UserAPIService
Resource  otr_robot_lib/robot/APIKeywords.robot

Documentation  This is to test the UserService API to assign persona to a user (currently only works in dit because okta service is set up there)
Force Tags     userServiceAPI  API  ditOnly

*** Test Cases ***
POST Assign Persona to a User
    [Documentation]  Test the successful scenario to POST Assign Persona to User
    [Tags]   PI:14  JIRA:O5SA-329   qTest:303021494
    [Setup]  Genetare Data for Request
    Create My User  carrier_manager  with_data=N  legacy_user=Y
    POST Request to Assign Persona  ${auto_user_id}  ${payload}
    Validate The Result  ${status}  SUCCESS
    [Teardown]  Remove Automation User


POST Assign Persona to a Invalid User
    [Documentation]  Test the error scenario to POST Assign Persona to User
    [Tags]   PI:14  JIRA:O5SA-329  qTest:303021494
    [Setup]  Genetare Data for Request
    Create My User  carrier_manager  with_data=N  legacy_user=Y
    POST Request to Assign Persona  12345  ${payload}
    Validate The Result  ${status}  INVALID
    [Teardown]  Remove Automation User


POST Assign Persona to a Empty User
    [Documentation]  Test the error scenario to POST Assign Persona to User
    [Tags]   PI:14  JIRA:O5SA-329  qTest:303021494
    [Setup]  Genetare Data for Request
    Create My User  carrier_manager  with_data=N  legacy_user=Y
    POST Request to Assign Persona  ${EMPTY}   ${payload}
    Validate The Result  ${status}  EMPTY
    [Teardown]  Remove Automation User


POST Assign Persona to a User with Empty Paylod
    [Documentation]  Test the error scenario to POST Assign Persona to User
    [Tags]   PI:14  JIRA:O5SA-329   qTest:303021494
    [Setup]  Genetare Data for Request
    Create My User  carrier_manager  with_data=N  legacy_user=Y
    POST Request to Assign Persona  ${auto_user_id}  ${EMPTY}
    Validate The Result  ${status}  EMPTY
    [Teardown]  Remove Automation User


*** Keywords ***
Genetare Data for Request
    [Documentation]  Create a user and get data to be used in request
    ${persona_assignment}  Find a Persona to be assigned
    Set Suite Variable   ${persona_assignment}
    ${payload}  Create Dictionary   persona_name=${persona_assignment}[name]
    Set Test Variable  ${payload}


Find a Persona to be assigned
        Get Into DB  postgrespgusers
            ${pg}  Catenate  select persona.name, id from persona limit 1;
            ${query}  Query And Strip To Dictionary  ${pg}
            Disconnect From Database
        [Return]  ${query}

POST Request to Assign Persona
    [Documentation]    request to assign persona to a user
    [Arguments]  ${user_id}=${auto_user_id}  ${payload}=${payload}  ${persona}=${NONE}  ${change_secure}=Y  ${username}=${EMPTY}  ${password}=${EMPTY}

    ${headers}  Create Dictionary  content-type=application/json
    ${status}  ${result}  Assign Persona To User  ${user_id}  ${persona}  ${change_secure}  ${username}  ${password}  payload=${payload}


    Set Test Variable  ${status}
    Set Test Variable  ${result}


Validate The Result
    [Documentation]  Find the carriers of a User and compares with the list
    [Arguments]  ${status}   ${type}

        IF  '${status}'=='200'
            Get Into DB  postgrespgusers
            ${pg_query}  Catenate  select persona.name from persona inner join otr_user on otr_user.persona_id = persona.id  where otr_user.id = '${auto_user_id}';
            ${query_results}  Query And Return Dictionary Rows  ${pg_query}

            Disconnect From Database
            Set Test Variable  ${query_results}
            ${query_results}  Evaluate  [str(d['name']) for d in ${query_results}]

            Should Be Equal As Strings  ${status}  200

          ELSE IF  '${status}'=='400'

                IF  '${type}'=='INVALID'
                Should Be Equal             ${result['error_code']}          NOT_FOUND_USER
                Should Be Equal             ${result['name']}                NOT_FOUND_USER
                Should Be Equal As Strings  ${status}  400

                ELSE
                Log To Console    ${result}
                Should Be Equal As Strings  ${status}  400
                END

          ELSE IF  '${status}'=='401'
                Should Be Equal As Strings  ${status}  401

        ELSE
            Fail   ${status} not implemented
        END