*** Settings ***
Library     RequestsLibrary
Library     Collections
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Suite Setup  Setup Test Data
Test Teardown    Run Keywords    Close Browser    Disconnect from Database

Force Tags  cardServiceAPI  API

*** Variable ***
${bearerToken}
${requestEndpoint}
${carrier}
${prompt}

*** Test Cases ***
Enable/Disable Dynamic Prompt for Policies
    [Documentation]    Run the API with permission and enable/disable a dynamic prompt correctly to get a successful
    ...    response
    [Tags]    Q2:2023    JIRA:ATLAS-2413    JIRA:BOT-5092    qTest:120498340

    Log Carrier into eManager with Managed Dynamic Pin Allowed permission
    Go to Select Program > Manage Policies > Manage Policies
    Ensure Given Policy is Selected
    Ensure Dynamic Prompting is Disabled
    Send Request for 'enable dynamic prompting'
    Check Response for 'enable dynamic prompting'
    Reload Page
    Check 'disable' Dynamic Prompting
    Send Request for 'disable dynamic prompting'
    Check Response for 'disable dynamic prompting'
    Reload Page
    Check 'enable' Dynamic Prompting

Enable/Disable Dynamic Prompt for Policies with an invalid carrier ID
    [Documentation]    Run the API with a carrier ID not included in the family with needed permissions
    [Tags]    Q2:2023    JIRA:ATLAS-2413    JIRA:BOT-5092    qTest:120498366

    Send Request for 'invalid carrier ID'
    Check Response for 'invalid carrier ID'

Enable/Disable Dynamic Prompt for Policies missing required fields
    [Documentation]    Run the API with required fields missing
    [Tags]    Q2:2023    JIRA:ATLAS-2413    JIRA:BOT-5092    qTest:120498368

    Log Carrier into eManager with Managed Dynamic Pin Allowed permission
    Go to Select Program > Manage Policies > Manage Policies
    Ensure Given Policy is Selected
    Ensure Dynamic Prompting is Disabled
    Send Request for 'without prompt type'
    Check Response for 'without prompt type'
    Send Request for 'without enable dynamic prompt'
    Check Response for 'without enable dynamic prompt'

Enable/Disable Dynamic Prompt for Policies without logging in
    [Documentation]    Run the API without logging in or logging in with a token lacking permissions
    [Tags]    Q2:2023    JIRA:ATLAS-2413    JIRA:BOT-5092    qTest:120498391

    Send Request for 'unauthorized'
    Check Response for 'unauthorized'

Enable Dynamic Prompt for Policy when a dynamic prompt already exists
    [Documentation]    Try to add a second policy dynamic prompt
    [Tags]    Q2:2023    JIRA:ATLAS-2413    JIRA:BOT-5092    qTest:120506857

    Log Carrier into eManager with Managed Dynamic Pin Allowed permission
    Go to Select Program > Manage Policies > Manage Policies
    Ensure Given Policy is Selected
    Ensure Dynamic Prompting is Disabled
    Send Request for 'enable dynamic prompting'
    Check Response for 'enable dynamic prompting'
    Reload Page
    Check 'disable' Dynamic Prompting
    Send Request for 'enable dynamic prompting again'
    Check Response for 'duplicate enable dynamic prompting'

*** Keywords ***
Setup Test Data
    # token
    Get Bearer Token
    # get carrier
    Get Into DB    postgrespgcarrierservices
    ${query}    Catenate    SELECT carrier_id
	...    FROM carrier_family_carrier_xref
	...    WHERE carrier_family_natural_id IN ('EFS','RYDER')
	...    ORDER BY carrier_id
	...    LIMIT 100;
    ${result}    Query And Strip to Dictionary    ${query}
    ${carrier_ids}    Get From Dictionary    ${result}    carrier_id
    ${carrier_list}  Evaluate  ${carrier_ids}.__str__().replace('[','(').replace(']',')')
    # ensure it has policies to manage
    Get into DB    TCH
    ${query}    Catenate    SELECT DISTINCT id
    ...    FROM def_card
    ...    WHERE id IN ${carrier_list}
    ...    AND policy IS NOT NULL;
    ${result}    Query And Strip to Dictionary    ${query}
    ${carrier_ids}    Get From Dictionary    ${result}    id
    ${carrier_id}    Evaluate  random.choice(${carrier_ids})  random
    # get carrier password
    ${query}    Catenate    select passwd from member where member_id = '${carrier_id}';
    ${password}    Query And Strip    ${query}
    # set carrier infos
    ${carrier}    Create Dictionary    id=${carrier_id}    password=${password}
    # get and set carrier policy
    ${query}    Catenate    select policy from def_card where id = '${carrier.id}' order by policy limit 1;
    ${policy_id}    Query And Strip    ${query}
    Set To Dictionary    ${carrier}    policy=${policy_id}
    Set Suite Variable  ${carrier}
    # update carrier permissions
    Ensure Carrier has User Permission    ${carrier.id}    MANAGED_DYNAMIC_PIN_ALLOWED
    Remove Carrier User Permission    ${carrier.id}    DATA_SHARE_PARTNERS
    Remove Carrier Group Permission    ${carrier.id}    COMPANY_ADMIN    DATA_SHARE_PARTNERS
    # set url
    ${requestEndpoint}  Catenate  ${cardsservice}/card-policies/${carrier.policy}/configs/carriers/${carrier.id}/dynamic-prompt-configs
    Set Suite Variable  ${requestEndpoint}

Get Bearer Token
    [Documentation]   Gets the token for Ryder for testing the endpoints at DIT
    ${tokenEndpoint}  catenate  ${OAuth2API}/oauth2/aus1trn5zoTQ3XSgh1d7/v1/token

    ${data}  Create dictionary  grant_type=client_credentials  client_id=${OTR_DynamicPinTest_clientId}  client_secret=${OTR_DynamicPinTest_secret}  scope=otr-service
    ${response}  POST  ${OAuth2API}/oauth2/aus1trn5zoTQ3XSgh1d7/v1/token  data=${data}

    Should Be Equal As Strings  ${response.reason}  OK
    Dictionary Should Contain Key  ${response.json()}  access_token

    ${bearerToken}  Set Variable  Bearer ${response.json()}[access_token]
    Set Suite Variable   ${bearerToken}

Log Carrier into eManager with Managed Dynamic Pin Allowed permission
    [Documentation]  Log carrier into eManager with Managed Dynamic Pin Allowed permission

    Open eManager  ${carrier.id}  ${carrier.password}

Go to Select Program > Manage Policies > Manage Policies
    [Documentation]  Go to Select Program > Manage Policies > Manage Policies

    Go To  ${emanager}/cards/PolicyPromptManagement.action
    Wait Until Page Contains    Policy Information

Ensure Given Policy is Selected
    [Documentation]    Ensure carrier policy is selected in manage policies screen

    Select From List By Value    name=policy.policyNumber    ${carrier.policy}
    Click Element    name=savePolicyInformation
    Wait Until Page Contains    Policy Information

Ensure Dynamic Prompting is Disabled
    [Documentation]    Guarantee dynamic prompting is disabled in manage policies screen

    ${status}    Run Keyword And Return Status    Page Should Contain Element    name=disableDynamicPrompting
    Run Keyword If    '${status}'=='True'    Disable Dynamic Prompting

Disable Dynamic Prompting
    [Documentation]    Disable dynamic prompting in manage policies screen if set

    Click Element    name=disableDynamicPrompting
    Wait Until Element is Visible    name=deletedDynamicPin
    Click Element    name=deletedDynamicPin
    Wait Until Page Contains    You have successfully deleted the prompt of

PUT Request Enabled Disable Dynamic Pin Policy
    [Documentation]  Makes a put request to the endpoint
    [Arguments]  ${data}  ${headers}

    ${response}  PUT  ${requestEndpoint}  json=${data}  headers=${headers}  expected_status=anything
    Set Test Variable  ${response}

Send Request for '${validation}'
    [Documentation]    Setup and put requests to the endpoint

    Run Keyword If    '${validation}'!='enable dynamic prompting again'    Get Random Prompt
    ${data}    Create Dictionary    enable_dynamic_prompt=true    prompt_type=${prompt}

    IF  '${validation}' == 'disable dynamic prompting'
        Set To Dictionary    ${data}    enable_dynamic_prompt=false
    ELSE IF  '${validation}' == 'invalid carrier ID'
        ${requestEndpoint}  Catenate  ${cardsservice}/card-policies/${carrier.policy}/configs/carriers/600006/dynamic-prompt-configs
        Set Test Variable  ${requestEndpoint}
    ELSE IF  '${validation}' == 'without prompt type'
        Remove From Dictionary    ${data}    prompt_type
    ELSE IF  '${validation}' == 'without enable dynamic prompt'
        Remove From Dictionary    ${data}    enable_dynamic_prompt
    END

    IF  '${validation}' == 'unauthorized'
        ${headers}  Create Dictionary  Content-Type=application/json
    ELSE
        ${headers}  Create Dictionary  Content-Type=application/json  Authorization=${bearerToken}
    END

    ${response}  PUT Request Enabled Disable Dynamic Pin Policy  ${data}  ${headers}

Get Random Prompt
    [Documentation]    Get CNTN or TRIP prompt

    ${prompts}    Create List    TRIP    CNTN
    ${prompt}    Evaluate  random.choice(${prompts})  random
    Set Test Variable    ${prompt}

Check Response for '${validation}'
    [Documentation]    Check response data from endpoint

    IF  '${validation}' == 'enable dynamic prompting'
        Should Be Equal As Strings  ${response}    <Response [200]>
        Should Be Equal As Strings  ${response.json()}[name]    OK
        Should Be Equal As Strings  ${response.json()}[message]    SUCCESSFUL
        Should Be Equal As Strings  ${response.json()}[details][type]    AddNewDynamicPromptForPolicyResponse
        Should Be Equal As Strings  ${response.json()}[details][data][carrier_id]    ${carrier.id}
        Should Be Equal As Strings  ${response.json()}[details][data][policy_number]    ${carrier.policy}
        Should Be Equal As Strings  ${response.json()}[details][data][dynamic_prompt][type]    ${prompt}
        Should Be Equal As Strings  ${response.json()}[details][data][dynamic_prompt][validation]    D
    ELSE IF  '${validation}' == 'disable dynamic prompting'
        Should Be Equal As Strings  ${response}  <Response [204]>
    ELSE IF  '${validation}' == 'invalid carrier ID'
        Should Be Equal As Strings  ${response}    <Response [422]>
        Should Be Equal As Strings  ${response.json()}[name]    FAMILY_NOT_FOUND
        Should Be Equal As Strings  ${response.json()}[error_code]    FAMILY_NOT_FOUND
        Should Be Equal As Strings  ${response.json()}[message]    There is no family found with given information
    ELSE IF  '${validation}' == 'without prompt type'
        Should Be Equal As Strings  ${response}    <Response [422]>
        Should Be Equal As Strings  ${response.json()}[name]    INVALID_DATA
        Should Be Equal As Strings  ${response.json()}[error_code]    INVALID_DATA
        Should Be Equal As Strings  ${response.json()}[message]    Provided invalid input combination
    ELSE IF  '${validation}' == 'without enable dynamic prompt'
        Should Be Equal As Strings  ${response}    <Response [422]>
        Should Be Equal As Strings  ${response.json()}[name]    POLICY_DYNAMIC_PROMPT_DOES_NOT_EXISTS
        Should Be Equal As Strings  ${response.json()}[error_code]    POLICY_DYNAMIC_PROMPT_DOES_NOT_EXISTS
        Should Be Equal As Strings  ${response.json()}[message]    Requested policy has no dynamic prompt enabled
    ELSE IF  '${validation}' == 'unauthorized'
        Should Be Equal As Strings  ${response}    <Response [401]>
    ELSE IF  '${validation}' == 'duplicate enable dynamic prompting'
        Should Be Equal As Strings  ${response}    <Response [422]>
        Should Be Equal As Strings  ${response.json()}[name]    PROMPT_ALREADY_USED
        Should Be Equal As Strings  ${response.json()}[error_code]    PROMPT_ALREADY_USED
        Should Be Equal As Strings  ${response.json()}[message]    The requested prompt is already used
    END

Check '${option}' Dynamic Prompting
    [Documentation]    Check for disable/enable dynamic prompting in emanager manage policies screen

    Page Should Contain Element    name=${option}DynamicPrompting