*** Settings ***
Library     RequestsLibrary
Library     Collections
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Suite Setup    Create Contract API and Get Necessary Values
Suite Teardown    Disconnect From Database

Force Tags    API    ditOnly

*** Variables ***
${bearerToken}
${requestEndpoint}
${value}
${response}
${carrier_id}
${used_carrier}
${contract_id}
${contract_ids}
${cont_default_values}
${cont_default_columns}
${cont_misc_default_values}
${cont_misc_def_columns}
${plc_default_columns}
${plc_default_values}
${car_group_default_columns}
${car_group_default_values}
${issuer_id}    198796
${parent_carrier_id}    378409
${parent_contract}    486655
${name}    Name
${street_address}    Street
${city}    City
${state}    XX
${country}    US
${phone}    1111111111
${zip}    12345
${email}    test@mail.com

*** Test Cases ***
Delete Contract - Not Logged In With Token
    [Documentation]    Ensure the API returns error when not logged in with a valid token
    [Tags]    Q1:2023    JIRA:ATLAS-2385    qTest:119998690

    Send Request for 'unauthorized'
    Check Response for 'unauthorized'

Delete Contract - Logged In With Incorrect Token
    [Documentation]    Ensure the API returns error when logged in with an incorrect token
    [Tags]    Q1:2023    JIRA:ATLAS-2385    qTest:119998696

    Send Request for 'logged in with incorrect token'
    Check Response for 'logged in with incorrect token'

Delete Contract - Incorrect Data
    [Documentation]    Ensure the API is not successful with missing fields
    [Tags]    Q1:2023    JIRA:ATLAS-2385    qTest:119998686

    Send Request for 'incorrect data'
    Check Response for 'incorrect data'

Delete Contract - Missing Fields
    [Documentation]    Ensure the API is not successful with missing fields
    [Tags]    Q1:2023    JIRA:ATLAS-2385    qTest:119998700

    Send Request for 'missing fields'
    Check Response for 'missing fields'

Delete Contract - Successfully
    [Documentation]    Ensure the API allows a contract deletion when all data is correctly inserted
    [Tags]    Q1:2023    JIRA:ATLAS-2385    qTest:119998678

    Send Request for 'delete contract successfully'
    Check Response for 'delete contract successfully'
    Confirm Contract Has Been Removed From DB

Delete Contract - Contract Already Deleted
    [Documentation]    Ensure the API returns error when the contract has already been deleted
    [Tags]    Q1:2023    JIRA:ATLAS-2385    qTest:119998711

    Send Request for 'contract already deleted'
    Check Response for 'contract already deleted'
    Confirm Contract Has Been Removed From DB

*** Keywords ***
Check Response for '${validation}'
    [Documentation]    Check response data from endpoint

    IF    '${validation}' == 'delete contract successfully'
        Should Be Equal As Strings    ${response}    <Response [200]>
    ELSE IF    '${validation}' == 'incorrect data'
        Should Be Equal As Strings  ${response}  <Response [400]>
    ELSE IF    '${validation}' == 'missing fields'
        Should Be Equal As Strings  ${response}  <Response [404]>
    ELSE IF  '${validation}' == 'unauthorized'
        Should Be Equal As Strings  ${response}  <Response [401]>
    ELSE IF    '${validation}' == 'logged in with incorrect token'
        Should Be Equal As Strings  ${response}  <Response [401]>
    ELSE IF    '${validation}' == 'contract already deleted'
        Should Be Equal As Strings  ${response}  <Response [422]>
        Should Be Equal As Strings    ${response.json()}[name]    CONTRACT_NOT_FOUND
        Should Be Equal As Strings    ${response.json()}[error_code]        CONTRACT_NOT_FOUND
        Should Be Equal As Strings    ${response.json()}[message]        Contract not found
    END

Confirm Contract Has Been Removed From DB
    Get Into DB    TCH
    ${query}    Catenate    SELECT contract_id
    ...    FROM contract
    ...    WHERE contract_id = ${contract_id};
    ${removedContract}    Query And Strip    ${query}
    Should Be Equal As Strings    ${removedContract}    None

Create Carrier with Contract
    ${createCarrierEndpoint}  catenate  ${CarrierServiceAPI}/carriers
    Set Suite Variable  ${createCarrierEndpoint}
    ${data}    Create Dictionary    name=${name}    street_address=${street_address}    city=${city}    state=${state}
    ...    country=${country}    phone=${phone}    zip=${zip}    email=${email}    issuer_id=${issuer_id}
    ...    parent_carrier_id=${parent_carrier_id}
    ${headers}  Create Dictionary  Content-Type=application/json  Authorization=${bearerToken}
    Get Next Carrier ID
    ${response}  POST Request Create Carrier  ${data}  ${headers}

Create Contract API and Get Necessary Values
    Get Bearer Token
    Create Carrier with Contract
    Get Valid IDs

Get Bearer Token
    [Documentation]   Gets the token for testing the endpoints at DIT
    ${tokenEndpoint}  catenate  ${OAuth2API}/oauth2/aus1trn5zoTQ3XSgh1d7/v1/token

    ${data}  Create dictionary  grant_type=client_credentials  client_id=${OTR_DynamicPinTest_clientId}  client_secret=${OTR_DynamicPinTest_secret}  scope=otr-service
    ${response}  POST  ${OAuth2API}/oauth2/aus1trn5zoTQ3XSgh1d7/v1/token  data=${data}

    Should Be Equal As Strings  ${response.reason}  OK
    Dictionary Should Contain Key  ${response.json()}  access_token

    ${bearerToken}  Set Variable  Bearer ${response.json()}[access_token]
    Set Suite Variable   ${bearerToken}

Get Next Carrier ID
    [Documentation]    Get next available id for a new carrier

    Get Into DB    TCH
    ${query}    Catenate    SELECT member_id
    ...    FROM member
    ...    WHERE member_id BETWEEN 7000000 AND 7999999
    ...    ORDER BY member_id DESC
    ...    LIMIT 1;
    ${carrier_id}    Query And Strip    ${query}
    ${carrier_id}    Evaluate    ${carrier_id} + 1
    Set Suite Variable    ${carrier_id}

Get Valid IDs
    [Documentation]    Get available valid carrier id

    Get Into DB    TCH
    ${query}    Catenate    SELECT contract_id
    ...    FROM contract
    ...    WHERE carrier_id = ${carrier_id}
    ...    LIMIT 1;
    ${contract_id}    Query And Strip    ${query}
    Set Suite Variable    ${contract_id}

DELETE Request Delete Contract
    [Documentation]  Makes a post request to the endpoint
    [Arguments]  ${headers}

    ${response}  DELETE  ${requestEndpoint}  headers=${headers}  expected_status=anything
    Set Test Variable    ${response}

POST Request Create Carrier
    [Documentation]  Makes a post request to the endpoint
    [Arguments]  ${data}  ${headers}

    ${response}  POST  ${createCarrierEndpoint}  json=${data}  headers=${headers}  expected_status=anything
    Should Be Equal As Strings  ${response}  <Response [201]>

Send Request for '${validation}'
    [Documentation]    Setup and post requests to the endpoint

    ${requestEndpoint}  catenate  ${creditcontract}/contracts/${contract_id}/carrier/${carrier_id}
    Set Test Variable    ${requestEndpoint}
    IF    '${validation}' == 'logged in with incorrect token'
        ${bearerToken}    Catenate    ${bearerToken}A
    ELSE IF    '${validation}' == 'incorrect data'
        ${bad_carrier_id}    Catenate    ${carrier_id}!
        ${requestEndpoint}  catenate  ${creditcontract}/contracts/${contract_id}/carrier/${bad_carrier_id}
        Set Test Variable    ${requestEndpoint}
    ELSE IF    '${validation}' == 'missing fields'
        Set Test Variable    ${blank_carrier_id}    ${EMPTY}
        ${requestEndpoint}  catenate  ${creditcontract}/contracts/${contract_id}/carrier/${blank_carrier_id}
        Set Test Variable    ${requestEndpoint}
    END
#
    IF  '${validation}' == 'unauthorized'
        ${headers}  Create Dictionary  Content-Type=application/json
    ELSE
        ${headers}  Create Dictionary  Content-Type=application/json  Authorization=${bearerToken}
    END

    ${response}  DELETE Request Delete Contract  ${headers}