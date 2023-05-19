*** Settings ***
Library     RequestsLibrary
Library     Collections
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Suite Setup  Run Keywords    Setup for Create Carrier API    Get Default Policy Values    Get Default Contract Values
...    Get Default Contract Misc Values    Get Default Carrier Group Values
Suite Teardown    Disconnect From Database

Force Tags  carrierServiceAPI  API  ditOnly

*** Variable ***
${bearerToken}
${requestEndpoint}
${value}
${carrier_id}
${response}
${name}    Name
${street_address}    Street
${city}    City
${state}    XX
${country}    US
${phone}    1111111111
${zip}    12345
${email}    test@mail.com
${issuer_id}    198796
${parent_carrier_id}    378409
${parent_contract}    486655

*** Test Cases ***
Create Carrier - Invalid issuer id
    [Documentation]   Ensure the API returns error when the issuer id is invalid
    [Tags]   Q1:2023    JIRA:ATLAS-2317    JIRA:ATLAS-2396    JIRA:BOT-5068    qTest:119618053

    Send Request for 'invalid unexistent issuer id'
    Check Response for 'invalid unexistent issuer id'
    Send Request for 'invalid existent issuer id'
    Check Response for 'invalid existent issuer id'

Create Carrier - Invalid parent id
    [Documentation]   Ensure the API returns error when the parent id is invalid
    [Tags]   Q1:2023   JIRA:ATLAS-2317    JIRA:ATLAS-2396    JIRA:BOT-5068    qTest:119618054

    Send Request for 'invalid unexistent parent carrier id'
    Check Response for 'invalid unexistent parent carrier id'
    Send Request for 'invalid existent parent carrier id'
    Check Response for 'invalid existent parent carrier id'

Create Carrier - Invalid email
    [Documentation]   Ensure the API returns error when the email is invalid
    [Tags]   Q1:2023    JIRA:ATLAS-2317    JIRA:ATLAS-2396    JIRA:BOT-5068    qTest:119618055

    Send Request for 'invalid email without @ and subdomain'
    Check Response for 'invalid email without @ and subdomain'
    Send Request for 'invalid email without subdomain'
    Check Response for 'invalid email without subdomain'
    Send Request for 'invalid email without username'
    Check Response for 'invalid email without username'

Create Carrier - Invalid phone
    [Documentation]   Ensure the API returns error when the phone is invalid
    [Tags]   Q1:2023   JIRA:ATLAS-2317    JIRA:ATLAS-2396    JIRA:BOT-5068    qTest:119618056

    Send Request for 'invalid phone with string'
    Check Response for 'invalid phone with string'
    Send Request for 'invalid phone with special characters'
    Check Response for 'invalid phone with special characters'
    Send Request for 'invalid phone with not enough length'
    Check Response for 'invalid phone with not enough length'
    Send Request for 'invalid phone with exceeding length'
    Check Response for 'invalid phone with exceeding length'

Create Carrier - Invalid country code
    [Documentation]   Ensure the API returns error when the country code is invalid
    [Tags]   Q1:2023    JIRA:ATLAS-2317    JIRA:ATLAS-2396    JIRA:BOT-5068    qTest:119621615

    Send Request for 'invalid country code with string'
    Check Response for 'invalid country code with string'
    Send Request for 'invalid country code with number'
    Check Response for 'invalid country code with number'
    Send Request for 'invalid country code with special character'
    Check Response for 'invalid country code with special character'

Create Carrier successfully
    [Documentation]   Ensure the API allows a carrier creation when all data is correctly inserted
    [Tags]   Q1:2023    JIRA:ATLAS-2317    JIRA:ATLAS-2396    JIRA:BOT-5068    qTest:119621946

    Send Request for 'create carrier successfully'
    Check Response for 'create carrier successfully'
    Check New Carrier in DB
    Check New Contract in DB
    Check New Card in DB

Create Carrier - Required fields
    [Documentation]  Ensure API request returns error when the required fields are not filled
    [Tags]   Q1:2023    JIRA:ATLAS-2317    JIRA:ATLAS-2396   JIRA:BOT-5068    qTest:119622148

    Send Request for 'required fields'
    Check Response for 'required fields'

Create Carrier - API request not authorized
    [Documentation]  Ensure the API request returns error when it's not authorized by the token
    [Tags]   Q1:2023    JIRA:ATLAS-2317    JIRA:ATLAS-2396    JIRA:BOT-5068    qTest:119622418

    Send Request for 'unauthorized'
    Check Response for 'unauthorized'

Create Carrier - Simultaneously creation
    [Documentation]  Ensure carriers has unique carrier ids when using POST several times in a short time period
    [Tags]   Q1:2023    JIRA:ATLAS-2317    JIRA:ATLAS-2396    JIRA:BOT-5068    qTest:119685575

    POST Several Requests Create Carrier
    Check for several created carriers

Create Carrier - Max length characters
    [Documentation]  Ensure fields has a validation for max length characters
    [Tags]   Q1:2023    JIRA:ATLAS-2317    JIRA:ATLAS-2396    JIRA:BOT-5068    qTest:119685595

    Send Request for 'max length characters'
    Check Response for 'max length characters'

*** Keywords ***
Setup for Create Carrier API
    Get Bearer Token
    ${requestEndpoint}  catenate  ${CarrierServiceAPI}/carriers
    Set Suite Variable  ${requestEndpoint}

Get Bearer Token
    [Documentation]   Gets the token for testing the endpoints at DIT
    ${tokenEndpoint}  catenate  ${OAuth2API}/oauth2/aus1trn5zoTQ3XSgh1d7/v1/token

    ${data}  Create dictionary  grant_type=client_credentials  client_id=${OTR_BackOffTest_clientId}  client_secret=${OTR_BackOffTest_secret}  scope=otr-service
    ${response}  POST  ${OAuth2API}/oauth2/aus1trn5zoTQ3XSgh1d7/v1/token  data=${data}

    Should Be Equal As Strings  ${response.reason}  OK
    Dictionary Should Contain Key  ${response.json()}  access_token

    ${bearerToken}  Set Variable  Bearer ${response.json()}[access_token]
    Set Suite Variable   ${bearerToken}

POST Request Create Carrier
    [Documentation]  Makes a post request to the endpoint
    [Arguments]  ${data}  ${headers}

    ${response}  POST  ${requestEndpoint}  json=${data}  headers=${headers}  expected_status=anything
    Set Test Variable    ${response}

POST Several Requests Create Carrier
    [Documentation]  Makes several post requests to the endpoint

    ${data}    Create Dictionary    name=${name}    street_address=${street_address}    city=${city}    state=${state}
    ...    country=${country}    phone=${phone}    zip=${zip}    email=${email}    issuer_id=${issuer_id}
    ...    parent_carrier_id=${parent_carrier_id}
    ${headers}  Create Dictionary  Content-Type=application/json  Authorization=${bearerToken}

    Get Next Carrier ID
    ${carrier_ids}    Create List
    ${card_ids}    Create List
    FOR    ${index}    IN RANGE    10
        ${response}  POST  ${requestEndpoint}  json=${data}  headers=${headers}  expected_status=anything
        Append to List    ${carrier_ids}    ${response.json()}[details][data][carrier_id]
        Append to List    ${card_ids}    ${response.json()}[details][data][card_id]
    END
    Set Test Variable    ${carrier_ids}
    Set Test Variable    ${card_ids}

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
    Set Test Variable    ${carrier_id}

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

    ${data}    Create Dictionary    name=${name}    street_address=${street_address}    city=${city}    state=${state}
    ...    country=${country}    phone=${phone}    zip=${zip}    email=${email}    issuer_id=${issuer_id}
    ...    parent_carrier_id=${parent_carrier_id}

    IF  '${validation}' == 'invalid unexistent issuer id'
        Set To Dictionary    ${data}    issuer_id=0
    ELSE IF  '${validation}' == 'invalid existent issuer id'
        Get Invalid Issuer ID
        Set To Dictionary    ${data}    issuer_id=${issuer_id}
    ELSE IF  '${validation}' == 'invalid unexistent parent carrier id'
        Set To Dictionary    ${data}    parent_carrier_id=0
    ELSE IF  '${validation}' == 'invalid existent parent carrier id'
        Get Invalid Parent Carrier ID
        Set To Dictionary    ${data}    parent_carrier_id=${parent_carrier_id}
    ELSE IF  '${validation}' == 'invalid email without @ and subdomain'
        Set To Dictionary    ${data}    email=test
        Set Test Variable    ${value}    test
    ELSE IF  '${validation}' == 'invalid email without subdomain'
        Set To Dictionary    ${data}    email=test@
        Set Test Variable    ${value}    test@
    ELSE IF  '${validation}' == 'invalid email without username'
        Set To Dictionary    ${data}    email=@test
        Set Test Variable    ${value}    @test
    ELSE IF  '${validation}' == 'invalid phone with string'
        Set To Dictionary    ${data}    phone=abcdefghij
        Set Test Variable    ${value}    abcdefghij
    ELSE IF  '${validation}' == 'invalid phone with special characters'
        Set To Dictionary    ${data}    phone=@#$@#$@#$@
        Set Test Variable    ${value}    @#$@#$@#$@
    ELSE IF  '${validation}' == 'invalid phone with not enough length'
        Set To Dictionary    ${data}    phone=123
        ${value}    Set Variable    123
        Set Test Variable    ${value}
    ELSE IF  '${validation}' == 'invalid phone with exceeding length'
        Set To Dictionary    ${data}    phone=11111111111
        Set Test Variable    ${value}    11111111111
    ELSE IF  '${validation}' == 'invalid country code with string'
        Set To Dictionary    ${data}    country=XX
        Set Test Variable    ${value}    XX
    ELSE IF  '${validation}' == 'invalid country code with number'
        Set To Dictionary    ${data}    country=12
        Set Test Variable    ${value}    12
    ELSE IF  '${validation}' == 'invalid country code with special character'
        Set To Dictionary    ${data}    country=@#
        Set Test Variable    ${value}    @#
    ELSE IF    '${validation}' == 'required fields'
        ${data}    Create Dictionary    test=test
    ELSE IF    '${validation}' == 'max length characters'
        ${thirtychars}    Generate Random String    31
        Set Test Variable    ${thirtychars}
        ${email_data}    Generate Random String    42
        ${email_data}    Catenate    ${email_data}@test.com
        Set Test Variable    ${email_data}
        ${state_data}    Generate Random String    3
        Set Test Variable    ${state_data}
        ${zip_data}    Generate Random String    11    [NUMBERS]
        Set Test Variable    ${zip_data}
        Set To Dictionary    ${data}    name=${thirtychars}
        Set To Dictionary    ${data}    street_address=${thirtychars}
        Set To Dictionary    ${data}    city=${thirtychars}
        Set To Dictionary    ${data}    state=${state_data}
        Set To Dictionary    ${data}    zip=${zip_data}
        Set To Dictionary    ${data}    email=${email_data}
    END

    IF  '${validation}' == 'unauthorized'
        ${headers}  Create Dictionary  Content-Type=application/json
    ELSE
        ${headers}  Create Dictionary  Content-Type=application/json  Authorization=${bearerToken}
    END

    Run Keyword If    '${validation}' == 'create carrier successfully'    Get Next Carrier ID
    ${response}  POST Request Create Carrier  ${data}  ${headers}

Check Response for '${validation}'
    [Documentation]    Check response data from endpoint

    IF  '${validation}' == 'invalid existent issuer id' or '${validation}' == 'invalid unexistent issuer id' or '${validation}' == 'invalid existent parent carrier id' or '${validation}' == 'invalid unexistent parent carrier id'
        Should Be Equal As Strings  ${response}  <Response [422]>
        Should Be Equal As Strings  ${response.json()}[name]  ISSUER_PARENT_NOT_SUPPORTED
        Should Be Equal As Strings  ${response.json()}[error_code]  ISSUER_PARENT_NOT_SUPPORTED
        Should Be Equal As Strings  ${response.json()}[message]      Provided Issuer Id or Parent Id are not supported
    ELSE IF  '${validation}' == 'invalid unexistent parent carrier issuer id'
        Should Be Equal As Strings  ${response}  <Response [422]>
        Should Be Equal As Strings  ${response.json()}[name]  PARENT_NOT_FOUND
        Should Be Equal As Strings  ${response.json()}[error_code]  CHILD_CARRIER_RANGE_NOT_FOUND
        Should Be Equal As Strings  ${response.json()}[message]      provided invalid parent carrier id
    ELSE IF  '${validation}' == 'invalid email without @ and subdomain' or '${validation}' == 'invalid email without subdomain' or '${validation}' == 'invalid email without username'
        Should Be Equal As Strings  ${response}  <Response [400]>
        Should Be Equal As Strings  ${response.json()}[name]  BAD_REQUEST
        Should Be Equal As Strings  ${response.json()}[details][0][field]  email
        Should Be Equal As Strings  ${response.json()}[details][0][value]  ${value}
        Should Be Equal As Strings  ${response.json()}[details][0][issue]  must be a well-formed email address
        Should Be Equal As Strings  ${response.json()}[message]  Invalid request input
    ELSE IF  '${validation}' == 'invalid phone with string' or '${validation}' == 'invalid phone with special characters' or '${validation}' == 'invalid phone with not enough length' or '${validation}' == 'invalid phone with exceeding length'
        Should Be Equal As Strings  ${response}  <Response [400]>
        Should Be Equal As Strings  ${response.json()}[name]  BAD_REQUEST
        Should Be Equal As Strings  ${response.json()}[details][0][field]  phone
        Should Be Equal As Strings  ${response.json()}[details][0][value]  ${value}
        Should Be Equal As Strings  ${response.json()}[details][0][issue]  Accepts only 10 digits, no special characters
        Should Be Equal As Strings  ${response.json()}[message]  Invalid request input
    ELSE IF  '${validation}' == 'invalid country code with string' or '${validation}' == 'invalid country code with number' or '${validation}' == 'invalid country code with special character'
        Should Be Equal As Strings  ${response}  <Response [400]>
        Should Be Equal As Strings  ${response.json()}[name]  BAD_REQUEST
        Should Be Equal As Strings  ${response.json()}[details][0][field]  country
        Should Be Equal As Strings  ${response.json()}[details][0][value]  ${value}
        Should Be Equal As Strings  ${response.json()}[details][0][issue]  Invalid country code
        Should Be Equal As Strings  ${response.json()}[message]  Invalid request input
    ELSE IF  '${validation}' == 'create carrier successfully'
        Should Be Equal As Strings  ${response}  <Response [201]>
        Should Be Equal As Strings  ${response.json()}[name]  OK
        Should Be Equal As Strings  ${response.json()}[details][type]  CreateCarrierResponseDTO
        Should Be Equal As Strings  ${response.json()}[details][data][carrier_id]  ${carrier_id}
        Should Be Equal As Strings  ${response.json()}[message]  SUCCESSFUL
        Set Test Variable    ${card_id}    ${response.json()}[details][data][card_id]
    ELSE IF    '${validation}' == 'required fields'
        Should Be Equal As Strings  ${response}  <Response [400]>
        Should Be Equal As Strings  ${response.json()}[name]  BAD_REQUEST
        Should Be Equal As Strings  ${response.json()}[message]  Invalid request input
        ${name_issue}    Create Dictionary    field=name    issue=Name is required
        ${email_issue}    Create Dictionary    field=email    issue=Email is required
        ${street_issue}    Create Dictionary    field=streetAddress    issue=Street address is required
        ${parent_issue}    Create Dictionary    field=parentCarrierId    issue=Parent Carrier Id is required
        ${city_issue}    Create Dictionary    field=city    issue=City is required
        ${issuerid_issue}    Create Dictionary    field=issuerId    issue=Issuer Id is required
        ${phone_issue}    Create Dictionary    field=phone    issue=phone number is required
        ${country_issue}    Create Dictionary    field=country    issue=Country is required
        ${state_issue}    Create Dictionary    field=state    issue=State is required
        ${zip_issue}    Create Dictionary    field=zip    issue=Zip code is required
        ${test_issue}    Create Dictionary    field=test    issue=Test is required
        ${exp_details}    Create List    ${name_issue}    ${email_issue}    ${street_issue}    ${parent_issue}
        ...    ${city_issue}    ${issuerid_issue}    ${phone_issue}    ${country_issue}    ${state_issue}    ${zip_issue}
        List Should Contain Sub List    ${response.json()}[details]    ${exp_details}
        List Should Not Contain Value    ${response.json()}[details]    ${test_issue}
    ELSE IF  '${validation}' == 'unauthorized'
        Should Be Equal As Strings  ${response}  <Response [401]>
    ELSE IF    '${validation}' == 'max length characters'
        Should Be Equal As Strings  ${response}  <Response [400]>
        Should Be Equal As Strings  ${response.json()}[name]  BAD_REQUEST
        Should Be Equal As Strings  ${response.json()}[message]  Invalid request input
        ${zip_issue}    Create Dictionary    field=zip    value=${zip_data}    issue=Maximum allowed length for zip code is 30
        ${name_issue}    Create Dictionary    field=name    value=${thirtychars}    issue=Maximum allowed length for name is 30
        ${street_issue}    Create Dictionary    field=streetAddress    value=${thirtychars}    issue=Maximum allowed length for address is 30
        ${city_issue}    Create Dictionary    field=city    value=${thirtychars}    issue=Maximum allowed length for city is 30
        ${state_issue}    Create Dictionary    field=state    value=${state_data}    issue=Maximum allowed length for state is 2
        ${email_issue}    Create Dictionary    field=email    value=${email_data}    issue=Maximum allowed length for email is 50
        ${exp_details}    Create List    ${name_issue}    ${email_issue}    ${street_issue}    ${city_issue}
        ...    ${state_issue}    ${zip_issue}
        Log    ${response.json()}[details]
        List Should Contain Sub List    ${response.json()}[details]    ${exp_details}
    END

Check New Carrier in DB
    [Documentation]    Check info in database from new carrier

    Get Into DB    TCH
    ${query}    Catenate    SELECT name, add1, city, state, country, TRIM(cont_phone) as phone, email_addr, TRIM(zip) as zip
    ...    FROM member
    ...    WHERE member_id = '${carrier_id}';
    ${carrier_info}    Query And Strip to Dictionary    ${query}
    Set Test Variable    ${carrier_info}
    Compare data from carrier info    name    ${name}
    Compare data from carrier info    add1    ${street_address}
    Compare data from carrier info    city    ${city}
    Compare data from carrier info    state    ${state}
    Compare data from carrier info    country    ${country}[0]
    Compare data from carrier info    phone    ${phone}
    Compare data from carrier info    email_addr    ${email}
    Compare data from carrier info    zip    ${zip}

Compare data from carrier info
    [Arguments]    ${field}    ${exp_value}
    [Documentation]    Compare data from db and expected one considering a field

    ${value}    Get From Dictionary    ${carrier_info}    ${field}
    Should Be Equal as Strings    ${value}    ${exp_value}

Check for several created carriers
    [Documentation]    Check data from several carriers created

    FOR    ${carrier}    IN    @{carrier_ids}
        Should Be Equal As Strings  ${carrier}  ${carrier_id}
        Check New Carrier in DB
        Check New Contract in DB
        ${carrier_id}    Evaluate    ${carrier_id} + 1
    END
    FOR    ${card_id}    IN    @{card_ids}
        Set Test Variable    ${card_id}
        Check New Card in DB
    END

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

Check New Contract in DB
    [Documentation]    Check info in database from new contract

    Get Into DB    TCH
    ${query}    Catenate    SELECT contract_id FROM contract WHERE carrier_id = '${carrier_id}';
    ${contract_id}    Query And Strip    ${query}
    Set Test Variable    ${contract_id}
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