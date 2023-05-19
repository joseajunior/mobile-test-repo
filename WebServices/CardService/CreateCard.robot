*** Settings ***
Library     RequestsLibrary
Library     Collections
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Suite Setup  Run Keywords    Setup for Create Carrier API    Get Available Carrier and Contract ID
Suite Teardown    Disconnect From Database

Force Tags  cardServiceAPI  API  ditOnly

*** Variable ***
${bearerToken}
${requestEndpoint}
${carrier}
${response}
${issuer_id}    198796
${parent_carrier_id}    378409

*** Test Cases ***
Create Card - Invalid issuer id
    [Documentation]    Ensure the API returns error when the issuer id is invalid
    [Tags]    Q1:2023    JIRA:ATLAS-2318    JIRA:BOT-5083    qTest:120016491

    Send Request for 'invalid unexistent issuer id'
    Check Response for 'invalid unexistent issuer id'
    Send Request for 'invalid existent issuer id'
    Check Response for 'invalid existent issuer id'

Create Card - Invalid parent id
    [Documentation]    Ensure the API returns error when the parent id is invalid
    [Tags]    Q1:2023    JIRA:ATLAS-2318    JIRA:BOT-5083    qTest:120016492

    Send Request for 'invalid unexistent parent carrier id'
    Check Response for 'invalid unexistent parent carrier id'
    Send Request for 'invalid existent parent carrier id'
    Check Response for 'invalid existent parent carrier id'

Create Card - Invalid carrier id
    [Documentation]    Ensure the API returns error when the carrier id is invalid
    [Tags]    Q1:2023    JIRA:ATLAS-2318    JIRA:BOT-5083    qTest:120016493

    Send Request for 'invalid carrier id'
    Check Response for 'invalid carrier id'

Create Card - Invalid policy number
    [Documentation]    Ensure the API returns error when the policy number is invalid
    [Tags]    Q1:2023    JIRA:ATLAS-2318    JIRA:BOT-5083    qTest:120016494

    Send Request for 'invalid policy number'
    Check Response for 'invalid policy number'

Create Card - Invalid contract id
    [Documentation]    Ensure the API returns error when the contract id is invalid
    [Tags]    Q1:2023    JIRA:ATLAS-2318    JIRA:BOT-5083    qTest:120016495

    Send Request for 'invalid contract id'
    Check Response for 'invalid contract id'

Create Card successfully
    [Documentation]    Ensure the API allows a card creation when all data is correctly inserted
    [Tags]    Q1:2023    JIRA:ATLAS-2318    JIRA:BOT-5083    qTest:120016498

    Send Request for 'create card successfully'
    Check Response for 'create card successfully'
    Check New Card in DB

Create Card - Required fields
    [Documentation]    Ensure API request returns error when the required fields are not filled
    [Tags]    Q1:2023    JIRA:ATLAS-2318    JIRA:BOT-5083    qTest:120016499

    Send Request for 'required fields'
    Check Response for 'required fields'

Create Card - API request not authorized
    [Documentation]    Ensure the API request returns error when it's not authorized by the token
    [Tags]    Q1:2023    JIRA:ATLAS-2318    JIRA:BOT-5083    qTest:120016503

    Send Request for 'unauthorized'
    Check Response for 'unauthorized'

Create Card - Simultaneously creation
    [Documentation]    Ensure cards has unique card ids when using POST several times in a short time period
    [Tags]    Q1:2023    JIRA:ATLAS-2318    JIRA:BOT-5083    qTest:120016504

    POST Several Requests Create Card
    Check for several created cards

*** Keywords ***
Setup for Create Carrier API
    Get Bearer Token
    ${requestEndpoint}  catenate  ${cardsservice}/otr-cards/carriers
    Set Suite Variable  ${requestEndpoint}

Get Bearer Token
    [Documentation]   Gets the token for testing the endpoints at DIT
    ${tokenEndpoint}  catenate  ${OAuth2API}/oauth2/aus1trn5zoTQ3XSgh1d7/v1/token

    ${data}  Create dictionary  grant_type=client_credentials  client_id=${OTR_DynamicPinTest_clientId}  client_secret=${OTR_DynamicPinTest_secret}  scope=otr-service
    ${response}  POST  ${OAuth2API}/oauth2/aus1trn5zoTQ3XSgh1d7/v1/token  data=${data}

    Should Be Equal As Strings  ${response.reason}  OK
    Dictionary Should Contain Key  ${response.json()}  access_token

    ${bearerToken}  Set Variable  Bearer ${response.json()}[access_token]
    Set Suite Variable   ${bearerToken}

POST Request Create Card
    [Documentation]  Makes a post request to the endpoint
    [Arguments]  ${carrierRequestEndpoint}    ${data}    ${headers}

    ${response}  POST  ${carrierRequestEndpoint}  json=${data}  headers=${headers}  expected_status=anything
    Set Test Variable    ${response}

POST Several Requests Create Card
    [Documentation]  Makes several post requests to the endpoint

    ${data}    Create Dictionary    contract_id=${carrier.contract}    policy_number=${carrier.policy}
    ...    parent_id=${parent_carrier_id}    issuer_id=${issuer_id}
    ${requestEndpoint}    Catenate    ${requestEndpoint}/${carrier.id}
    Set Test Variable    ${requestEndpoint}
    ${headers}  Create Dictionary  Content-Type=application/json  Authorization=${bearerToken}

    ${card_ids}    Create List
    FOR    ${index}    IN RANGE    10
        ${response}  POST  ${requestEndpoint}  json=${data}  headers=${headers}  expected_status=anything
        Append to List    ${card_ids}    ${response.json()}[details][data][card_id]
    END
    Set Test Variable    ${card_ids}

Get Available Carrier and Contract ID
    [Documentation]    Get available id for a new card

    Get Into DB    TCH
    ${query}    Catenate    SELECT m.member_id, c.contract_id, dc.ipolicy
    ...    FROM member m
    ...    JOIN contract c
    ...    ON c.carrier_id = m.member_id
    ...    JOIN def_card dc
    ...    ON dc.id = c.carrier_id
    ...    WHERE m.member_id >= 7000000
    ...    LIMIT 100;
    ${carrier_info}    Query And Strip to Dictionary    ${query}
    ${carrier_ids}    Get From Dictionary    ${carrier_info}    member_id
    ${carrier_id}  Evaluate  random.choice(${carrier_ids})  random
    ${query}    Catenate    SELECT m.member_id, c.contract_id, dc.ipolicy
    ...    FROM member m
    ...    JOIN contract c
    ...    ON c.carrier_id = m.member_id
    ...    JOIN def_card dc
    ...    ON dc.id = c.carrier_id
    ...    WHERE m.member_id = '${carrier_id}'
    ...    LIMIT 1;
    ${carrier_info}    Query And Strip to Dictionary    ${query}
    ${contract_id}    Get From Dictionary    ${carrier_info}    contract_id
    ${policy}    Get From Dictionary    ${carrier_info}    ipolicy
    ${carrier}    Create Dictionary    id=${carrier_id}    contract=${contract_id}    policy=${policy}
    Set Suite Variable    ${carrier}

Get Invalid Issuer ID
    [Documentation]    Get an invalid existing issuer id

    Get Into DB    TCH
    ${query}    Catenate    SELECT issuer_id
    ...    FROM member_default
    ...    WHERE issuer_id != '${issuer_id}'
    ...    AND issuer_id > 99999
    ...    LIMIT 100;
    ${result}    Query And Strip to Dictionary    ${query}
    ${issuer_ids}    Get From Dictionary    ${result}    issuer_id
    ${issuer_id}  Evaluate  random.choice(${issuer_ids})  random
    Set Test Variable    ${issuer_id}

Get Invalid Parent Carrier ID
    [Documentation]    Get an invalid existing parent carrier id

    Get Into DB    TCH
    ${query}    Catenate    SELECT DISTINCT parent
    ...    FROM carrier_group_xref
    ...    WHERE parent != '${parent_carrier_id}'
    ...    AND parent > 99999;
    ${result}    Query And Strip to Dictionary    ${query}
    ${parent_carrier_ids}    Get From Dictionary    ${result}    parent
    ${parent_carrier_id}  Evaluate  random.choice(${parent_carrier_ids})  random
    Set Test Variable    ${parent_carrier_id}

Send Request for '${validation}'
    [Documentation]    Setup and post requests to the endpoint

    ${data}    Create Dictionary    contract_id=${carrier.contract}    policy_number=${carrier.policy}
    ...    parent_id=${parent_carrier_id}    issuer_id=${issuer_id}
    ${carrierRequestEndpoint}    Catenate    ${requestEndpoint}/${carrier.id}

    IF  '${validation}' == 'invalid unexistent issuer id'
        Set To Dictionary    ${data}    issuer_id=0
    ELSE IF  '${validation}' == 'invalid existent issuer id'
        Get Invalid Issuer ID
        Set To Dictionary    ${data}    issuer_id=${issuer_id}
    ELSE IF  '${validation}' == 'invalid unexistent parent carrier id'
        Set To Dictionary    ${data}    parent_id=0
    ELSE IF  '${validation}' == 'invalid existent parent carrier id'
        Get Invalid Parent Carrier ID
        Set To Dictionary    ${data}    parent_id=${parent_carrier_id}
    ELSE IF  '${validation}' == 'invalid contract id'
        Set To Dictionary    ${data}    contract_id=0
    ELSE IF  '${validation}' == 'invalid carrier id'
        ${carrierRequestEndpoint}    Catenate    ${requestEndpoint}/0
    ELSE IF  '${validation}' == 'invalid policy number'
        Set To Dictionary    ${data}    policy_number=0
    ELSE IF    '${validation}' == 'required fields'
        ${data}    Create Dictionary    test=test
    END

    IF  '${validation}' == 'unauthorized'
        ${headers}  Create Dictionary  Content-Type=application/json
    ELSE
        ${headers}  Create Dictionary  Content-Type=application/json  Authorization=${bearerToken}
    END

    ${response}  POST Request Create Card  ${carrierRequestEndpoint}    ${data}  ${headers}

Check Response for '${validation}'
    [Documentation]    Check response data from endpoint

    IF  '${validation}' == 'invalid existent issuer id' or '${validation}' == 'invalid unexistent issuer id' or '${validation}' == 'invalid carrier id' or '${validation}' == 'invalid contract id' or '${validation}' == 'invalid policy number'
        Should Be Equal As Strings  ${response}  <Response [422]>
        Should Be Equal As Strings  ${response.json()}[name]  INVALID_ISSUER_CONTRACT_POLICY
        Should Be Equal As Strings  ${response.json()}[error_code]  INVALID_ISSUER_CONTRACT_POLICY
        Should Be Equal As Strings  ${response.json()}[message]      Invalid Issuer, contract and policy relation
    ELSE IF  '${validation}' == 'invalid existent parent carrier id' or '${validation}' == 'invalid unexistent parent carrier id'
        Should Be Equal As Strings  ${response}  <Response [422]>
        Should Be Equal As Strings  ${response.json()}[name]  INVALID_BIN
        Should Be Equal As Strings  ${response.json()}[error_code]  INVALID_BIN
        Should Be Equal As Strings  ${response.json()}[message]      Invalid bin for Issuer, contract and policy relation
    ELSE IF  '${validation}' == 'create card successfully'
        Should Be Equal As Strings  ${response}  <Response [201]>
        Should Be Equal As Strings  ${response.json()}[name]  OK
        Should Be Equal As Strings  ${response.json()}[details][type]  CreateCardResponseDTO
        Should Be Equal As Strings  ${response.json()}[details][data][carrier_id]  ${carrier.id}
        Should Be Equal As Strings  ${response.json()}[message]  SUCCESSFUL
        Set Test Variable    ${card_id}    ${response.json()}[details][data][card_id]
    ELSE IF  '${validation}' == 'required fields'
        Should Be Equal As Strings  ${response}  <Response [400]>
        Should Be Equal As Strings  ${response.json()}[name]  BAD_REQUEST
        Should Be Equal As Strings  ${response.json()}[message]  Invalid request input
        ${issuer_id_issue}    Create Dictionary    field=issuerId    issue=issuer_id value cannot be null
        ${policy_number_issue}    Create Dictionary    field=policyNumber    issue=policy_number value cannot be null
        ${contract_id_issue}    Create Dictionary    field=contractId    issue=contract_id value cannot be null
        ${test_issue}    Create Dictionary    field=test    issue=Test is required
        ${exp_details}    Create List    ${issuer_id_issue}    ${policy_number_issue}    ${contract_id_issue}
        List Should Contain Sub List    ${response.json()}[details]    ${exp_details}
        List Should Not Contain Value    ${response.json()}[details]    ${test_issue}
    ELSE IF  '${validation}' == 'unauthorized'
        Should Be Equal As Strings  ${response}  <Response [401]>
    END

Check for several created cards
    [Documentation]    Check data from several cards created

    FOR    ${card_id}    IN    @{card_ids}
        Set Test Variable    ${card_id}
        Check New Card in DB
    END

Check New Card in DB
    [Documentation]    Check info in database from new card

    Get Into DB    TCH
    ${query}    Catenate    SELECT * FROM cards WHERE card_id = '${card_id}';
    ${card_info}    Query and Strip to Dictionary    ${query}
    ${card_status}    Get From Dictionary    ${card_info}    status
    Should Be Equal as Strings    ${card_status}    A
    Row Count is Equal to X  ${query}  1
    ${query}    Catenate    SELECT * FROM card_misc WHERE card_num IN (SELECT card_num FROM cards WHERE card_id = '${card_id}');
    Row Count is Equal to X  ${query}  1