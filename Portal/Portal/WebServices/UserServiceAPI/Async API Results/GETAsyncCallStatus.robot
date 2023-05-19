*** Settings ***
Library   String
Library   otr_robot_lib.ws.RestAPI.RestAPIService
Library   otr_robot_lib.ws.UserServiceAPI.UserAPIService
Resource  otr_robot_lib/robot/APIKeywords.robot

Suite Setup  Prepare Environment For Testing
Suite Teardown  Remove User if Still Exists

Force Tags  API  UserService  Phoenix  ditOnly

Documentation    Test the GET endpoint which gets the status of an async call

*** Test Cases ***
Validate Get Async Call Status Endpoint
    [Tags]    JIRA:O5SA-542  qTest:118872112
    [Documentation]    Test case to validate the get status endpoint
    Make Request
    Validate Response

Make Request Using An Invalid Token
    [Tags]    JIRA:O5SA-542  JIRA:O5SA-595  qTest:118872113
    [Documentation]    Test case to validate the behavior when making a request with an invalid token
    Make Request    secure=I
    Validate Response    401

Make Request Using An Empty Request ID
    [Tags]    JIRA:O5SA-542  JIRA:O5SA-595  qTest:118872113
    [Documentation]    Test case to validate the behavior when making a request with an empty request_id
    Make Request    emptyRequestId
    Validate Response    401

Make Request Using An Invalid Request ID
    [Tags]    JIRA:O5SA-542  JIRA:O5SA-595  qTest:118872113
    [Documentation]    Test case to validate the behavior when making a request with an invalid request_id
    Make Request    invalidRequestId
    Validate Response    204

*** Keywords ***
Prepare Environment For Testing
    [Documentation]    Keyword that will setup the environment to execute the test
    Get URL For Suite    ${UserService}
    Gather Data
    Create My User    persona_name=system_admin  application_name=emgr  entity_id=${NONE}  with_data=N

Gather Data
    [Documentation]    Gather data to be used during test
    ${dbInfo}  Catenate    select * from async_api_result order by updated desc limit 250;
    Get Into DB    postgrespgusers
    ${dbInfo}  Query And Strip To Dictionary    ${dbInfo}
    Disconnect From Database

    IF  isinstance($dbInfo['request_id'], list)
        ${len}  Get Length    ${dbInfo}[request_id]
        ${len}  Evaluate    random.randint(0, $len-1)
        ${dbInfo}  Create Dictionary    request_id=${dbInfo}[request_id][${len}]  result=${dbInfo}[result][${len}]
                                 ...    updated=${dbInfo}[updated][${len}]
    END
    Set Suite Variable    ${dbInfo}

Make Request
    [Documentation]    Keyword that makes the request and set avaliable the request status and response body
    [Arguments]    ${error}=None  ${secure}=Y  ${username}=${NONE}  ${password}=${NONE}
    ${endpoint}  Create Dictionary    ${dbInfo}[request_id]  ${NONE}

    ${error}  String.Convert To Lower Case    ${error}
    IF    '${error}'=='emptyrequestid'
        Remove From Dictionary    ${endpoint}  ${dbInfo}[request_id]
    ELSE IF    '${error}'=='invalidrequestid'
        Remove From Dictionary    ${endpoint}  ${dbInfo}[request_id]
        Set To Dictionary    ${endpoint}  one1-22-333-4444-55555-666666  None
    END

    ${response}  ${status}  API Request    GET  async-api-results  ${secure}  ${endpoint}  ${EMPTY}  application=otr_emgr

    Set Suite Variable    ${response}
    Set Suite Variable    ${status}

Validate Response
    [Documentation]    Validate the response
    [Arguments]    ${intendStatus}=200
    IF    '${intendStatus}'=='200'
        Should Be Equal As Strings    200  ${status}
        Should Be Equal As Strings    SUCCESSFUL  ${response}[name]
        Should Be Equal As Strings    AsyncApiResult  ${response}[details][type]
        Should Be Equal As Strings    ${dbInfo}[request_id]  ${response}[details][data][request_id]
        ${dbInfo}  Evaluate    json.loads($dbInfo['result'])
        Should Be Equal As Strings    ${dbInfo}  ${response}[details][data][result]

    ELSE IF    '${intendStatus}'=='404'
        Should Be Equal As Strings    404  ${status}
        Dictionary Should Contain Key    ${response}  timestamp
        Dictionary Should Contain Key    ${response}  status
        Dictionary Should Contain Key    ${response}  error
        Dictionary Should Contain Key    ${response}  path

    ELSE IF    '${intendStatus}'=='401' or '${intendStatus}'=='204'
        Should Be Empty    ${response}

        IF    '${intendStatus}'=='401'
            Should Be Equal As Strings    401  ${status}

        ELSE IF    '${intendStatus}'=='204'
            Should Be Equal As Strings    204  ${status}

        END

    ELSE
        Fail    '${intendStatus}' not listed
    END