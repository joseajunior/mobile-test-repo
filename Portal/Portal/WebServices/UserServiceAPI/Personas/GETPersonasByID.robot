*** Settings ***
Library  String
Library  Collections
Library  otr_robot_lib.ws.RestAPI.RestAPIService
Library  otr_robot_lib.ws.UserServiceAPI.UserAPIService
Resource  otr_robot_lib/robot/APIKeywords.robot

Documentation  This is to test the UserService API to get persona by id (currently only works in dit because okta service is set up there)
Force Tags     userServiceAPI  API  ditOnly

*** Test Cases ***
GET Personas By ID
    [Documentation]  Test the successful scenario to GET Persona By ID
    [Tags]   PI:14  JIRA:O5SA-341  qTest:54708171
    [Setup]  Genetare Data for Request   BYID
    Create My User  persona_name=am_admin  with_data=N  legacy_user=Y
    Send GET API Request for Personas BYID
    Compare GET Endpoint Results for Personas BYID
    [Teardown]  Remove Automation User

GET Personas using an Invalid or No Token
    [Tags]  PI:14  JIRA:O5SA-341    qTest:54708171
    GET Personas Error with Invalid or No Token
    [Teardown]  Remove Automation User

GET Personas using a User without permission
    [Tags]  PI:14  JIRA:O5SA-341   qTest:54708171
    GET Personas Error with User without permission
    [Teardown]  Remove Automation User

GET Personas using an Empty Persona ID
    [Tags]  PI:14 JIRA:O5SA-341   qTest:54708171
    GET Personas Error with Empty Persona ID
    [Teardown]  Remove Automation User

GET Personas using an Invalid Persona ID
    [Tags]  PI:14 JIRA:O5SA-341   qTest:54708171
    GET Personas Error with Invalid Persona ID
    [Teardown]  Remove Automation User

*** Keywords ***
Genetare Data for Request
    [Documentation]  Create a user and get data to be used in request
    [Arguments]  ${type}
    Getting API URL
    ${persona_info}  Find a Persona
    Set Suite Variable   ${persona_info}


Getting API URL
    Get URL For Suite   ${UserService}


Send ${request_type} API Request for Personas ${type}
    Send Request  ${request_type.upper()}   ${type}


Compare ${request_type} Endpoint Results for Personas ${type}
    Compare Data for Personas  ${request_type.upper()}  ${type}


Find a Persona
    Get Into DB  postgrespgusers
    ${pg}  Catenate  select persona.name, id from persona limit 1;
    ${query}  Query And Strip To Dictionary  ${pg}
    Disconnect From Database
    [Return]  ${query}


Send Request
    [Arguments]  ${request_type}  ${type}
    Personas  ${request_type} ${type}

Personas
    [Documentation]  Perform the request for Get Personas By Id
    [Arguments]  ${request}  ${persona_id}=${persona_info}[id]   ${secure}=Y

    ${headers}  Create Dictionary  content-type=application/json
    ${url_stuff}  create dictionary  None=${persona_id}

   ${response}  ${status}  API Request  GET  personas  ${secure}  ${url_stuff}  application=OTR_eMgr

    Set Test Variable  ${status}
    Set Test Variable  ${response}


Compare Data for Personas
    [Documentation]  used to check the result and set a variable based on the result
    [Arguments]  ${request_type}   ${type}
    IF  '${request_type}'=='GET'
        set test variable  ${api_result}  ${response}[details][data]
        Should Be Equal As Strings  ${status}  200
        Should Be Equal As Strings  ${response}[details][data][id]   ${persona_info}[id]
        Should Be Equal As Strings  ${response}[details][data][name]  ${persona_info}[name]
        Should Contain  ${response}[details][data]   permissions
        Should Contain  ${response}[details][data][permissions][0]   permission
        Should Contain  ${response}[details][data][permissions][0]   resource
        Should Contain  ${response}[details][data][permissions][0]   scope
    ELSE
        @{empty_list}=  Create list
        set test variable  ${api_result}  ${empty_list}
    END


GET Personas Error with ${error}
    [Documentation]  Checks the appropriate response is being sent
     ${persona_info}  get variable value  ${persona_info}  default
    IF  '''${persona_info}'''=='''default'''
    ${persona_info}  Find a Persona
    Set Suite Variable   ${persona_info}
    END
    Getting API URL

    IF  '${error.upper()}'=='INVALID OR NO TOKEN'
        Create My User  persona_name=am_admin  with_data=N  legacy_user=Y
        Get Pkce Token  ${okta_automated_email}  ${automated_user_password}  OTR_eMgr  BAD
        Personas  GET  ${persona_info}[id]  N
        Should Be Equal As Strings  ${status}  401

    ELSE IF  '${error.upper()}'=='USER WITHOUT PERMISSION'
        Create My User  persona_name=carrier_manager  with_data=N  legacy_user=Y
        Personas  GET   ${persona_info}[id]
        Should Be Equal As Strings  ${status}     403
        
    ELSE IF  '${error.upper()}'=='EMPTY PERSONA ID'
        Create My User  persona_name=am_admin  with_data=N  legacy_user=Y
        Personas  GET  ${EMPTY}/

        Should Be Equal As Strings  ${status}  401

    ELSE IF  '${error.upper()}'=='INVALID PERSONA ID'
        Create My User  persona_name=am_admin  with_data=N  legacy_user=Y
        Personas  GET   INVALID
        Should Be Equal As Strings  ${status}     204

    ELSE
        Fail  Error '${error.upper()}' not implemented. Status code: ${status}
    END