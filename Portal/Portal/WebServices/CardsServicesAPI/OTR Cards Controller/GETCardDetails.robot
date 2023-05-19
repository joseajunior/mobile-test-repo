*** Settings ***
Library         String
Library         otr_robot_lib.ws.PortalWS
Library         otr_model_lib.services.GenericService
Library         Collections
Library         otr_robot_lib.ws.OKTA_Automation_User.OKTA_Automation_User
Library         otr_robot_lib.ws.UserServiceAPI.UserAPIService
Library         otr_robot_lib.ws.RestAPI.RestAPIService
Resource        otr_robot_lib/robot/APIKeywords.robot

Documentation  Tests the GETCardDetails endpoint in the OTR-Cards controller
...  within the Cards API Services.

Force Tags  ditOnly  CardServicesAPI  API
Suite Setup  Check for My Automation User
Suite Teardown  Remove User if Still exists

*** Variables ***

#TODO update test when O5SA-329 and 330 are implemented
*** Test Cases ***
GET Card Details
    [Tags]               JIRA:O5SA-163  qTest:54764435  OTR-Cards
    [Setup]  Generate Data for Request
    Send GET API Request for Card Details
    Compare GET Endpoint Results
    [Teardown]  Remove User if Necessary

GET Card Details using Invalid Token
    [Tags]               JIRA:O5SA-163  qTest:54764435  OTR-Cards
    [Setup]  Generate Data for Request
    GET Card Details using Invalid Token
    [Teardown]  Remove User if Necessary

*** Keywords ***
Generate Data for Request
    [Documentation]  gets necessary information to run tests
    [Arguments]  ${reset_user_status}=N
    Getting API URL
    ${api_data_value}  get variable value  $api_data  default
    ${user_value}  get variable value  $user_status  default
    IF  $api_data_value=='default'
        ${my_carrier_id}  Find Carrier in Oracle  A
        Set Suite Variable  ${my_carrier_id}
    END
    Create My User  persona_name=carrier_manager  entity_id=${my_carrier_id}  with_data=N  need_new_user=${reset_user_status}
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

Send ${response_type} API Request for Card Details
    [Documentation]  used to call the card details endpoint
    Send Request  response_type=${response_type}

Send Request
    [Documentation]  send request to endpoint
    [Arguments]  ${carrier}=${api_data}[carrier_id]  ${card}=${api_data}[card_id]  ${response_type}=GET

    ${url}  create dictionary  None=${card}  carriers=${carrier}
    ${response}  ${status}  Api Request  ${response_type}  otr-cards  Y  ${url}  application=OTR_eMgr

    Set Test Variable  ${response}
    Set Test Variable  ${status}

Compare GET Endpoint Results
    ${result_from_DB}  Get Endpoint values from DB

    Should Be Equal As Strings      ${response}[details][data][card_id]              ${result_from_DB}[0][card_id]
    Should Be Equal As Strings      ${response}[details][data][policy_number]        ${result_from_DB}[0][policy_number]
    Should Be Equal As Strings      ${response}[details][data][card_status]          ${result_from_DB[0]['card_status'].strip()}
    Should Be Equal As Strings      ${response}[details][data][card_type]            ${result_from_DB}[0][card_type]
    IF  'unit_number' in $response['details']['data']
        Should Be Equal                 ${response}[details][data][unit_number]                 ${result_from_DB[0]['unit_number'][1:]}
    END
    IF  'driver_name' in $response['details']['data']
            Should Be Equal                 ${response}[details][data][driver_name]                 ${result_from_DB[0]['driver_name'][1:]}
    END
    IF  '*' not in $response['details']['data']['card_number']
        FAIL  card not masked
    END
    Should Contain  ${response}[details][data]  links
    Should Be Equal As Strings  ${status}  200

Get Endpoint values from DB
    [Documentation]  get the request response data from database

    Get into DB  TCH
    ${query}        Catenate        SELECT
    ...  c.card_id,
    ...  TRIM(c.card_num) AS card_number,
    ...  c.icardpolicy AS policy_number,
    ...  CASE WHEN c.payr_use = 'N' THEN 'COMPANY_CARD'
    ...     WHEN c.payr_use = 'B' THEN 'UNIVERSAL_CARD'
    ...     WHEN c.payr_use = 'P' THEN 'SMART_FUNDS_CARD'
    ...     ELSE ''
    ...     END AS card_type,
    ...  CASE WHEN c.payr_use = 'B' THEN (SELECT CASE WHEN c1.payr_status = 'A' THEN 'ACTIVE' WHEN c1.payr_status='F' THEN 'FOLLOW' ELSE '' END AS payr_status FROM cards c1 WHERE c.card_num = c1.card_num)
    ...     ELSE ''
    ...  END AS payr_status,
    ...  CASE WHEN c.status = 'A' THEN TRIM('ACTIVE')
    ...       WHEN c.status = 'I' THEN TRIM('INACTIVE')
    ...       WHEN c.status = 'H' THEN TRIM('HOLD')
    ...  END AS card_status,
    ...  TRIM(c.coxref) AS xref,
    ...  CASE WHEN c.infosrc = 'B' THEN (SELECT TRIM(ci.info_validation) FROM card_inf ci WHERE ci.card_num = c.card_num AND ci.info_id = 'NAME')
    ...       WHEN c.infosrc = 'C' THEN (SELECT TRIM(ci.info_validation) FROM card_inf ci WHERE ci.card_num = c.card_num AND ci.info_id = 'NAME')
    ...       WHEN c.infosrc = 'D' THEN (SELECT TRIM(di.info_validation) FROM def_info di WHERE di.carrier_id = c.carrier_id AND di.info_id = 'NAME')
    ...  END AS driver_name,
    ...  CASE WHEN c.infosrc = 'B' THEN (SELECT TRIM(ci.info_validation) FROM card_inf ci WHERE ci.card_num = c.card_num AND ci.info_id = 'UNIT')
    ...       WHEN c.infosrc = 'C' THEN (SELECT TRIM(ci.info_validation) FROM card_inf ci WHERE ci.card_num = c.card_num AND ci.info_id = 'UNIT')
    ...       WHEN c.infosrc = 'D' THEN (SELECT TRIM(di.info_validation) FROM def_info di WHERE di.carrier_id = c.carrier_id AND di.info_id = 'UNIT')
    ...  END AS unit_number,
    ...  CASE WHEN ci.info_id = 'DRID' THEN TRIM(ci.info_validation)
    ...       ELSE ''
    ...  END AS driver_id
    ...  FROM cards c, card_inf ci
    ...  WHERE c.card_id = '${api_data}[card_id]'
    ...  AND c.card_num NOT LIKE '%OVER%'
    ...  LIMIT 1

    ${result_list}      Query To Dictionaries   ${query}
    Disconnect from Database
    [Return]            ${result_list}

${response_type} Card Details using ${error}
    [Documentation]  Check for appropriate response for errors
    IF  '${error.upper()}'=='INVALID TOKEN'
        ${url}  Create Dictionary  None=${api_data}[card_id]  carriers=${api_data}[carrier_id]
        ${result}  ${status}  Api Request  ${response_type}  otr-cards  I  ${url}  application=OTR_eMgr

        Should Be Equal As Strings    ${status}     401
        Should Be Empty               ${result}
    ELSE
        Fail  Error '${error.upper()}' not implemented
    END