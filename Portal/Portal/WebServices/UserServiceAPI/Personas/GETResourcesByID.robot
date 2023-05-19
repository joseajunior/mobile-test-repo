*** Settings ***
Library  String
Library  Collections
Library  otr_robot_lib.ws.RestAPI.RestAPIService
Library  otr_robot_lib.ws.UserServiceAPI.UserAPIService
Resource  otr_robot_lib/robot/APIKeywords.robot

Documentation  This is to test the UserService API to get User Profile by user id (currently only works in dit because okta service is set up there)
Force Tags     userServiceAPI  API  ditOnly

Suite Setup         Prepare Environment For Testing
Suite Teardown      Remove User If Still Exists

*** Test Cases ***
GET Resources By ID
    [Documentation]  Test the successful scenario to GET Resources By ID
    [Tags]   Q2:2023  JIRA:O5SA-344  qTest:30070239
    [Setup]  Generate Data for Request   BYRID
    Send GET API Request for Resources BYRID
    Compare GET Endpoint Results for Resources BYRID

GET Resources using an Invalid or No Token
    [Tags]  Q2:2023  JIRA:O5SA-344  qTest:30070239
    GET Resources Error with Invalid or No Token

GET Resources using an Empty ID
    [Tags]  Q2:2023  JIRA:O5SA-344  qTest:30070239
    GET Resources Error with Empty ID

GET Resources using an Invalid Resource ID
    [Tags]  Q2:2023  JIRA:O5SA-344  qTest:30070239
    GET Resources Error with Invalid Resource ID

GET Resources using a Random UUID
    [Tags]  Q2:2023  JIRA:O5SA-344  qTest:30070239
    GET Resources Error with Random UUID

*** Keywords ***
Prepare Environment For Testing
    [Documentation]  Keyword that will setup the environment to execute the test
    Get URL For Suite   ${UserService}
    Create My User  am_admin  OTR_eMgr  ${EMPTY}  N  Y  N

Generate Data for Request
    [Documentation]  Create a user and get data to be used in request
    [Arguments]  ${type}
    ${resource_info}  Find a Resource
    Set Suite Variable   ${resource_info}


Send ${request_type} API Request for Resources ${type}
    Send Request  ${request_type.upper()}   ${type}


Compare ${request_type} Endpoint Results for Resources ${type}
    Compare Data for Resources  ${request_type.upper()}  ${type}


Find a Resource
    Get Into DB  postgrespgusers
    ${pg}  Catenate  select resource.id, resource.name, resource.description from resource limit 1;
    ${query}  Query And Strip To Dictionary  ${pg}
    Disconnect From Database
    [Return]  ${query}


Send Request
    [Arguments]  ${request_type}  ${type}
    Resources  ${request_type} ${type}

Resources
    [Documentation]  Perform the request for Get Resources By Id
    [Arguments]  ${request}  ${resource_id}=${resource_info}[id]   ${secure}=Y

    ${headers}  Create Dictionary  content-type=application/json
    ${url_stuff}  create dictionary  resources=${resource_id}

   ${response}  ${status}  API Request  GET  personas  ${secure}  ${url_stuff}  application=OTR_eMgr

    Set Test Variable  ${status}
    Set Test Variable  ${response}


Compare Data for Resources
    [Documentation]  used to check the result and set a variable based on the result
    [Arguments]  ${request_type}   ${type}
    IF  '${request_type}'=='GET'
        set test variable  ${api_result}  ${response}[details][data]
        Should Be Equal As Strings  ${status}  200
        Should Be Equal As Strings  ${response}[details][data][id]   ${resource_info}[id]
        Should Be Equal As Strings  ${response}[details][data][description]  ${resource_info}[description]
        Should Be Equal As Strings  ${response}[details][data][name]  ${resource_info}[name]
    ELSE
        @{empty_list}=  Create list
        set test variable  ${api_result}  ${empty_list}
    END


GET Resources Error with ${error}
    [Documentation]  Checks the appropriate response is being sent
     ${resource_info}  get variable value  ${resource_info}  default
    IF  '''${resource_info}'''=='''default'''
    ${resource_info}  Find A Resource
    Set Suite Variable   ${resource_info}
    END

    IF  '${error.upper()}'=='INVALID OR NO TOKEN'
        Get Pkce Token   ${okta_automated_email}  ${automated_user_password}  OTR_eMgr  BAD
        Resources  GET  ${resource_info}[id]  N
        Should Be Equal As Strings  ${status}  401

    ELSE IF  '${error.upper()}'=='EMPTY ID'
        Resources  GET  ${EMPTY}/
        Should Be Equal As Strings  ${status}  401

    ELSE IF  '${error.upper()}'=='INVALID RESOURCE ID'
        Resources  GET   INVALID
        Should Be Equal As Strings  ${status}     204

    ELSE IF  '${error.upper()}'=='RANDOM UUID'
        Resources      GET   uuid4()
        Should Be Equal As Strings  ${status}     204

    ELSE
        Fail  Error '${error.upper()}' not implemented. Status code: ${status}
    END