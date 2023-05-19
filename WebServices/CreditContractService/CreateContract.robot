*** Settings ***
Library     RequestsLibrary
Library     Collections
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Suite Setup  Run Keywords    Setup for Create Contract API    Setup Valid Carriers    Get Default Policy Values
...    Get Default Contract Values    Get Default Contract Misc Values    Get Default Carrier Group Values
Test Setup    Get Valid Carrier ID
Suite Teardown    Disconnect From Database

Force Tags  creditContractAPI  API  ditOnly

*** Variable ***
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

*** Test Cases ***
Create Contract - Invalid issuer id
    [Documentation]   Ensure the API returns error when the issuer id is invalid
    [Tags]   Q1:2023    JIRA:ATLAS-2335    JIRA:BOT-5075    qTest:119711898

    Send Request for 'invalid unexistent issuer id'
    Check Response for 'invalid unexistent issuer id'

Create Contract - Invalid parent id
    [Documentation]   Ensure the API returns error when the parent id is invalid
    [Tags]   Q1:2023    JIRA:ATLAS-2335    JIRA:BOT-5075    qTest:119711900

    Send Request for 'invalid unexistent parent carrier id'
    Check Response for 'invalid unexistent parent carrier id'

Create Contract - Invalid carrier id
    [Documentation]    Ensure the API returns error when the carrier id is invalid
    [Tags]   Q1:2023    JIRA:ATLAS-2335    JIRA:BOT-5075    qTest:119711902

    Send Request for 'invalid unexistent carrier id'
    Check Response for 'invalid unexistent carrier id'

Create Contract successfully
    [Documentation]   Ensure the API allows a contract creation when all data is correctly inserted
    [Tags]   Q1:2023    JIRA:ATLAS-2335    JIRA:BOT-5075    qTest:119711903

    Send Request for 'create contract successfully'
    Check Response for 'create contract successfully'
    Check New Contract in DB

Create Contract - Simultaneously creation
    [Documentation]  Ensure carriers has unique contract ids when using POST several times in a short time period
    [Tags]   Q1:2023    JIRA:ATLAS-2335    JIRA:BOT-5075    qTest:119711906

    POST Several Requests Create Contract
    Check for several created contracts

Create Contract - API request not authorized
    [Documentation]  Ensure the API request returns error when it's not authorized by the token
    [Tags]   Q1:2023    JIRA:ATLAS-2335    JIRA:BOT-5075    qTest:119711907

    Send Request for 'unauthorized'
    Check Response for 'unauthorized'

Create Contract - Required fields
    [Documentation]  Ensure API request returns error when the required fields are not filled
    [Tags]   Q1:2023    JIRA:ATLAS-2335    JIRA:BOT-5075    qTest:119711908

    Send Request for 'required carrier id'
    Check Response for 'required carrier id'
    Send Request for 'required issuer id'
    Check Response for 'required issuer id'
    Send Request for 'required parent id'
    Check Response for 'required parent id'

Create Contract - Carrier already used
    [Documentation]  Ensure the API returns an error message for when using the carrier to create a contract again
    [Tags]   Q1:2023    JIRA:ATLAS-2335    JIRA:BOT-5075    qTest:119716588

    Send Request for 'carrier already used'
    Check Response for 'carrier already used'

*** Keywords ***
Setup for Create Contract API
    Get Bearer Token
    ${requestEndpoint}  catenate  ${creditcontract}/contracts
    Set Suite Variable  ${requestEndpoint}

Setup Valid Carriers
    [Documentation]    Setting up valid data for the tests in this suite

    ${carrierRequestEndpoint}  catenate  ${CarrierServiceAPI}/carriers

    ${carrier_data}    Create Dictionary    name=Name    street_address=Street    city=City    state=XX
    ...    country=US    phone=1111111111    zip=12345    email=test@mail.com    issuer_id=198796
    ...    parent_carrier_id=378409
    ${headers}  Create Dictionary  Content-Type=application/json  Authorization=${bearerToken}

    FOR    ${index}    IN RANGE    11
        ${response}  POST  ${carrierRequestEndpoint}  json=${carrier_data}  headers=${headers}  expected_status=anything
        Should Be Equal As Strings  ${response}  <Response [201]>
        ${new_carrier_id}  Set Variable    ${response.json()}[details][data][carrier_id]
        ${new_contract_id}    Get Carrier Contract Id    ${new_carrier_id}
        ${deleteContractRequestEndpoint}  catenate  ${creditcontract}/contracts/${new_contract_id}/carrier/${new_carrier_id}
        ${response}  DELETE  ${deleteContractRequestEndpoint}  headers=${headers}  expected_status=anything
        Should Be Equal As Strings  ${response}  <Response [200]>
    END

Get Carrier Contract Id
    [Documentation]    Get the contract id from carrier
    [Arguments]    ${new_carrier_id}

    Get Into DB    TCH
    ${query}    Catenate    SELECT contract_id
    ...    FROM contract
    ...    WHERE carrier_id = '${new_carrier_id}';
    ${new_contract_id}    Query And Strip    ${query}
    [Return]    ${new_contract_id}

Get Valid Carrier ID
    [Documentation]    Get available valid carrier id

    Get Into DB    TCH
    ${query}    Catenate    SELECT member_id
    ...    FROM member
    ...    WHERE member_id >= 7000000
    ...    AND status = 'A'
    ...    AND member_id NOT IN
    ...    (SELECT carrier_id
    ...    FROM contract
    ...    WHERE carrier_id >= 7000000)
    ...    LIMIT 1;
    ${carrier_id}    Query And Strip    ${query}
    Set Suite Variable    ${carrier_id}

Get Invalid Carrier ID
    [Documentation]    Get already used carrier id

    Get Into DB    TCH
    ${query}    Catenate    SELECT member_id
    ...    FROM member
    ...    WHERE member_id >= 7000000
    ...    AND status = 'A'
    ...    AND member_id IN
    ...    (SELECT carrier_id
    ...    FROM contract
    ...    WHERE carrier_id >= 7000000)
    ...    LIMIT 1;
    ${used_carrier}    Query And Strip    ${query}
    Set Test Variable    ${used_carrier}

Get Next Contract ID
    [Documentation]    Get next available id for a new contract

    Get Into DB    TCH
    ${query}    Catenate    SELECT contract_id
    ...    FROM contract
    ...    ORDER BY contract_id DESC
    ...    LIMIT 1;
    ${contract_id}    Query And Strip    ${query}
    ${contract_id}    Evaluate    ${contract_id} + 1
    Set Test Variable    ${contract_id}

Get Default Policy Values
    [Documentation]    Get default values for policy data

    ${plc_default_columns}    Create List    usetype    fueltype    print_ticket    paperless    cadv_req_fuel
    ...    cadv_min_fuel    managed_fuel    managed_non_fuel    day_cnt_limit    day_amt_limit    week_cnt_limit
    ...    week_amt_limit    mon_cnt_limit    mon_amt_limit    payr_contract_id    min_bal_amount    use_info_template
    ...    show_price    force_one_time_cash    truckmover_status    price_locator_disc_percent    price_locator_disc_cap
    ...    secure_fuel_rules
    Set Suite Variable    ${plc_default_columns}
    Get Into DB    TCH
    ${query}    Catenate    SELECT *
    ...    FROM issuer_defcard_dflt
    ...    WHERE issuer_id = '${issuer_id}';
    ${plc_default_values}    Query And Strip to Dictionary    ${query}
    Set Suite Variable    ${plc_default_values}

Get Default Carrier Group Values
    [Documentation]    Get default values for policy data

    ${car_group_default_columns}    Create List    handenter    servicetype    autoclose    payr_atm    payr_chk    payr_ach
    ...    payr_wire    payr_debit
    Set Suite Variable    ${car_group_default_columns}
    Get Into DB    TCH
    ${query}    Catenate    SELECT *
    ...    FROM carrier_group_dflt
    ...    WHERE parent_contract = '${parent_contract}';
    ${car_group_default_values}    Query And Strip to Dictionary    ${query}
    Set Suite Variable    ${car_group_default_values}

Get Default Contract Values
    [Documentation]    Get default values for contract data

    ${cont_def_columns}    Create List    status    terms    credit_limit    daily_limit    credit_bal    daily_bal
    ...    trans_limit    cash_trans_limit    last_trans    limit_method    cash_adv_allowed    phonecards_allowed
    ...    carrier_fee    cash_adv_fee    combination_fee    mcode_fee_type    mcode_tier_amt    check_fee
    ...    chks_per_fee    tch_check_fee    cut_off    regions_flag    tax_id    cycle_code    atm_denial_fee
    ...    atm_bal_fee    atm_allowed    country    daily_cadv_limit    daily_code_limit    daily_code_bal
    ...    shell_acct_num    out_of_network_fee    network_id    carr_fee_type    allow_1_hour_rule    allow_15_dlr_rule
    ...    velocity_amt    day_cnt_limit    day_amt_limit    week_cnt_limit    week_amt_limit    mon_cnt_limit
    ...    mon_amt_limit    write_jrnl_record    bill_on_master    contract_debit
    ...    daily_cadv_bal    atm_denial_fee_off    atm_denial_drvrpay
    Set Suite Variable    ${cont_def_columns}
    Get Into DB    TCH
    ${query}    Catenate    SELECT *
    ...    FROM contract_default
    ...    WHERE issuer_id = '${issuer_id}';
    ${cont_default_values}    Query And Strip to Dictionary    ${query}
    Set Suite Variable    ${cont_default_values}

Get Default Contract Misc Values
    [Documentation]    Get default values for contract data

    ${cont_misc_def_columns}    Create List    max_money_code    reg_check_flag    fee_flag    mgr_code
    ...    controls_funded_split    logo_name    ach_max_amt    use_one_time_cash_first
    Set Suite Variable    ${cont_misc_def_columns}
    Get Into DB    TCH
    ${query}    Catenate    SELECT *
    ...    FROM contract_default
    ...    WHERE issuer_id = '${issuer_id}';
    ${cont_misc_default_values}    Query And Strip to Dictionary    ${query}
    Set Suite Variable    ${cont_misc_default_values}

Get Bearer Token
    [Documentation]   Gets the token for testing the endpoints at DIT
    ${tokenEndpoint}  catenate  ${OAuth2API}/oauth2/aus1trn5zoTQ3XSgh1d7/v1/token

    ${data}  Create dictionary  grant_type=client_credentials  client_id=${OTR_DynamicPinTest_clientId}  client_secret=${OTR_DynamicPinTest_secret}  scope=otr-service
    ${response}  POST  ${OAuth2API}/oauth2/aus1trn5zoTQ3XSgh1d7/v1/token  data=${data}

    Should Be Equal As Strings  ${response.reason}  OK
    Dictionary Should Contain Key  ${response.json()}  access_token

    ${bearerToken}  Set Variable  Bearer ${response.json()}[access_token]
    Set Suite Variable   ${bearerToken}

POST Request Create Contract
    [Documentation]  Makes a post request to the endpoint
    [Arguments]  ${data}  ${headers}

    ${response}  POST  ${requestEndpoint}  json=${data}  headers=${headers}  expected_status=anything
    Set Test Variable    ${response}

POST Several Requests Create Contract
    [Documentation]  Makes several post requests to the endpoint

    ${data}    Create Dictionary    carrier_id=${carrier_id}    issuer_id=${issuer_id}    parent_id=${parent_carrier_id}
    ${headers}  Create Dictionary  Content-Type=application/json  Authorization=${bearerToken}

    ${contract_ids}    Create List
    Get Next Contract ID
    ${post_carrier_id}    Set Variable    ${carrier_id}
    FOR    ${index}    IN RANGE    10
        # Ensure no contract exists
        ${del_contract_id}    Get Carrier Contract Id    ${post_carrier_id}
        ${deleteContractRequestEndpoint}  catenate  ${creditcontract}/contracts/${del_contract_id}/carrier/${post_carrier_id}
        ${response}  DELETE  ${deleteContractRequestEndpoint}  headers=${headers}  expected_status=anything
        # Create the contract
        ${response}  POST  ${requestEndpoint}  json=${data}  headers=${headers}  expected_status=anything
        Append to List    ${contract_ids}    ${response.json()}[details][data][contract_id]
        ${post_carrier_id}    Evaluate    ${post_carrier_id}+1
        Set To Dictionary    ${data}    carrier_id=${post_carrier_id}
    END
    Set Test Variable    ${contract_ids}

Send Request for '${validation}'
    [Documentation]    Setup and post requests to the endpoint

    ${data}    Create Dictionary    carrier_id=${carrier_id}    issuer_id=${issuer_id}    parent_id=${parent_carrier_id}

    IF  '${validation}' == 'invalid unexistent issuer id'
        Set To Dictionary    ${data}    issuer_id=0
    ELSE IF  '${validation}' == 'invalid unexistent parent carrier id'
        Set To Dictionary    ${data}    parent_id=0
    ELSE IF  '${validation}' == 'invalid unexistent carrier id'
        Set To Dictionary    ${data}    carrier_id=0
    ELSE IF    '${validation}' == 'required carrier id'
        Remove From Dictionary    ${data}       carrier_id
    ELSE IF    '${validation}' == 'required issuer id'
        Remove From Dictionary    ${data}       issuer_id
    ELSE IF    '${validation}' == 'required parent id'
        Remove From Dictionary    ${data}       parent_id
    ELSE IF    '${validation}' == 'carrier already used'
        Get Invalid Carrier ID
        Set To Dictionary    ${data}    carrier_id=${used_carrier}
    END

    IF  '${validation}' == 'unauthorized'
        ${headers}  Create Dictionary  Content-Type=application/json
    ELSE
        ${headers}  Create Dictionary  Content-Type=application/json  Authorization=${bearerToken}
    END

    Run Keyword If    '${validation}' == 'create contract successfully'    Run Keywords    Get Next Contract ID
    ${contract_id}    Evaluate    ${contract_id}+11
    Set Test Variable    ${contract_id}
    ${response}  POST Request Create Contract  ${data}  ${headers}

Check Response for '${validation}'
    [Documentation]    Check response data from endpoint

    IF  '${validation}' == 'invalid unexistent issuer id'
        Should Be Equal As Strings  ${response}  <Response [422]>
        Should Be Equal As Strings  ${response.json()}[name]  ISSUER_NOT_FOUND
        Should Be Equal As Strings  ${response.json()}[error_code]  ISSUER_NOT_FOUND
        Should Be Equal As Strings  ${response.json()}[message]      Issuer ID invalid or not found
    ELSE IF  '${validation}' == 'required issuer id'
        Should Be Equal As Strings  ${response}  <Response [422]>
        Should Be Equal As Strings  ${response.json()}[name]  REQUIRED_FIELDS
        Should Be Equal As Strings  ${response.json()}[error_code]  REQUIRED_FIELDS
        Should Be Equal As Strings  ${response.json()}[message]      Issuer ID, Carrier ID and Parent ID are required. Cannot create a Contract and Policy
    ELSE IF  '${validation}' == 'invalid unexistent parent carrier id'
        Should Be Equal As Strings  ${response}  <Response [422]>
        Should Be Equal As Strings  ${response.json()}[name]  PARENT_NOT_FOUND
        Should Be Equal As Strings  ${response.json()}[error_code]  PARENT_NOT_FOUND
        Should Be Equal As Strings  ${response.json()}[message]      Parent ID invalid or not found
    ELSE IF  '${validation}' == 'required parent id'
        Should Be Equal As Strings  ${response}  <Response [422]>
        Should Be Equal As Strings  ${response.json()}[name]  REQUIRED_FIELDS
        Should Be Equal As Strings  ${response.json()}[error_code]  REQUIRED_FIELDS
        Should Be Equal As Strings  ${response.json()}[message]      Issuer ID, Carrier ID and Parent ID are required. Cannot create a Contract and Policy
    ELSE IF  '${validation}' == 'invalid unexistent carrier id'
        Should Be Equal As Strings  ${response}  <Response [422]>
        Should Be Equal As Strings  ${response.json()}[name]  CARRIER_NOT_FOUND
        Should Be Equal As Strings  ${response.json()}[error_code]  CARRIER_NOT_FOUND
        Should Be Equal As Strings  ${response.json()}[message]      Carrier ID invalid or not found
    ELSE IF  '${validation}' == 'required carrier id'
        Should Be Equal As Strings  ${response}  <Response [422]>
        Should Be Equal As Strings  ${response.json()}[name]  REQUIRED_FIELDS
        Should Be Equal As Strings  ${response.json()}[error_code]  REQUIRED_FIELDS
        Should Be Equal As Strings  ${response.json()}[message]      Issuer ID, Carrier ID and Parent ID are required. Cannot create a Contract and Policy
    ELSE IF  '${validation}' == 'create contract successfully'
        Should Be Equal As Strings  ${response}  <Response [201]>
        Should Be Equal As Strings  ${response.json()}[name]  CREATED
        Should Be Equal As Strings  ${response.json()}[details][type]  CreateContractResponseDTO
        Should Be Equal As Strings  ${response.json()}[details][data][contract_id]  ${contract_id}
        Should Be Equal As Strings  ${response.json()}[details][data][policy]  1
        Should Be Equal As Strings  ${response.json()}[message]  SUCCESSFUL
    ELSE IF  '${validation}' == 'unauthorized'
        Should Be Equal As Strings  ${response}  <Response [401]>
    ELSE IF    '${validation}' == 'carrier already used'
        Should Be Equal As Strings  ${response}  <Response [422]>
        Should Be Equal As Strings  ${response.json()}[name]  CANNOT_CREATE_POLICY
        Should Be Equal As Strings  ${response.json()}[error_code]  CANNOT_CREATE_POLICY
        Should Be Equal As Strings  ${response.json()}[message]      Policy was already created. Cannot create a Policy for the given Carrier
    END

Check New Contract in DB
    [Documentation]    Check info in database from new contract

    Get Into DB    TCH
    ${query}    Catenate    SELECT * FROM contract WHERE contract_id = '${contract_id}';
    ${contract_info}    Query and Strip to Dictionary    ${query}
    FOR    ${column}    IN    @{cont_def_columns}
            ${exp_data}    Get From Dictionary    ${cont_default_values}    ${column}
            ${data}    Get From Dictionary    ${contract_info}    ${column}
            Should Be Equal as Strings    ${data}    ${exp_data}
    END
    ${query}    Catenate    SELECT * FROM cont_misc WHERE contract_id = '${contract_id}';
    ${contract_info}    Query and Strip to Dictionary    ${query}
    FOR    ${column}    IN    @{cont_misc_def_columns}
            ${exp_data}    Get From Dictionary    ${cont_misc_default_values}    ${column}
            ${data}    Get From Dictionary    ${contract_info}    ${column}
            Should Be Equal as Strings    ${data}    ${exp_data}
    END
    ${query}    Catenate    SELECT * FROM def_card WHERE id = '${carrier_id}';
    ${policy_info}    Query and Strip to Dictionary    ${query}
    ${ipolicy}    Get From Dictionary    ${policy_info}    ipolicy
    Should Be Equal as Strings    1    ${ipolicy}
    FOR    ${column}    IN    @{plc_default_columns}
            ${exp_data}    Get From Dictionary    ${plc_default_values}    ${column}
            ${data}    Get From Dictionary    ${policy_info}    ${column}
            Should Be Equal as Strings    ${data}    ${exp_data}
    END
    FOR    ${column}    IN    @{car_group_default_columns}
            ${exp_data}    Get From Dictionary    ${car_group_default_values}    ${column}
            ${data}    Get From Dictionary    ${policy_info}    ${column}
            Should Be Equal as Strings    ${data}    ${exp_data}
    END
    # Verify AR number unique
    ${query}    Catenate    SELECT vendor_id
    ...    FROM carrier_group_xref
    ...    WHERE parent = '${parent_carrier_id}'
    ...    AND carrier_id = '${carrier_id}';
    ${ar_number}    Query And Strip    ${query}
    ${query}    Catenate    SELECT * FROM carrier_group_xref WHERE vendor_id = ${ar_number};
    Row Count is Equal to X  ${query}  1
    ${query}    Catenate    SELECT * FROM contract WHERE ar_number = '${ar_number}';
    Row Count is Equal to X  ${query}  1

Check for several created contracts
    [Documentation]    Check data from several contracts created

    FOR    ${contract}    IN    @{contract_ids}
        Should Be Equal As Strings  ${contract}  ${contract_id}
        Check New Contract in DB
        ${contract_id}    Evaluate    ${contract_id} + 1
        ${carrier_id}    Evaluate    ${carrier_id} + 1
    END