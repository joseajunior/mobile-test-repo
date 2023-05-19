*** Settings ***
Library         String
Library         otr_robot_lib.ws.PortalWS
Library         otr_model_lib.services.GenericService
Library         Collections
Library         otr_robot_lib.ws.OKTA_Automation_User.OKTA_Automation_User
Library         otr_robot_lib.ws.UserServiceAPI.UserAPIService
Library         otr_robot_lib.ws.RestAPI.RestAPIService
Resource        otr_robot_lib/robot/APIKeywords.robot

Documentation  Tests the GETCardSummaries endpoint in the OTR-Cards controller
...  within the Cards API Services

Force Tags  ditOnly  CardServicesAPI  API
Suite Setup  Check For My Automation User
Suite Teardown  Remove User if Still exists

*** Variables ***
&{default_options}      page=0  size=10
&{card_types}  universal=B  payroll=P  company=C

#TODO update test when O5SA-329 and 330 are implemented
*** Test Cases ***
GET Card Summaries
    [Documentation]  Test card summaries with good data
    [Tags]  JIRA:FIVE-158  qTest:54194382  PI:14  OTR-Cards
    [Setup]  Generate Data for Request
    Send GET API Request for Card Summaries
    Compare GET Endpoint Results
    [Teardown]  Remove User if Necessary

GET Card Summaries with Universal Card
    [Documentation]  Test card summaries with good data
    [Tags]  JIRA:O5SA-422  qTest:116723315  PI:14  OTR-Cards
    [Setup]  Generate Data for Request  B  Y
    Send GET API Request for Card Summaries
    Compare GET Endpoint Results
    [Teardown]  Remove User if Necessary  Y

GET Card Summaries with Negative Paging
    [Documentation]  Test card summaries with good data and negative page size
    [Tags]  JIRA:FIVE-158  qTest:54194382  PI:14  OTR-Cards
    [Setup]  Generate Data for Request
    Send GET API Request for Card Summaries with Negative Page
    Compare GET Endpoint Results
    [Teardown]  Remove User if Necessary

GET Card Summaries with Negative Sizing
    [Documentation]  Test card summaries with good data and a negative size
    [Tags]  JIRA:FIVE-158  qTest:54194382  PI:14  OTR-Cards
    [Setup]  Generate Data for Request
    Send GET API Request for Card Summaries with Negative Size
    Compare GET Endpoint Results
    [Teardown]  Remove User if Necessary

GET Card Summaries with Different Paging Optionals
    [Documentation]  Test card summaries with good data and various other optionals
    ...  example: send request using a page or size as a letter instead of number
    [Tags]  JIRA:FIVE-158  qTest:54194382  PI:14  OTR-Cards
    [Setup]  Generate Data for Request
    Send GET API Request for Card Summaries with Paging Optionals
    Compare GET Endpoint Results
    [Teardown]  Remove User if Necessary

GET Card Summaries using Invalid Token
    [Documentation]  Test card summaries with an invalid token
    [Tags]  JIRA:FIVE-158  qTest:116585298  PI:14  OTR-Cards
    [Setup]  Generate Data for Request
    GET Card Summaries using Invalid Token
    [Teardown]  Remove User if Necessary

*** Keywords ***
Generate Data for Request
    [Documentation]  gets necessary information to run tests
    [Arguments]  ${card_type}=${NONE}  ${reset_user_status}=N
    Getting API URL
    ${api_data_value}  Get Variable Value  $api_data  default
    ${user_value}  Get Variable Value  $user_status  default
    IF  $api_data_value=='default'
        ${my_carrier_id}  Find Carrier in Oracle  A
        Set Suite Variable  ${my_carrier_id}
    END
    IF  '${card_type}'!='${NONE}'
        ${card_info}  Find Card Type in Oracle  payr_type=${card_type}
#        set suite variable  ${user_status}  default
        ${my_carrier_id}  Set Variable  ${card_info}[carrier_id]
    END
    Create My User         persona_name=carrier_manager  entity_id=${my_carrier_id}  with_data=N  need_new_user=${reset_user_status}
    ${values}  Find Data to be Used for Requests  ${my_carrier_id}
    Set Suite Variable  ${api_data}  ${values}

Getting API URL
    [Documentation]  get url to be used for tests
    Get url for suite    ${cardsservice}

Find Data to be Used for Requests
    [Documentation]  get the data to be used in the request
    [Arguments]  ${my_carrier_id}
    Get into DB  TCH
    ${count}  Catenate  select count(*) from contract where carrier_id = ${my_carrier_id}
    ${count_results}  Query and Return Dictionary Rows  ${count}
    ${rand_num}  Evaluate  random.randint(0, (${count_results}[0][1] - 1))  random
    ${tch_query}  Catenate  select skip ${rand_num}
    ...  co.carrier_id,
    ...  co.ar_number,
    ...  co.contract_id,
    ...  ca.card_id,
    ...  CASE WHEN (SELECT COUNT(co1.issuer_id)
    ...             FROM contract co1, carrier_group_issuer cgi1
    ...             WHERE co1.carrier_id = ${my_carrier_id}
    ...             AND cgi1.issuer_id = co1.issuer_id) > 0 THEN TRIM('parent_funded')
    ...       WHEN (SELECT COUNT(co1.issuer_id)
    ...             FROM contract co1, carrier_group_issuer cgi1
    ...             WHERE co1.carrier_id = ${my_carrier_id}
    ...  AND cgi1.issuer_id = co1.issuer_id) < 0 THEN TRIM('credit')
    ...       ELSE 'carrier_parent'
    ...  END AS contract_type
    ...  from contract co, cards ca
    ...  where co.carrier_id = ${my_carrier_id}
    ...  and co.carrier_id = ca.carrier_id
    ...  and ca.payr_use != ''
    ...  limit 1
    ${url_values}  Query and Strip to Dictionary  ${tch_query}
    Disconnect from Database
    [Return]  ${url_values}

Send ${response_type} API Request for Card Summaries
    [Documentation]  used to call the card summaries endpoint
    Send Request  response_type=${response_type}

Send Request
    [Documentation]  sends request to endpoint
    [Arguments]  ${carrier}=${api_data}[carrier_id]  ${optionals}=${default_options}  ${response_type}=GET
    ${optionals_nested_len}  Evaluate  sum(len(k) for k in $optionals.keys() if k.isdigit())
    Set Test Variable  ${optionals_nested_len}
    ${url}  Create Dictionary  carriers=${carrier}
    IF  ${optionals}==${default_options}
        Set Test Variable  ${optionals}  ${default_options}
    ELSE
        Set Test Variable  ${optionals}  ${optionals}
    END

    IF  ${optionals}==${NONE}
        ${response}  ${status}  Api Request  ${response_type}  card-summaries  Y  ${url}  application=OTR_eMgr
    ELSE
        IF  ${optionals_nested_len}>0
            FOR  ${i}  IN RANGE  ${optionals_nested_len}
                ${options}  Evaluate  $optionals.get('${i+1}')
                ${response}  ${status}  Api Request  ${response_type}  card-summaries  Y  ${url}  ${options}
                ...                                  application=OTR_eMgr
                Set Test Variable  ${response${i+1}}  ${response}
                Set Test Variable  ${status${i+1}}  ${status}
            END
        ELSE
            ${response}  ${status}  Api Request  ${response_type}  card-summaries  Y  ${url}  ${optionals}
            ...                                  application=OTR_eMgr
        END
    END
    Set Test Variable  ${response}
    Set Test Variable  ${status}

Send ${response_type} API Request for Card Summaries with ${option}
    [Documentation]  used to call the card summaries endpoint
    IF  '${option.upper()}'=='NEGATIVE PAGE'
        &{options_dict}      Create Dictionary      page=-1  size=5
        Set Test Variable  ${optionals}  ${options_dict}
        Send Request  optionals=${optionals}
    ELSE IF  '${option.upper()}'=='NEGATIVE SIZE'
        &{options_dict}  Create Dictionary  page=0  size=-5
        Set Test Variable  ${optionals}  ${options_dict}
        Send Request  optionals=${optionals}
    ELSE IF  '${option.upper()}'=='PAGING OPTIONALS'
        &{letter_for_page}  Create Dictionary  page=a  size=5
        &{letter_for_size}  Create Dictionary  page=0  size=p
        #use numbers as the keys if needing to add different page/size options
        &{options_dict}  Create Dictionary  1=${letter_for_page}  2=${letter_for_size}
        Set Test Variable  ${optionals}  ${options_dict}
        Send Request  optionals=${optionals}
    ELSE
        tch logging  case ${option.upper()} not handled
    END

Compare GET Endpoint Results
    [Documentation]  compare endpoint response with data from database
    ${result_from_DB}  Get Endpoint values from DB
    IF  '${result_from_DB}[0][card_type]'=='P'
         ${card_type}   Set Variable   SMART_FUNDS_CARD
    ELSE IF  '${result_from_DB}[0][card_type]'=='B'
         ${card_type}   Set Variable   UNIVERSAL_CARD
    ELSE
         ${card_type}   Set Variable   COMPANY_CARD
    END

    IF  ${optionals_nested_len}==0
        Should Be Equal As Strings      ${response}[details][data][0][bin]                  ${result_from_DB}[0][bin]
        Should Be Equal As Strings      ${response}[details][data][0][card_id]              ${result_from_DB}[0][card_id]
        Should Be Equal As Strings      ${response}[details][data][0][card_policy]          ${result_from_DB}[0][card_policy]
        Should Be Equal As Strings      ${response}[details][data][0][card_status]          ${result_from_DB[0]['card_status'].strip()}
        Should Be Equal As Strings      ${response}[details][data][0][card_type]            ${card_type}
        Should Be Equal As Strings      ${response}[details][data][0][carrier_id]           ${result_from_DB}[0][carrier_id]
        Should Be Equal As Strings      ${response}[details][data][0][contract_id]          ${result_from_DB}[0][contract_id]
        Should Be Equal                 ${response}[details][data][0][masked_card_number]   ${result_from_DB[0]['masked_card_number'].strip()}
        IF  'unit' in $response['details']['data'][0]
            Should Be Equal                 ${response}[details][data][0][unit]                 ${result_from_DB[0]['unit'].strip()}
        END
        IF  '${card_type}'=='UNIVERSAL_CARD'
            Should Be Equal As Strings  ${response}[details][data][0][payr_status]     ${result_from_DB[0]['payr_status'].strip()}
            Should Be Equal As Strings  ${response}[details][data][0][payr_contract_id]     ${result_from_DB}[0][payr_contract_id]
        ELSE
            Dictionary Should Not Contain Key  ${response}[details][data][0]  payr_status
            Dictionary Should Not Contain Key  ${response}[details][data][0]  payr_contract_id
        END
        Should Be Equal As Strings      ${response}[details][data][0][last_four]            ${result_from_DB}[0][last_four]
        Should Be Equal As Strings  ${status}  200
    ELSE
        FOR  ${i}  IN RANGE  ${optionals_nested_len}
            Should Be Equal As Strings      ${response${i+1}}[details][data][0][bin]                  ${result_from_DB}[0][bin]
            Should Be Equal As Strings      ${response${i+1}}[details][data][0][card_id]              ${result_from_DB}[0][card_id]
            Should Be Equal As Strings      ${response${i+1}}[details][data][0][card_policy]          ${result_from_DB}[0][card_policy]
            Should Be Equal As Strings      ${response${i+1}}[details][data][0][card_status]          ${result_from_DB[0]['card_status'].strip()}
            Should Be Equal As Strings      ${response${i+1}}[details][data][0][card_type]            ${card_type}
            Should Be Equal As Strings      ${response${i+1}}[details][data][0][carrier_id]           ${result_from_DB}[0][carrier_id]
            Should Be Equal As Strings      ${response${i+1}}[details][data][0][contract_id]          ${result_from_DB}[0][contract_id]
            Should Be Equal                 ${response${i+1}}[details][data][0][masked_card_number]   ${result_from_DB[0]['masked_card_number'].strip()}
            IF  'unit' in ${response${i+1}}[details][data][0]
                Should Be Equal                 ${response${i+1}}[details][data][0][unit]                 ${result_from_DB[0]['unit'].strip()}
            END
            IF  '${card_type}'=='UNIVERSAL_CARD'
                Should Be Equal As Strings  ${response${i+1}}[details][data][0][payr_status]     ${result_from_DB[0]['payr_status'].strip()}
                Should Be Equal As Strings  ${response${i+1}}[details][data][0][payr_contract_id]     ${result_from_DB}[0][payr_contract_id]
            ELSE
                Dictionary Should Not Contain Key  ${response${i+1}}[details][data][0]  payr_status
                Dictionary Should Not Contain Key  ${response${i+1}}[details][data][0]  payr_contract_id
            END
            Should Be Equal As Strings      ${response${i+1}}[details][data][0][last_four]            ${result_from_DB}[0][last_four]
            Should Be Equal As Strings  ${status${i+1}}  200
        END
    END

Get Endpoint values from DB
    [Documentation]  get the request response data from database
    ${page}  ${size}  Check Optionals

    Get into DB  TCH
    ${query}        Catenate        select skip ${page} first ${size} cs.card_id as card_id,
    ...                             cs.card_bin as bin, cs.policy as card_policy, cs.card_status as card_status,
    ...                             cs.carrier_id as carrier_id, cs.contract_id as contract_id, cs.drid as driver_id,
    ...                             cs.driver_name as driver_name, cs.card_last_4 as last_four,
    ...                             cs.masked_card_num as masked_card_number, cs.payr_contract_id as payr_contract_id,
    ...                             cs.payr_use as card_type, cs.unit as unit, cs.payr_status as payr_status
    ...                             from cards_search cs
    ...                             where cs.carrier_id='${api_data}[carrier_id]' and (cs.card_status in ('ACTIVE','INACTIVE','HOLD')) and (upper(cs.masked_card_num) not like '%over%')
    ...                             order by cs.driver_name asc
    ${result_list}      Query To Dictionaries   ${query}
    Disconnect from Database
    [Return]            ${result_list}

Check Optionals
    [Documentation]  modify optionals (page and size) for sql queries to use
    ${check_page}  Run Keyword and Ignore Error  Get from Dictionary  ${optionals}  page
    ${check_size}  Run Keyword and Ignore Error  Get from Dictionary  ${optionals}  size

    IF  'PASS' in """${check_page}"""
        ${is_page_alpha}  Evaluate  $optionals['page'].isalpha()
    ELSE
        ${page}  Set Variable  0
    END

    IF  'PASS' in """${check_size}"""
        ${is_size_alpha}  Evaluate  $optionals['size'].isalpha()
    ELSE
        ${size}  Set Variable  10
    END

    Return from Keyword if  'FAIL' in """${check_page}""" and 'FAIL' in """${check_size}"""  ${page}  ${size}

    IF  ${is_page_alpha}==${FALSE}
        ${is_page_int}  Get from Dictionary  ${optionals}  page
    END

    IF  ${is_size_alpha}==${FALSE}
        ${is_size_int}  Get from Dictionary  ${optionals}  size
    END

    IF  ${is_page_alpha}==${TRUE}
        ${page}  Set Variable  0
    ELSE IF  ${is_page_int} <= 0
        ${page}  Set Variable  0
    ELSE IF  (${is_page_int} >= 0 and ${is_size_int} < 0) or (${is_page_int} >= 0 and ${is_size_alpha} == ${TRUE})
        ${new_page}  Evaluate  ${is_page_int}
        ${page}  Set Variable  ${new_page}
    ELSE IF  ${is_page_int} >= 0 and ${is_size_int} >= 0
        ${new_page}  Evaluate  ${is_page_int} * ${is_size_int}
        ${page}  Set Variable  ${new_page}
    ELSE
        ${page}  Set Variable  0
    END

    IF  ${is_size_alpha}==${TRUE}
        ${size}  Set Variable  10
    ELSE IF  ${is_size_int} <= 0
        ${size}  Set Variable  10
    ELSE
        ${size}  Set Variable  ${is_size_int}
    END

    [Return]  ${page}  ${size}

${response_type} Card Summaries using ${error}
    [Documentation]  Check for appropriate response for errors
    IF  '${error.upper()}'=='INVALID TOKEN'
        ${url}                 Create Dictionary   carriers=${api_data}[carrier_id]
        ${result}  ${status}   Api request  GET    card-summaries   I  ${url}  application=OTR_eMgr

        Should Be Equal As Strings    ${status}     401
        Should Be Empty               ${result}
    ELSE
        Fail  Error '${error.upper()}' not implemented
    END