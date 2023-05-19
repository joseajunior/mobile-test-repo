*** Settings ***
Documentation       Test the GET endpoint that returns the file type and accepted formats

Library             String
Library             otr_robot_lib.ws.RestAPI.RestAPIService
Library             otr_robot_lib.ws.UserServiceAPI.UserAPIService
Resource            otr_robot_lib/robot/APIKeywords.robot

Suite Setup         Prepare Environment For Testing
Suite Teardown      Remove User If Still Exists

Force Tags          API  DITONLY  MERCHANTSERVICEAPI  PHOENIX  T-CHECK


*** Test Cases ***
Validate File Details Endpoint Successful Response
    [Documentation]  Test to validate the File Details endpoint Successful Response
    [Tags]  JIRA:O5SA-579  JIRA:O5SA-617  Q1:2023  QTEST:119318293
    Make Request
    Validate The Response  200

Validate File Details Endpoint Error Response
    [Documentation]  Test to validate the File Details endpoint Error Response
    [Tags]  JIRA:O5SA-579  JIRA:O5SA-617  PI:15  QTEST:119318297
    Make Request  I
    Validate The Response  401


*** Keywords ***
Prepare Environment For Testing
    [Documentation]  Keyword that will setup the environment to execute the test
    Get URL For Suite  ${MerchantService}
    Create My User  merchant_onsite_fuel_manager  merchant  ${EMPTY}  N  Y  N

Make Request
    [Documentation]  Keyword that makes the request and set the response and status as suite variables
    [Arguments]  ${secure}=Y  ${application}=Merchant Manager
    ${endpoint}  Create Dictionary  upload-file-types=${NONE}
    ${response}  ${status}  API Request
    ...  GET
    ...  merchants
    ...  ${secure}
    ...  ${endpoint}
    ...  application=${application}
    ...  payload=${EMPTY}

    Set Test Variable  ${response}  ${response}
    Set Test Variable  ${status}  ${status}

Validate The Response
    [Documentation]  This keyword will validate the API response
    [Arguments]  ${statusCode}
    IF  ${statusCode}==200
        Should Be Equal As Strings  200  ${status}

        Should Be Equal As Strings
        ...  EFS_MOBILE_FUEL_FILE
        ...  ${response}[details][data][upload_file_type_list][0][file_type]
        Should Be Equal As Strings  .xls,.xlsx  ${response}[details][data][upload_file_type_list][0][file_extension]

        Should Be Equal As Strings
        ...  WEX_ONSITE_FUEL_FILE
        ...  ${response}[details][data][upload_file_type_list][1][file_type]
        Should Be Equal As Strings
        ...  .xls,.xlsx,.json
        ...  ${response}[details][data][upload_file_type_list][1][file_extension]
    ELSE IF  ${statusCode}==401
        Should Be Equal As Strings  401  ${status}
        Should Be Equal As Strings  ${empty}  ${response}
    ELSE
        Fail  '${statusCode}' not implemented
    END
