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
GET UserProfile By UserID
    [Documentation]  Test the successful scenario to GET Persona By ID
    [Tags]   Q2:2023  JIRA:O5SA-346   qTest:54721478
    [Setup]  Generate Data for Request   BYUID
    Send GET API Request for UserProfile BYUID
    Compare GET Endpoint Results for UserProfile BYUID

GET UserProfile using an Invalid or No Token
    [Tags]  Q2:2023  JIRA:O5SA-346   qTest:54721478
    GET UserProfile Error with Invalid or No Token

GET UserProfile using an Empty User ID
    [Tags]  Q2:2023  JIRA:O5SA-346   qTest:54721478
    GET UserProfile Error with Empty User ID

GET UserProfile using an Invalid User ID
    [Tags]  Q2:2023  JIRA:O5SA-346   qTest:54721478
    GET UserProfile Error with Invalid User ID

GET UserProfile using a Random UUID
    [Tags]  Q2:2023  JIRA:O5SA-346   qTest:54721478
    GET UserProfile Error with Random UUID

*** Keywords ***
Prepare Environment For Testing
    [Documentation]  Keyword that will setup the environment to execute the test
    Get URL For Suite   ${UserService}
    Create My User  otr_user_manager  OTR_eMgr  ${EMPTY}  N  Y  N

Generate Data for Request
    [Documentation]  Create a user and get data to be used in request
    [Arguments]  ${type}
    ${user_info}  Find a User
    Set Suite Variable   ${user_info}


Send ${request_type} API Request for UserProfile ${type}
    Send Request  ${request_type.upper()}   ${type}


Compare ${request_type} Endpoint Results for UserProfile ${type}
    Compare Data for UserProfile  ${request_type.upper()}  ${type}


Find a User
    Get Into DB  postgrespgusers
    ${pg}  Catenate  select otr_user.first_name, otr_user.last_name, id from otr_user limit 1;
    ${query}  Query And Strip To Dictionary  ${pg}
    Disconnect From Database
    [Return]  ${query}


Send Request
    [Arguments]  ${request_type}  ${type}
    UserProfile  ${request_type} ${type}

UserProfile
    [Documentation]  Perform the request for Get UserProfile By UserId
    [Arguments]  ${request}  ${user_id}=${user_info}[id]   ${secure}=Y

    ${headers}  Create Dictionary  content-type=application/json
    ${url_stuff}  create dictionary  users=${user_id}

   ${response}  ${status}  API Request  GET  user-profiles  ${secure}  ${url_stuff}  application=OTR_eMgr

    Set Test Variable  ${status}
    Set Test Variable  ${response}


Compare Data for UserProfile
    [Documentation]  used to check the result and set a variable based on the result
    [Arguments]  ${request_type}   ${type}
    IF  '${request_type}'=='GET'
        set test variable  ${api_result}  ${response}[details][data]
        Should Be Equal As Strings  ${status}  200
        Should Be Equal As Strings  ${response}[details][data][user_id]   ${user_info}[id]
        Should Be Equal As Strings  ${response}[details][data][first_name]  ${user_info}[first_name]
        Should Be Equal As Strings  ${response}[details][data][last_name]  ${user_info}[last_name]
    ELSE
        @{empty_list}=  Create list
        set test variable  ${api_result}  ${empty_list}
    END


GET UserProfile Error with ${error}
    [Documentation]  Checks the appropriate response is being sent
     ${user_info}  get variable value  ${user_info}  default
    IF  '''${user_info}'''=='''default'''
    ${user_info}  Find A User
    Set Suite Variable   ${user_info}
    END

    IF  '${error.upper()}'=='INVALID OR NO TOKEN'
        Get Pkce Token   ${okta_automated_email}  ${automated_user_password}  OTR_eMgr  BAD
        UserProfile  GET  ${user_info}[id]  N
        Should Be Equal As Strings  ${status}  401
        
    ELSE IF  '${error.upper()}'=='EMPTY USER ID'
        UserProfile  GET  ${EMPTY}/
        Should Be Equal As Strings  ${status}  401

    ELSE IF  '${error.upper()}'=='INVALID USER ID'
        UserProfile  GET   INVALID
        Should Be Equal As Strings  ${status}     400

    ELSE IF  '${error.upper()}'=='RANDOM UUID'
        UserProfile      GET   uuid4()
        Should Be Equal As Strings  ${status}     400

    ELSE
        Fail  Error '${error.upper()}' not implemented. Status code: ${status}
    END