*** Settings ***
Library         otr_robot_lib.ws.PortalWS
Library         otr_model_lib.services.GenericService
Library         Collections
Library         otr_robot_lib.ws.OKTA_Automation_User.OKTA_Automation_User
Library         otr_robot_lib.ws.UserServiceAPI.UserAPIService
Library         otr_robot_lib.ws.RestAPI.RestAPIService
Resource        otr_robot_lib/robot/APIKeywords.robot

Documentation  Tests the GETCardcash endpoint in the Card Cash controller
...  within the Cards API Services

Force Tags  CardServicesAPI  API  ditOnly
Suite Setup  Check For My Automation User
Suite Teardown  Remove User if Still exists

*** Variables ***

#TODO update test when O5SA-329 and 330 are implemented
*** Test Cases ***
GET Cash Details For A Payroll Card With LimitSrc C and CashType Payroll
    [Documentation]  Test the successful scenario to GET Cash Details for a Card
    [Tags]           PI:14  JIRA:O5SB-2  qTest:55088349  CardCash
    [Setup]  Generate Data for Request  P  C  Y
    Send GET API Request for PAYROLL Card with LimitSrc C and CashType PAYROLL
    Compare GET Endpoint Results for PAYROLL Card with LimitSrc C and CashType PAYROLL
    [Teardown]  Remove User if Necessary

GET Cash Details For A Payroll Card With LimitSrc B and CashType Payroll
    [Documentation]  Test the successful scenario to GET Cash Details for a Card
    [Tags]           PI:14  JIRA:O5SB-2  qTest:55088349  CardCash
    [Setup]  Generate Data for Request  P  B  Y
    Send GET API Request for PAYROLL Card with LimitSrc B and CashType PAYROLL
    Compare GET Endpoint Results for PAYROLL Card with LimitSrc B and CashType PAYROLL
    [Teardown]  Remove User if Necessary

GET Cash Details For A Payroll Card With LimitSrc D and CashType Payroll
    [Documentation]  Test the successful scenario to GET Cash Details for a Card
    [Tags]           PI:14  JIRA:O5SB-2  qTest:55088349  CardCash
    [Setup]  Generate Data for Request  P  D  Y
    Send GET API Request for PAYROLL Card with LimitSrc D and CashType PAYROLL
    Compare GET Endpoint Results for PAYROLL Card with LimitSrc D and CashType PAYROLL
    [Teardown]  Remove User if Necessary

GET Cash Details For A Company Card With LimitSrc C and CashType Company
    [Documentation]  Test the successful scenario to GET Cash Details for a Card
    [Tags]           PI:14  JIRA:O5SB-2  qTest:55088349  CardCash
    [Setup]  Generate Data for Request  N  C  Y
    Send GET API Request for COMPANY Card with LimitSrc C and CashType COMPANY
    Compare GET Endpoint Results for COMPANY Card with LimitSrc C and CashType COMPANY
    [Teardown]  Remove User if Necessary

GET Cash Details For A Company Card With LimitSrc B and CashType Company
    [Documentation]  Test the successful scenario to GET Cash Details for a Card
    [Tags]           PI:14  JIRA:O5SB-2  qTest:55088349  CardCash  refactor
    [Setup]  Generate Data for Request  N  B  Y
    Send GET API Request for COMPANY Card with LimitSrc B and CashType COMPANY
    Compare GET Endpoint Results for COMPANY Card with LimitSrc B and CashType COMPANY
    [Teardown]  Remove User if Necessary

GET Cash Details For A Company Card With LimitSrc D and CashType Company
    [Documentation]  Test the successful scenario to GET Cash Details for a Card
    [Tags]           PI:14  JIRA:O5SB-2  qTest:55088349  CardCash  refactor
    [Setup]  Generate Data for Request  N  D  Y
    Send GET API Request for COMPANY Card with LimitSrc D and CashType COMPANY
    Compare GET Endpoint Results for COMPANY Card with LimitSrc D and CashType COMPANY
    [Teardown]  Remove User if Necessary

GET Cash Details For A Universal Card With LimitSrc C and CashType Payroll
    [Documentation]  Test the successful scenario to GET Cash Details for a Card
    [Tags]           PI:14  JIRA:O5SB-2  qTest:55088349  CardCash
    [Setup]  Generate Data for Request  B  C  Y
    Send GET API Request for UNIVERSAL Card with LimitSrc C and CashType PAYROLL
    Compare GET Endpoint Results for UNIVERSAL Card with LimitSrc C and CashType PAYROLL
    [Teardown]  Remove User if Necessary

GET Cash Details For A Universal Card With LimitSrc B and CashType Payroll
    [Documentation]  Test the successful scenario to GET Cash Details for a Card
    [Tags]           PI:14  JIRA:O5SB-2  qTest:55088349  CardCash
    [Setup]  Generate Data for Request  B  B  Y
    Send GET API Request for UNIVERSAL Card with LimitSrc B and CashType PAYROLL
    Compare GET Endpoint Results for UNIVERSAL Card with LimitSrc B and CashType PAYROLL
    [Teardown]  Remove User if Necessary

GET Cash Details For A Universal Card With LimitSrc D and CashType Payroll
    [Documentation]  Test the successful scenario to GET Cash Details for a Card
    [Tags]           PI:14  JIRA:O5SB-2  qTest:55088349  CardCash
    [Setup]  Generate Data for Request  B  D  Y
    Send GET API Request for UNIVERSAL Card with LimitSrc D and CashType PAYROLL
    Compare GET Endpoint Results for UNIVERSAL Card with LimitSrc D and CashType PAYROLL
    [Teardown]  Remove User if Necessary

GET Cash Details For A Universal Card With LimitSrc C and CashType Company
    [Documentation]  Test the successful scenario to GET Cash Details for a Card
    [Tags]           PI:14  JIRA:O5SB-2  qTest:55088349  CardCash
    [Setup]  Generate Data for Request  B  C  Y
    Send GET API Request for UNIVERSAL Card with LimitSrc C and CashType COMPANY
    Compare GET Endpoint Results for UNIVERSAL Card with LimitSrc C and CashType COMPANY
    [Teardown]  Remove User if Necessary

GET Cash Details For A Universal Card With LimitSrc B and CashType Company
    [Documentation]  Test the successful scenario to GET Cash Details for a Card
    [Tags]           PI:14  JIRA:O5SB-2  qTest:55088349  CardCash
    [Setup]  Generate Data for Request  B  B  Y
    Send GET API Request for UNIVERSAL Card with LimitSrc B and CashType COMPANY
    Compare GET Endpoint Results for UNIVERSAL Card with LimitSrc B and CashType COMPANY
    [Teardown]  Remove User if Necessary

GET Cash Details For A Universal Card With LimitSrc D and CashType Company
    [Documentation]  Test the successful scenario to GET Cash Details for a Card
    [Tags]           PI:14  JIRA:O5SB-2  qTest:55088349  CardCash
    [Setup]  Generate Data for Request  B  D  Y
    Send GET API Request for UNIVERSAL Card with LimitSrc D and CashType COMPANY
    Compare GET Endpoint Results for UNIVERSAL Card with LimitSrc D and CashType COMPANY
    [Teardown]  Remove User if Necessary

GET Cash Details using an Invalid or No Token
    [Documentation]  Test the scenario to GET Cash Details sending no token
    [Tags]  PI:14  JIRA:O5SB-2  qTest:55102852  CardCash
    GET Cash Details Error with Invalid or No Token
    [Teardown]  Remove User if Necessary

GET Cash Details using a User Not Related to Carrier
    [Documentation]  Test the scenario to GET Cash Details sending user not related to carrier
    [Tags]  PI:14  JIRA:O5SB-2  qTest:55102852  CardCash
    GET Cash Details Error with User Not Related to Carrier
    [Teardown]  Remove User if Necessary

GET Cash Details using an Invalid Card ID
    [Documentation]  Test the scenario to GET Cash Details sending invalid card id
    [Tags]  PI:14  JIRA:O5SB-2  JIRA:O5SA-373  qTest:55102852  CardCash
    GET Cash Details Error with Invalid Card ID
    [Teardown]  Remove User if Necessary

GET Cash Details using Letters as Card ID
    [Documentation]  Test the scenario to GET Cash Details sending card id with letters
    [Tags]  PI:14  JIRA:O5SB-2  qTest:55102852  CardCash
    GET Cash Details Error with Letters as Card ID
    [Teardown]  Remove User if Necessary

GET Cash Details using an Empty Card ID
    [Documentation]  Test the scenario to GET Cash Details sending card id as empty
    [Tags]  PI:14  JIRA:O5SB-2  qTest:55102852  CardCash
    GET Cash Details Error with Empty Card ID
    [Teardown]  Remove User if Necessary

GET Cash Details using an Invalid Carrier ID
    [Documentation]  Test the scenario to GET Cash Details sending invalid carrier id
    [Tags]  PI:14  JIRA:O5SB-2  qTest:55102852  CardCash
    GET Cash Details Error with Invalid Carrier ID
    [Teardown]  Remove User if Necessary

GET Cash Details using Letters as Carrier ID
    [Documentation]  Test the scenario to GET Cash Details sending carrier id with letters
    [Tags]  PI:14  JIRA:O5SB-2  qTest:55102852  CardCash
    GET Cash Details Error with Letters as Carrier ID
    [Teardown]  Remove User if Necessary

GET Cash Details using an Empty Carrier ID
    [Documentation]  Test the scenario to GET Cash Details sending carrier id as empty
    [Tags]  PI:14  JIRA:O5SB-2  qTest:55102852  CardCash
    GET Cash Details Error with Empty Carrier ID
    [Teardown]  Remove User if Necessary

GET Cash Details using a Different Cash Type
    [Documentation]  Test the scenario to GET Cash Details sending different cash type
    [Tags]  PI:14  JIRA:O5SB-2  qTest:55102852  CardCash
    GET Cash Details Error with Different Cash Type
    [Teardown]  Remove User if Necessary

GET Cash Details using an Empty Cash Type
    [Documentation]  Test the scenario to GET Cash Details sending cash type as empty
    [Tags]  PI:14  JIRA:O5SB-2  qTest:55102852  CardCash
    GET Cash Details Error with Empty Cash Type
    [Teardown]  Remove User if Necessary

*** Keywords ***
Send ${request_type} API Request for ${card_type} Card with LimitSrc ${limit_src} and CashType ${cash_type}
    [Documentation]  send request to api
    Send Request  ${request_type.upper()}  ${cash_type.upper()}

Compare ${request_type} Endpoint Results for ${card_type} Card with LimitSrc ${limit_src} and CashType ${cash_type}
    [Documentation]  compare the endpoint response with json auth
    ${card_type_value}  Map ${card_type} Card Type with Value
    Compare Data for Card Cash  ${request_type.upper()}  ${card_type_value}  ${limit_src.upper()}  ${cash_type}

Map ${card_type} Card Type with Value
    [Documentation]  maps the card type from test with the value in the db
    IF  'UNIVERSAL'=='${card_type.upper()}'
        ${card_type_value}  Set Variable  B
    ELSE IF  'PAYROLL'=='${card_type.upper()}'
        ${card_type_value}  Set Variable  P
    ELSE IF  'COMPANY'=='${card_type.upper()}'
        ${card_type_value}  Set Variable  N
    END
    [Return]  ${card_type_value}

Getting API URL
    [Documentation]  getting portion of url to be used for testing
    Get url for suite    ${cardsservice}

Generate Data for Request
    [Documentation]  Create a user and get data to be used in request
    [Arguments]  ${payr_use}  ${lmt_src}  ${reset_user_status}=N
    Getting API URL
    IF  'Error' not in $TESTNAME
        ${card_cash_results}  Find Card Type In Oracle  A  ${payr_use}  ${lmt_src}
        Set Suite Variable  ${card_cash_results}
    END
    Create My User  persona_name=carrier_manager  entity_id=${card_cash_results}[carrier_id]  with_data=N  need_new_user=${reset_user_status}


Getting information from Postgress DB
    [Documentation]      Config - Getting information of CARD_ID and TRANSACTION_ID available to use with an expecific CARRIER_ID inside the postgress database
    ${good_carrierID}    Find Carrier in Oracle with transactions in Informix    A

    Get into DB          postgrespgcard

    ${pg_info}                         catenate                    select card_id, carrier_id, transaction_id from card_activity
    ...                                                            where carrier_id = '${good_carrierID}' limit 100;
    ${pg_info_dictionary}              query to dictionaries       ${pg_info}
    Disconnect from Database
    ${pg_info_length}                  Get Length                  ${pg_info_dictionary}
    IF      ${pg_info_length}==0
        Set Suite Variable             ${carrier_pg}               701501
        Set Suite Variable             ${card_pg}                  1000007152765
        Set Suite Variable             ${transaction_pg}           762151277
    ELSE
        Set Suite Variable             ${carrier_pg}               ${pg_info_dictionary}[0][carrier_id]
        Set Suite Variable             ${card_pg}                  ${pg_info_dictionary}[0][card_id]
        Set Suite Variable             ${transaction_pg}           ${pg_info_dictionary}[0][transaction_id]
    END

Send Request
    [Documentation]  sends request to the api
    [Arguments]  ${request_type}  ${cash_type}
    Card Cash Details  ${request_type}  ${cash_type}

Compare Data for Card Cash
    [Documentation]  compare response data with that of json auth
    [Arguments]  ${request_type}=${NONE}  ${payr_use}=${NONE}
    ...  ${limit_source}=${NONE}  ${cash_type}=${NONE}
    IF  '${request_type.upper()}'=='GET'
        Get JsonAuth Response For Cash Advance  ${cash_type.upper()}
        Should Be Equal As Strings  ${status}  200
            Should Be Equal As Strings  ${response}[details][data][currency]  ${jsonauth_response}[currency]
            Should Be Equal As Strings  ${response}[details][data][one_time_cash]  ${jsonauth_response}[one_time_cash]
            IF  '${payr_use.upper()}'=='N' or ('${payr_use.upper()}'=='B' and '${cash_type.upper()}'=='COMPANY')
                Should Be Equal As Strings  ${response}[details][data][recurring_cash]  ${jsonauth_response}[recurring_cash]
            END
        Should Contain  ${response}[details][data]  links
    ELSE
            Fail  ${request_type.upper()} ${type} not yet implemented
    END

Card Cash Details
    [Documentation]  Perform the request for Cash endpoint
    [Arguments]  ${request}  ${cash_type}  ${card}=${card_cash_results}[card_id]  ${carrier}=${card_cash_results}[carrier_id]    ${secure}=Y

    ${headers}  Create Dictionary  content-type=application/json
    ${url_stuff}              Create Dictionary      None=${card}  carriers=${carrier}  cash-details=${cash_type}
    ${response}  ${status}    API Request  ${request}  card-cash  ${secure}  ${url_stuff}  application=OTR_eMgr

    Set Test Variable  ${status}
    Set Test Variable  ${response}

Get JsonAuth Response For Cash Advance
    [Documentation]  It recieves the variables and do the steps
    [Arguments]  ${cash_type}
    Get Url For Suite  ${JsonAuthAPI}
    ${x_user_id_global}  Evaluate  str(uuid.uuid4())[:-6]    uuid
    ${correlation-id}  Evaluate  str(uuid.uuid4())[:-6]   uuid
    ${cash_type}  Create Dictionary  payr_use=${cash_type}
    ${url_stuff}  Create Dictionary  None=${card_cash_results}[card_id]
    ${headers}  Create Dictionary  x-correlation-id=${correlation-id}  x-user-id=${x_user_id_global}  x-informix-instance=TCH
    ${jsonauth_response}  ${jsonauth_status}  Api request  GET  cash-advance  N  ${url_stuff}  ${cash_type}  header=${headers}

    IF  '${jsonauth_status}'!='200'
        Fail  JsonAuth returned ${jsonauth_status}
    END

    Set Test Variable  ${jsonauth_response}  ${jsonauth_response}

GET Cash Details Error with ${error}
    [Documentation]  Checks the appropriate response is being sent
    Getting API URL
    ${card_cash_value}  Get Variable Value  $card_cash_results  default
    IF  $card_cash_value=='default'
        ${card_cash_results}  Find Card Type In Oracle  A  P  C
    END

    IF  '${error.upper()}'=='INVALID OR NO TOKEN'
        Create My User  persona_name=carrier_manager  entity_id=${card_cash_results}[carrier_id]  with_data=N  need_new_user=N
        Get Pkce Token  ${okta_automated_email}  ${automated_user_password}  OTR_eMgr  BAD
        Card Cash Details  GET  PAYROLL  ${card_cash_results}[card_id]  ${card_cash_results}[carrier_id]  N

        Should Be Equal As Strings  ${status}  401
    ELSE IF  '${error.upper()}'=='USER NOT RELATED TO CARRIER'
        Get Into Db             TCH
        ${query_other}          Catenate                    select carrier_id from cards where carrier_id <> '${card_cash_results}[carrier_id]' and status = 'A' Limit 1;
        ${other_carrier_id}     Query To Dictionaries       ${query_other}
        Disconnect From Database
        Create My User  persona_name=carrier_manager  entity_id=${other_carrier_id}[0][carrier_id]  with_data=N  need_new_user=Y
        Card Cash Details  GET  PAYROLL  ${card_cash_results}[card_id]  ${card_cash_results}[carrier_id]

        ${result}  Get Dictionary Keys  ${response}
        Should Be Equal As Strings  ${status}     403
        Should Be Equal As Strings  ${result}[1]  name
        Should Be Equal As Strings  ${result}[0]  message
    ELSE IF  '${error.upper()}'=='INVALID CARD ID'
        Create My User  persona_name=carrier_manager  entity_id=${card_cash_results}[carrier_id]  with_data=N  need_new_user=Y
        Card Cash Details  GET  PAYROLL  99999999999  ${card_cash_results}[carrier_id]

        ${result}  Get Dictionary Keys  ${response}
        Should Be Equal As Strings  ${status}  422

        Should Be Equal As Strings  ${result}[0]  error_code
        Should Be Equal As Strings  ${result}[1]  message
        Should Be Equal As Strings  ${result}[2]  name
    ELSE IF  '${error.upper()}'=='LETTERS AS CARD ID'
        Create My User  persona_name=carrier_manager  entity_id=${card_cash_results}[carrier_id]  with_data=N  need_new_user=N
        Card Cash Details  GET  PAYROLL  1000O06E02591  ${card_cash_results}[carrier_id]

        Should Be Equal As Strings  ${status}  400
        Should Be Empty  ${response}
    ELSE IF  '${error.upper()}'=='EMPTY CARD ID'
        Create My User  persona_name=carrier_manager  entity_id=${card_cash_results}[carrier_id]  with_data=N  need_new_user=N
        Card Cash Details  GET  PAYROLL  ${EMPTY}  ${card_cash_results}[carrier_id]

        ${result}  Get Dictionary Keys  ${response}
        Should Be Equal As Strings  ${status}  500
        Should Be Equal As Strings  ${result}[0]  error
        Should Be Equal As Strings  ${result}[1]  path
        Should Be Equal As Strings  ${result}[2]  status
        Should Be Equal As Strings  ${result}[3]  timestamp
    ELSE IF  '${error.upper()}'=='INVALID CARRIER ID'
        Create My User  persona_name=carrier_manager  entity_id=${card_cash_results}[carrier_id]  with_data=N  need_new_user=N
        Card Cash Details  GET  PAYROLL  ${card_cash_results}[card_id]  888888

        ${result}  Get Dictionary Keys  ${response}
        Should Be Equal As Strings  ${status}  403
        Should Be Equal As Strings  ${result}[1]  name
        Should Be Equal As Strings  ${result}[0]  message
    ELSE IF  '${error.upper()}'=='LETTERS AS CARRIER ID'
        Create My User  persona_name=carrier_manager  entity_id=${card_cash_results}[carrier_id]  with_data=N  need_new_user=N
        Card Cash Details  GET  PAYROLL  ${card_cash_results}[card_id]  88AA88

        ${result}  Get Dictionary Keys  ${response}
        Should Be Equal As Strings  ${status}  403
        Should Be Equal As Strings  ${result}[1]  name
        Should Be Equal As Strings  ${result}[0]  message
    ELSE IF  '${error.upper()}'=='EMPTY CARRIER ID'
        Create My User  persona_name=carrier_manager  entity_id=${card_cash_results}[carrier_id]  with_data=N  need_new_user=N
        Card Cash Details  GET  PAYROLL  ${card_cash_results}[card_id]  ${EMPTY}

        ${result}  Get Dictionary Keys  ${response}
        Should Be Equal As Strings  ${status}  500
        Should Be Equal As Strings  ${result}[0]  error
        Should Be Equal As Strings  ${result}[1]  path
        Should Be Equal As Strings  ${result}[2]  status
        Should Be Equal As Strings  ${result}[3]  timestamp
    ELSE IF  '${error.upper()}'=='DIFFERENT CASH TYPE'
        Create My User  persona_name=carrier_manager  entity_id=${card_cash_results}[carrier_id]  with_data=N  need_new_user=N
        Card Cash Details  GET  INSURANCE  ${card_cash_results}[card_id]  ${card_cash_results}[carrier_id]

        Should Be Equal As Strings  ${status}  400
        Should Be Empty  ${response}
    ELSE IF  '${error.upper()}'=='EMPTY CASH TYPE'
        Create My User  persona_name=carrier_manager  entity_id=${card_cash_results}[carrier_id]  with_data=N  need_new_user=N
        Card Cash Details  GET  ${EMPTY}  ${card_cash_results}[card_id]  ${card_cash_results}[carrier_id]

        ${result}  Get Dictionary Keys  ${response}
        Should Be Equal As Strings  ${status}  404
        Should Be Equal As Strings  ${result}[0]  error
        Should Be Equal As Strings  ${result}[1]  path
        Should Be Equal As Strings  ${result}[2]  status
        Should Be Equal As Strings  ${result}[3]  timestamp
    ELSE
        Fail  Error '${error.upper()}' not implemented. Status code: ${status}
    END