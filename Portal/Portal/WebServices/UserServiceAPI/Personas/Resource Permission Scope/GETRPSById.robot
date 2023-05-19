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
GET RPS By ID
    [Documentation]  Test the successful scenario to GET RPS By ID
    [Tags]   Q2:2023  JIRA:O5SA-345   qTest:30070240
    [Setup]  Generate Data for Request   BYID
    Send GET API Request for RPS BYID
    Compare GET Endpoint Results for RPS BYID

GET RPS using an Invalid or No Token
    [Tags]  Q2:2023  JIRA:O5SA-345   qTest:30070240
    GET RPS Error with Invalid or No Token

GET RPS using an Empty ID
    [Tags]  Q2:2023  JIRA:O5SA-345   qTest:30070240
    GET RPS Error with Empty ID

GET RPS using an Invalid ID
    [Tags]  Q2:2023  JIRA:O5SA-345   qTest:30070240
    GET RPS Error with Invalid ID

GET RPS using a Random UUID
    [Tags]  Q2:2023  JIRA:O5SA-345   qTest:30070240
    GET RPS Error with Random UUID

*** Keywords ***
Prepare Environment For Testing
    [Documentation]  Keyword that will setup the environment to execute the test
    Get URL For Suite   ${UserService}
    Create My User  am_admin  OTR_eMgr  ${EMPTY}  N  Y  N

Generate Data for Request
    [Documentation]  Create a user and get data to be used in request
    [Arguments]  ${type}
    ${rps_info}  Find a RPS
    Set Suite Variable   ${rps_info}


Send ${request_type} API Request for RPS ${type}
    Send Request  ${request_type.upper()}   ${type}


Compare ${request_type} Endpoint Results for RPS ${type}
    Compare Data for RPS  ${request_type.upper()}  ${type}


Find a RPS
    Get Into DB  postgrespgusers
    ${pg}  Catenate  select id, description, permission, name as rpsname  from resource_permission_scope limit 1;
    ${query}  Query And Strip To Dictionary  ${pg}
    Disconnect From Database
    [Return]  ${query}


Send Request
    [Arguments]  ${request_type}  ${type}
    RPS  ${request_type} ${type}

RPS
    [Documentation]  Perform the request for Get RPS By Id
    [Arguments]  ${request}  ${rps_id}=${rps_info}[id]   ${secure}=Y

    ${headers}  Create Dictionary  content-type=application/json
    ${url_stuff}  create dictionary  resource-permission-scopes=${rps_id}

   ${response}  ${status}  API Request  GET  personas  ${secure}  ${url_stuff}  application=OTR_eMgr

    Set Test Variable  ${status}
    Set Test Variable  ${response}


Compare Data for RPS
    [Documentation]  used to check the result and set a variable based on the result
    [Arguments]  ${request_type}   ${type}
    IF  '${request_type}'=='GET'
        set test variable  ${api_result}  ${response}[details][data]
        Should Be Equal As Strings  ${status}  200
        Should Be Equal As Strings  ${response}[details][data][id]   ${rps_info}[id]
        Should Be Equal As Strings  ${response}[details][data][description]  ${rps_info}[description]
        Should Be Equal As Strings  ${response}[details][data][rpsname]  ${rps_info}[rpsname]
        Should Be Equal As Strings  ${response}[details][data][permission]  ${rps_info}[permission]
    ELSE
        @{empty_list}=  Create list
        set test variable  ${api_result}  ${empty_list}
    END


GET RPS Error with ${error}
    [Documentation]  Checks the appropriate response is being sent
     ${rps_info}  get variable value  ${rps_info}  default
    IF  '''${rps_info}'''=='''default'''
    ${rps_info}  Find A RPS
    Set Suite Variable   ${rps_info}
    END

    IF  '${error.upper()}'=='INVALID OR NO TOKEN'
        Get Pkce Token   ${okta_automated_email}  ${automated_user_password}  OTR_eMgr  BAD
        RPS  GET  ${rps_info}[id]  N
        Should Be Equal As Strings  ${status}  401
        
    ELSE IF  '${error.upper()}'=='EMPTY ID'
        RPS  GET  ${EMPTY}/
        Should Be Equal As Strings  ${status}  401

    ELSE IF  '${error.upper()}'=='INVALID ID'
        RPS  GET   INVALID
        Should Be Equal As Strings  ${status}     204

    ELSE IF  '${error.upper()}'=='RANDOM UUID'
        RPS      GET   uuid4()
        Should Be Equal As Strings  ${status}     204

    ELSE
        Fail  Error '${error.upper()}' not implemented. Status code: ${status}
    END