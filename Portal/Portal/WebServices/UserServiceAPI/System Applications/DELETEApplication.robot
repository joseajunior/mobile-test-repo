*** Settings ***
Library   String
Library   otr_robot_lib.ws.RestAPI.RestAPIService
Library   otr_robot_lib.ws.UserServiceAPI.UserAPIService
Resource  otr_robot_lib/robot/APIKeywords.robot

Suite Setup  Prepare Environment For Testing
Suite Teardown  Finish The Suite

Force Tags  API  UserService  Phoenix  ditOnly

Documentation    Test the DELETE endpoint which deletes an application in the OKTA environment

*** Test Cases ***
Validate Delete Application Endpoint
    [Tags]    JIRA:O5SA-542  qTest:118872117
    [Documentation]    Test case to validate the delete application endpoint
    Make Request
    Validate Response

Make Request Using An Invalid Token
    [Tags]    JIRA:O5SA-542  JIRA:O5SA-595  qTest:118872118
    [Documentation]    Test case to validate the behavior when making a request with an invalid token
    Check If There Are Created Application For Testing
    Make Request    secure=I
    Validate Response    401

Make Request Using A User Without Permissions
    [Tags]    JIRA:O5SA-542  JIRA:O5SA-595  qTest:118872118
    [Documentation]    Test case to validate the behavior when making a request with a user without permissions
    Check If There Are Created Application For Testing
    Make Request    noPermission
    Validate Response    403

Make Request Using With Empty Application ID
    [Tags]    JIRA:O5SA-542  JIRA:O5SA-595  qTest:118872118
    [Documentation]    Test case to validate the behavior when making a request with an empty application_id
    Check If There Are Created Application For Testing
    Make Request    emptyApplicationId
    Validate Response    405

Make Request Using Using An Invalid Application ID
    [Tags]    JIRA:O5SA-542  JIRA:O5SA-595  qTest:118872118
    [Documentation]    Test case to validate the behavior when making a request with an invalid application_id
    Check If There Are Created Application For Testing
    Make Request    invalidApplicationId
    Validate Response    204

*** Keywords ***
Prepare Environment For Testing
    [Documentation]    Keyword that will setup the environment to execute the test
    Get Url For Suite    ${UserService}
    Create My User    persona_name=system_admin  application_name=emgr  entity_id=${NONE}  with_data=N
    Create Application
    Gather Data  ${request_id}

Create Application
    [Documentation]    Create Application to be used in the test
    ${app_name}  Get Current Date    result_format=%f
    ${app_name}  Set Variable    Auto542 ${app_name}
    ${description}  Set Variable  Application created by DELETEApplication.robot from gf-efs-efsqa-frontend-robot
    ${sign_in_uri}  Create List    http://localhost:8080/*  http://localhost:8081/*
    ${sign_out_uri}  Create List    http://localhost:8080  http://localhost:8081

    ${request_body}  Create Dictionary    application_name=${app_name}  description=${description}
                                   ...    sign_in_redirect_uri=${sign_in_uri}  sign_out_redirect_uri=${sign_out_uri}

    ${response}  ${status}  API Request    POST  applications  Y  application=otr_emgr  payload=${request_body}

    Should Be Equal As Strings    202  ${status}
    Set Suite Variable    ${request_id}  ${response}[details][data][request_id]

Check If There Are Created Application For Testing
    [Documentation]    Keyword that will check if there is an application created for testing
    Gather Data    ${request_id}
    IF    ${dbInfo}=={}
        Create Application
        Gather Data  ${request_id}
    END

Finish The Suite
    [Documentation]    Keyword that will clean the environment after testing
    Remove Created Application If Still Exists
    Remove User If Still Exists

Remove Created Application If Still Exists
    [Documentation]    Keyword that will check if the application created wasn't deleted
    Gather Data    ${request_id}
    IF    ${dbInfo}!={}
        Create My User    persona_name=system_admin  application_name=emgr  entity_id=${NONE}  with_data=N
        Make Request
        Validate Response
    END

Gather Data
    [Documentation]    Gather data to be used during test
    [Arguments]    ${request_id}
    ${dbInfo}  Wait Until Keyword Succeeds    2 min  10 sec  Check If The Asycn Call Is Completed    ${request_id}
    Set Suite Variable    ${dbInfo}

Check If The Asycn Call Is Completed
    [Documentation]    Checks if the async call is completed and returns the database information of the created app
    [Arguments]    ${request_id}
    Get Into Db    postgrespgusers
    ${dbInfo}  Catenate    select * from async_api_result aar
                    ...    where aar.request_id = '${request_id}';
    ${result}  Query And Strip To Dictionary    ${dbInfo}
    ${result}  Evaluate    json.loads($result['result'])
    IF  '${result}[status]'=='COMPLETED'
        ${result}  Convert To String    ${result}
        ${result}  Get Regexp Matches    ${result}  (?<=App ID )(.*)(?=')
        ${result}  Convert To String    ${result}
        ${result}  Remove String    ${result}  [  ]
        ${dbInfo}  Catenate    select * from otr_application oa where okta_app_client_id = ${result};
        ${dbInfo}  Query And Strip To Dictionary    ${dbInfo}
        Disconnect From Database
        Return From Keyword    ${dbInfo}
    ELSE IF  '${result}[status]'=='ERROR'
        Disconnect From Database
        Fail    Application Creation Failed
    ELSE
        Disconnect From Database
        Fail    Async Call Not completed yet
    END

Make Request
    [Documentation]    Keyword that makes the request and set avaliable the status and response body
    [Arguments]    ${type}=normal  ${secure}=Y  ${application}=otr_emgr
    ${endpoint}  Create Dictionary    None  ${dbInfo}[okta_app_client_id]

    ${type}  String.Convert To Lower Case    ${type}
    IF    '${type}'=='nopermission'
        Create My User    persona_name=otr_tester_two  application_name=emgr  entity_id=${NONE}  with_data=N

    ELSE IF    '${type}'=='emptyapplicationid'
        Remove From Dictionary    ${endpoint}  None

    ELSE IF    '${type}'=='invalidapplicationid'
        Set To Dictionary    ${endpoint}  None  one1-22-333-4444-55555-666666

    END

    ${response}  ${status}  API Request    DELETE  applications  ${secure}  ${endpoint}  application=${application}

    IF    '${type}'=='nopermission'
        Create My User    persona_name=system_admin  application_name=emgr  entity_id=${NONE}  with_data=N
    END

    Set Suite Variable    ${response}
    Set Suite Variable    ${status}

Validate Response
    [Documentation]    Validate the response body
    [Arguments]    ${intendStatus}=202
    IF    '${intendStatus}'=='202'
        Should Be Equal As Strings    202  ${status}
        Gather Data  ${response}[details][data][request_id]
        Should Be Empty    ${dbInfo}
    ELSE IF    '${intendStatus}'=='401' or '${intendStatus}'=='405' or '${intendStatus}'=='204'
        Should Be Empty    ${response}

        IF    '${intendStatus}'=='401'
            Should Be Equal As Strings    401  ${status}

        ELSE IF    '${intendStatus}'=='405'
            Should Be Equal As Strings    405  ${status}

        ELSE IF    '${intendStatus}'=='204'
            Should Be Equal As Strings    204  ${status}

        END
    END