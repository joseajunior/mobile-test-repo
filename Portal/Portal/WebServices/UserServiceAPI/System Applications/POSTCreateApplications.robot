*** Settings ***
Library   String
Library   otr_robot_lib.ws.RestAPI.RestAPIService
Library   otr_robot_lib.ws.UserServiceAPI.UserAPIService
Resource  otr_robot_lib/robot/APIKeywords.robot

Suite Setup  Prepare Environment For Testing
Suite Teardown  Remove User if Still Exists

Force Tags  API  UserService  Phoenix  ditOnly

Documentation    Test the POST endpoint which creates an application in the OKTA environment

*** Test Cases ***
Validate Create Application Endpoint using Native App Type
    [Tags]    Q1:2023  JIRA:O5SA-542  JIRA:O5SA-631  qTest:118872114
    [Documentation]    Test case to validate the creation of application in the OKTA environment
    Make Request
    Validate Response
    [Teardown]    Remove The Application

Validate Create Application Endpoint using Browser App Type
    [Tags]    Q1:2023  JIRA:O5SA-542  JJIRA:O5SA-631  qTest:118872114
    [Documentation]    Test case to validate the creation of application in the OKTA environment
    Modify The Request Body    applicationtype      browser
    Make Request
    Validate Response
    [Teardown]    Remove The Application

Make Request Using An Invalid Token
    [Tags]    Q1:2023  JIRA:O5SA-542  JIRA:O5SA-595  JIRA:O5SA-631  qTest:118872115
    [Documentation]    Test case to validate the Create Application endpoint using an invalid token
    Make Request    secure=I
    Validate Response    401

Make Request Using A User Without Permission
    [Tags]    Q1:2023  JIRA:O5SA-542  JIRA:O5SA-595  JIRA:O5SA-631  qTest:118872115
    [Documentation]    Test case to validate the Create Application endpoint using a user without permission
    Make Request    login=permitLess
    Validate Response    403

Make Request Using An Empty Name
    [Tags]    Q1:2023  JIRA:O5SA-542  JIRA:O5SA-595  JIRA:O5SA-631  qTest:118872115
    [Documentation]    Test case to validate the Create Application endpoint using an empty application name
    Modify The Request Body    emptyName
    Make Request
    Validate Response    400  emptyBody

Make Request Using An Empty String As Name
    [Tags]    Q1:2023  JIRA:O5SA-542  JIRA:O5SA-595  JIRA:O5SA-631  qTest:118872115
    [Documentation]    Test case to validate the Create Application endpoint using an empty string as application name
    Modify The Request Body    emptyStringName
    Make Request
    Validate Response    400  emptyStringName

Make Request Using A Special Character In The Name
    [Tags]    Q1:2023  JIRA:O5SA-542  JIRA:O5SA-595  JIRA:O5SA-631  qTest:118872115
    [Documentation]    Test case to validate the Create Application endpoint using a special character in the
    ...                application name
    Modify The Request Body    specialName
    Make Request
    Validate Response    400  specialName

Make Request Using A Name With More Than 50 Characters
    [Tags]    Q1:2023  JIRA:O5SA-542  JIRA:O5SA-595  JIRA:O5SA-631  qTest:118872115
    [Documentation]    Test case to validate the Create Application endpoint using an application name with more than
    ...                50 characters
    Modify The Request Body    bigName
    Make Request
    Validate Response    400  bigName

Make Request Using An Empty Description
    [Tags]    Q1:2023  JIRA:O5SA-542  JIRA:O5SA-595  JIRA:O5SA-631  qTest:118872115
    [Documentation]    Test case to validate the Create Application endpoint using an empty description
    Modify The Request Body    emptyDescription
    Make Request
    Validate Response    400  emptyBody

Make Request Using An Empty String As Description
    [Tags]    Q1:2023  JIRA:O5SA-542  JIRA:O5SA-595  JIRA:O5SA-631  qTest:118872115
    [Documentation]    Test case to validate the Create Application endpoint using an empty string as description
    Modify The Request Body    emptyStringDescription
    Make Request
    Validate Response    400  emptyStringDescription

Make Request Using A Description With More Than 255 Characters
    [Tags]    Q1:2023  JIRA:O5SA-542  JIRA:O5SA-595  JIRA:O5SA-631  qTest:118872115
    [Documentation]    Test case to validate the Create Application endpoint using a description with more than
    ...                255 characters
    Modify The Request Body    bigDescription
    Make Request
    Validate Response    400  bigDescription

Make Request With The Sign-In URIs List Empty
    [Tags]    Q1:2023  JIRA:O5SA-542  JIRA:O5SA-595  JIRA:O5SA-605  JIRA:O5SA-631  qTest:118872115
    [Documentation]    Test case to validate the Create Application endpoint with the 'sign_in_redirect_uri' list
    ...                of URLs empty
    Modify The Request Body    emptySignIn
    Make Request
    Validate Response    400  emptybody

Make Request With The Sign-Out URIs List Empty
    [Tags]    Q1:2023  JIRA:O5SA-542  JIRA:O5SA-595  JIRA:O5SA-605  JIRA:O5SA-631  qTest:118872115
    [Documentation]    Test case to validate the Create Application endpoint with the 'sign_out_redirect_uri' list
    ...                of URLs empty
    Modify The Request Body    emptySignOut
    Make Request
    Validate Response    400  emptybody

Make Request With Invalid value in Application Type
    [Tags]    Q1:2023  JIRA:O5SA-542  JIRA:O5SA-595  JIRA:O5SA-605  JIRA:O5SA-631  qTest:118872115
    [Documentation]    Test case to validate the Create Application endpoint with the 'application_type' with
    ...                invalid value
    Modify The Request Body    apptypeinvalidvalue
    Make Request
    Validate Response    400  apptypeinvalidvalue

*** Keywords ***
Prepare Environment For Testing
    [Documentation]    Keyword that will setup the environment to execute the test
    Get URL For Suite    ${UserService}
    Gather Data and Prepare Body
    Create My User    system_admin  emgr  ${NONE}  N  Y  N

Gather Data and Prepare Body
    [Documentation]    Gather data to be used during test and prepare the request body

    ${app_name}  Get Current Date    result_format=%f
    ${app_name}  Set Variable    Auto542 ${app_name}
    ${description}  Set Variable  application created by POSTCreateApplication.robot from gf-efs-efsqa-frontend-robot
    ${sign_in_uri}  Create List    http://localhost:8080/*  http://localhost:8081/*
    ${sign_out_uri}  Create List    http://localhost:8080  http://localhost:8081
    ${app_type}     Set Variable    NATIVE

    ${request_body}  Create Dictionary    application_name=${app_name}  description=${description}
                                   ...    sign_in_redirect_uri=${sign_in_uri}  sign_out_redirect_uri=${sign_out_uri}
                                   ...    application_type=${app_type}
    Set Suite Variable    ${app_name}
    Set Suite Variable    ${description}
    Set Suite Variable    ${request_body}
    Set Suite Variable    ${sign_in_uri}
    Set Suite Variable    ${sign_out_uri}
    Set Suite Variable    ${app_type}

Modify The Request Body
    [Documentation]    Keyword that will modify the request body to provoke an error/change
    [Arguments]    ${change}    ${app}=${NONE}

    ${change}  String.Convert To Lower Case    ${change}
    IF    '${change}'=='emptyname'
        ${request_body}  Convert To String    ${request_body}
        ${request_body}  Replace String Using Regexp    ${request_body}  (?<=name')(.*)(?= 'd)  : ,
        Set Suite Variable    ${request_body}  #Reseting the variable because the type changed

    ELSE IF    '${change}'=='applicationtype'
        Set To Dictionary    ${request_body}    application_type=${app.upper()}

    ELSE IF    '${change}'=='emptystringname'
        Set To Dictionary    ${request_body}  application_name  ${EMPTY}

    ELSE IF    '${change}'=='specialname'
        Set To Dictionary    ${request_body}  application_name=things & thongs

    ELSE IF    '${change}'=='bigname'
        Set To Dictionary    ${request_body}  application_name=123456789012345678901234567890123456789012345678901

    ELSE IF    '${change}'=='emptydescription'
        ${request_body}  Convert To String    ${request_body}
        ${request_body}  Replace String Using Regexp    ${request_body}  (?<=description')(.*)  : }
        Set Suite Variable    ${request_body}

    ELSE IF    '${change}'=='emptystringdescription'
        Set To Dictionary    ${request_body}  description=${EMPTY}

    ELSE IF    '${change}'=='bigdescription'
        Set Test Variable    ${bigDescription}  1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
        Set To Dictionary    ${request_body}  description=${bigDescription}

    ELSE IF    '${change}'=='emptysignin'
        Set To Dictionary    ${request_body}  sign_in_redirect_uri=${EMPTY}

    ELSE IF    '${change}'=='emptysignout'
        Set To Dictionary    ${request_body}  sign_out_redirect_uri=${EMPTY}

    ELSE IF    '${change}'=='apptypeinvalidvalue'
        Set To Dictionary    ${request_body}  application_type=Test

    ELSE
        Fail    '${change}' not listed to modify the request body
    END

Make Request
    [Documentation]    Keyword that makes the request and set avaliable the status and response body
    [Arguments]    ${secure}=Y  ${login}=default  ${application}=emgr

    ${login}  String.Convert To Lower Case    ${login}
    IF    '${login}'=='permitless'
        Create My User    otr_tester_two  emgr  ${NONE}  N  Y  N
    END

    ${application_info}  Find Application Information    ${application}

    ${response}  ${status}  API Request    POST  applications  ${secure}  application=${application_info}[0][app_name]
                                    ...    payload=${request_body}

    IF  ${status}==${NONE}
        Fail  Request was not made, status code is None
    END

    IF    '${login}'=='permitless'
        Create My User    system_admin  emgr  ${NONE}  N  Y  N
    END

    Set Test Variable    ${response}
    Set Test Variable    ${status}

Validate Response
    [Documentation]    Validate the response body and the database information
    [Arguments]    ${intendStatus}=202  ${error}=None
    IF    '${intendStatus}'=='202'
        Should Be Equal As Strings    202  ${status}

        Get Into Db    postgrespgusers
        ${dbInfo}  Wait Until Keyword Succeeds    2 min  10 sec  Check If The Asycn Call Is Completed
                                           ...    ${response}[details][data][request_id]
        Disconnect From Database
        Set Suite Variable    ${dbInfo}

        Should Be Equal As Strings    ${request_body}[application_name]  ${dbInfo}[app_name]
        Should Be Equal As Strings    ${request_body}[description]  ${dbInfo}[description]
        Should Be Equal As Strings    ${request_body}[application_name] User Group  ${dbInfo}[user_group_name]
        Should Be Equal As Strings    ${request_body}[application_name] Auth Server  ${dbInfo}[auth_server_name]
        Should Not Be Empty    ${dbInfo}[okta_app_client_id]
        Should Not Be Empty    ${dbInfo}[user_group_id]
        Should Not Be Empty    ${dbInfo}[issuer_uri]
        ${updatedBy}  Convert To String    ${dbInfo}[updated_by]
        Should Not Be Empty    ${updatedBy}

    ELSE IF    '${intendStatus}'=='401'
        Should Be Equal As Strings    401  ${status}
        Should Be Empty    ${response}

    ELSE IF    '${intendStatus}'=='403'
        Should Be Equal As Strings    403  ${status}
        Should Be Empty    ${response}

    ELSE IF    '${intendStatus}'=='400'
        Should Be Equal As Strings    400  ${status}
        ${error}  String.Convert To Lower Case    ${error}

        IF    '${error}'=='emptybody'
            Should Be Empty    ${response}

            ${request_body}  Create Dictionary    application_name=${app_name}  description=${description}
            Set Suite Variable    ${request_body}

        ELSE IF    '${error}'=='emptystringname'
            Should Be Equal As Strings    BAD_REQUEST  ${response}[name]
            Should Be Equal As Strings    applicationName  ${response}[details][0][field]
            ${raw}  Convert To String    ${response}[details]
            Should Contain    ${raw}  size must be between 1 and 50
            Should Contain    ${raw}  must match "^[a-zA-Z0-9_ ]+$"

            #it is in this way because the position of the dictionaries coming in the response was changing

        ELSE IF    '${error}'=='specialname'
            Should Be Equal As Strings    BAD_REQUEST  ${response}[name]
            Should Be Equal As Strings    applicationName  ${response}[details][0][field]
            Should Be Equal As Strings    things & thongs  ${response}[details][0][value]
            Should Be Equal As Strings    must match "^[a-zA-Z0-9_ ]+$"  ${response}[details][0][issue]

        ELSE IF    '${error}'=='bigname'
            Should Be Equal As Strings    BAD_REQUEST  ${response}[name]
            Should Be Equal As Strings    applicationName  ${response}[details][0][field]
            Should Be Equal As Strings    123456789012345678901234567890123456789012345678901  ${response}[details][0][value]
            Should Be Equal As Strings    size must be between 1 and 50  ${response}[details][0][issue]

        ELSE IF    '${error}'=='emptystringdescription'
            Should Be Equal As Strings    BAD_REQUEST  ${response}[name]
            Should Be Equal As Strings    description  ${response}[details][0][field]
            ${raw}  Convert To String    ${response}[details]
            Should Contain    ${raw}  size must be between 1 and 255
            Should Contain    ${raw}  must not be blank

        ELSE IF    '${error}'=='bigdescription'
            Should Be Equal As Strings    BAD_REQUEST  ${response}[name]
            Should Be Equal As Strings    description  ${response}[details][0][field]
            Should Be Equal As Strings    ${bigDescription}  ${response}[details][0][value]
            Should Be Equal As Strings    size must be between 1 and 255  ${response}[details][0][issue]

        ELSE IF    '${error}'=='apptypeinvalidvalue'
            Should Be Equal As Strings    BAD_REQUEST  ${response}[name]
            Should Be Equal As Strings    applicationType  ${response}[details][0][field]
            Should Be Equal As Strings    Test    ${response}[details][0][value]
            Should Be Equal As Strings    invalid application type  ${response}[details][0][issue]

        ELSE
            Fail    '${error}' not listed under 400 status
        END
    ELSE
        Fail    '${intendStatus}' status not listed
    END

    Set To Dictionary    ${request_body}  description  ${description}  application_name  ${app_name}
                  ...    sign_in_redirect_uri  ${sign_in_uri}  sign_out_redirect_uri  ${sign_out_uri}

Check If The Asycn Call Is Completed
    [Documentation]    Checks if the async call is completed and returns the database information of the created app
    [Arguments]    ${request_id}
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
        Return From Keyword    ${dbInfo}
    ELSE IF  '${result}[status]'=='ERROR'
        Fail    Application Creation Failed
    ELSE
        Fail    Async Call Not completed yet
    END

Remove The Application
    [Documentation]    This keyword will remove the application created for testing
    #TODO modify to be a dynamic user (see the suite setup keyword and set the username and password here to ${NONE})
    ${endpoint}  Create Dictionary    ${dbInfo}[okta_app_client_id]=None

    ${response}  ${status}  API Request    DELETE  applications  Y  ${endpoint}  application=otr_emgr

    Should Be Equal As Strings    202  ${status}