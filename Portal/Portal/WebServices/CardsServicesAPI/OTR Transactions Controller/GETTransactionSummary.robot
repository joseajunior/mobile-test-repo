*** Settings ***
Library         String
Library         otr_robot_lib.ws.PortalWS
Library         otr_model_lib.services.GenericService
Library         Collections
Library         otr_robot_lib.ws.UserServiceAPI.UserAPIService
Library         otr_robot_lib.ws.OKTA_Automation_User.OKTA_Automation_User
Library         otr_robot_lib.ws.RestAPI.RestAPIService
Resource        otr_robot_lib/robot/APIKeywords.robot
Documentation  Tests the GETTransactionDetails endpoint in the Transaction controller
...  within the Cards API Services

Force Tags  ditOnly  CardServicesAPI  API
Suite Setup  Check For My Automation User
Suite Teardown  Remove User if Still exists

*** Variables ***

#TODO update test when O5SA-329 and 330 are implemented
*** Test Cases ***
GET Card Transaction Details
    [Documentation]  Test the successful scenario to GET Transaction Details for a Card
    [Tags]   JIRA:O5SA-139  JIRA:O5SA-171  qTest:56128896  PI:14  OTR-CardTransaction
    [Setup]  Generate Data for Request
    Send GET API Request for Card Transaction Details
    Compare GET Endpoint Results
    [Teardown]  Remove User if Necessary

GET Card Transaction Details using No Token
    [Documentation]  Test the scenario to GET Transaction Details sending no token
    [Tags]   JIRA:O5SA-139  JIRA:O5SA-171  qTest:56153446  PI:14  OTR-CardTransaction
    [Setup]  Generate Data for Request
    GET Card Transaction Details Error using No Token
    [Teardown]  Remove User if Necessary

GET Card Transaction Details using Invalid Token
    [Documentation]  Test the scenario to GET Transaction Details sending invalid token
    [Tags]   JIRA:O5SA-139  JIRA:O5SA-171  qTest:56153446  PI:14  OTR-CardTransaction
    [Setup]  Generate Data for Request
    GET Card Transaction Details Error using Invalid Token
    [Teardown]  Remove User if Necessary

GET Card Transaction Details using Carrier ID Not Owned by User
    [Documentation]  Test the scenario to GET Transaction Details using carrier not owned by user
    [Tags]   JIRA:O5SA-139  JIRA:O5SA-171  qTest:56153446  PI:14  OTR-CardTransaction
    [Setup]  Generate Data for Request
    GET Card Transaction Details Error using Carrier ID Not Owned by User
    [Teardown]  Remove User if Necessary

GET Card Transaction Details using Card ID Not Sent
    [Documentation]  Test the scenario to GET Transaction Details without sending card id
    [Tags]   JIRA:O5SA-139  JIRA:O5SA-171  qTest:56153446  PI:14  OTR-CardTransaction
    [Setup]  Generate Data for Request
    GET Card Transaction Details Error using Card ID Not Sent
    [Teardown]  Remove User if Necessary

GET Card Transaction Details using Card ID Set as Empty
    [Documentation]  Test the scenario to GET Transaction Details sending card id as empty
    [Tags]   JIRA:O5SA-139  JIRA:O5SA-171  qTest:56153446  PI:14  OTR-CardTransaction
    [Setup]  Generate Data for Request
    GET Card Transaction Details Error using Card ID Set as Empty
    [Teardown]  Remove User if Necessary

GET Card Transaction Details using Invalid Card ID
    [Documentation]  Test the scenario to GET Transaction Details sending invalid card id
    [Tags]   JIRA:O5SA-139  JIRA:O5SA-171  qTest:56153446  PI:14  OTR-CardTransaction
    [Setup]  Generate Data for Request
    GET Card Transaction Details Error using Invalid Card ID
    [Teardown]  Remove User if Necessary

GET Card Transaction Details using Carrier ID Not Related To Card ID Selected
    [Documentation]  Test the scenario to GET Transaction Details with carrier not related to card
    [Tags]   JIRA:O5SA-139  JIRA:O5SA-171  qTest:56153446  PI:14  OTR-CardTransaction
    [Setup]  Generate Data for Request
    GET Card Transaction Details Error using Carrier ID Not Related To Card ID Selected
    [Teardown]  Remove User if Necessary

GET Card Transaction Details using Carrier ID Not Sent
    [Documentation]  Test the scenario to GET Transaction Details without sending carrier id
    [Tags]   JIRA:O5SA-139  JIRA:O5SA-171  qTest:56153446  PI:14  OTR-CardTransaction
    [Setup]  Generate Data for Request
    GET Card Transaction Details Error using Carrier ID Not Sent
    [Teardown]  Remove User if Necessary

GET Card Transaction Details using Transaction ID Not Sent
    [Documentation]  Test the scenario to GET Transaction Details without sending transaction id
    [Tags]   JIRA:O5SA-139  JIRA:O5SA-171  qTest:56153446  PI:14  OTR-CardTransaction
    [Setup]  Generate Data for Request
    GET Card Transaction Details Error using Transaction ID Not Sent
    [Teardown]  Remove User if Necessary

GET Card Transaction Details using Invalid Transaction ID
    [Documentation]  Test the scenario to GET Transaction Details sending invalid transaction id
    [Tags]   JIRA:O5SA-139  JIRA:O5SA-171  qTest:56153446  PI:14  OTR-CardTransaction
    [Setup]  Generate Data for Request
    GET Card Transaction Details Error using Invalid Transaction ID
    [Teardown]  Remove User if Necessary

GET Card Transaction Details using Transaction ID Not in Postgres
    [Documentation]  Test the scenario to GET Transaction Details sending transaction id not in postgres
    [Tags]   JIRA:O5SA-139  JIRA:O5SA-171  qTest:56153446  PI:14  OTR-CardTransaction
    [Setup]  Generate Data for Request
    GET Card Transaction Details Error using Transaction ID Not in Postgres
    [Teardown]  Remove User if Necessary


*** Keywords ***
Generate Data for Request
    [Documentation]  Create a user and get data to be used in request
    [Arguments]  ${reset_user_status}=N
    Getting API URL
    ${card_value}  get variable value  $card_pg  default
    ${transaction_value}  get variable value  $transaction_pg  default
    ${carrier_value}  get variable value  $carrier_pg  default
    ${user_value}  get variable value  $user_status  default
    IF  $card_value=='default' or $transaction_value=='default' or $carrier_value=='default'
        Getting Information from Postgress DB
    END
    Create My User         persona_name=carrier_manager  entity_id=${carrier_pg}  with_data=N  need_new_user=${reset_user_status}

Getting API URL
    [Documentation]  get url to be used for test
    Get url for suite    ${cardsservice}

Getting information from Postgress DB
    [Documentation]      Config - Getting information of CARD_ID and TRANSACTION_ID available to use with an expecific CARRIER_ID inside the postgress database
    ${good_carrierID}    Find Carrier in Oracle with transactions in Informix    A
    Get into DB          postgrespgcard
    ${pg_info}                         catenate                    select card_id, carrier_id, transaction_id from card_activity
    ...                                                            where carrier_id = '${good_carrierID}' limit 100;
    ${pg_info_dictionary}              query to dictionaries       ${pg_info}
    Disconnect from Database

    ${pg_info_length}                  Get Length                  ${pg_info_dictionary}
    IF  ${pg_info_length}==0
        Set Suite Variable             ${carrier_pg}               701501
        Set Suite Variable             ${card_pg}                  1000007152765
        Set Suite Variable             ${transaction_pg}           762151277
    ELSE
        Set Suite Variable             ${carrier_pg}               ${pg_info_dictionary}[0][carrier_id]
        Set Suite Variable             ${card_pg}                  ${pg_info_dictionary}[0][card_id]
        Set Suite Variable             ${transaction_pg}           ${pg_info_dictionary}[0][transaction_id]
    END

Send ${response_type} API Request for Card Transaction Details
    [Documentation]  send request to endpoint
    ${url_stuff}  Create Dictionary  None=${card_pg}  carriers=${carrier_pg}  transactions=${transaction_pg}
    ${response}  ${status}  API Request  GET  otr-cards  Y  ${url_stuff}  application=OTR_eMgr
    Set Test Variable  ${status}
    Set Test Variable  ${response}

Compare ${response_type} Endpoint Results
    [Documentation]  compare response with database data
    get into db          postgrespgcard
    ${transaction_detail_query}                 catenate                    select * from card_activity where carrier_id = '${carrier_pg}' and card_id='${card_pg}' and transaction_id='${transaction_pg}'
    ${transaction_detail_query_dictionary}      query to dictionaries       ${transaction_detail_query}
    Disconnect from Database
    ${trans_event}                              Evaluate                    json.loads('${transaction_detail_query_dictionary}[0][transaction_event]')

    Get Into Db          TCH
    ${cardNum_tch_query}                        Catenate                    select card_id, trim(card_num) as card_num from cards where card_id=${card_pg}
    ${cardNum_tch_query_ditionary}              Query To Dictionaries       ${cardNum_tch_query}
    Disconnect from Database

    Should Be Equal As Strings  ${status}  200
    Should Be Equal As Strings  ${response}[details][data][transaction_id]      ${trans_event}[detail][transaction][transaction_id]
    Should Be Equal As Strings  ${response}[details][data][transaction_date]    ${trans_event}[detail][transaction][transaction_date]
    Should Be Equal As Strings  ${response}[details][data][sys_type]            ${trans_event}[detail][transaction][sys_type]
    Should Be Equal As Strings  ${response}[details][data][trans_metas]         ${trans_event}[detail][transaction][trans_metas]
    Should Be Equal As Strings  ${response}[details][data][trans_line]          ${trans_event}[detail][transaction][trans_line]
    Should Not Be Equal         ${response}[details][data][masked_card_number]  ${trans_event}[detail][transaction][card_number]
    Should Not Be Equal         ${response}[details][data][masked_card_number]  ${cardNum_tch_query_ditionary}[0][card_num]

${response_type} Card Transaction Details Error using ${error}
    [Documentation]  check appropriate response for errors
    IF  '${error.upper()}'=='NO TOKEN'
        ${url_stuff}  Create Dictionary   None=${card_pg}  carriers=${carrier_pg}  transactions=${transaction_pg}
        ${result}  ${status}  Api request  GET  otr-cards  N  ${url_stuff}  application=OTR_eMgr


        Should Be Equal As Strings    ${status}       401
        Should Be Empty               ${result}
    ELSE IF  '${error.upper()}'=='INVALID TOKEN'
        ${url_stuff}   Create Dictionary   None=${card_pg}  carriers=${carrier_pg}  transactions=${transaction_pg}
        ${result}  ${status}    Api request  GET    otr-cards   I   ${url_stuff}  application=OTR_eMgr

        Should Be Equal As Strings    ${status}     401
        Should Be Empty               ${result}
    ELSE IF  '${error.upper()}'=='CARRIER ID NOT OWNED BY USER'
        ${url_stuff}  Create Dictionary       None=${card_pg}  carriers=1000042  transactions=${transaction_pg}
        ${result}  ${status}    Api request  GET    otr-cards   Y  ${url_stuff}  application=OTR_eMgr

        ${response}                   Get Dictionary Keys     ${result}
        Should Be Equal As Strings    ${status}               403
        Should Be Equal As Strings    ${response}[1]          name
        Should Be Equal As Strings    ${response}[0]          message
    ELSE IF  '${error}'=='CARD AND CARRIER NOT EXISTS AT POSTGRESS'
        get into db     TCH
        ${info_NOTin_postgress}                catenate                   select card_id, carrier_id, card_num from cards
        ...                                                               where card_num not in (select card_num from TRANSACTION where trans_date >= (CURRENT year to fraction(3) - interval(12) month(9) to month))
        ...                                                               and cardoverride = '0' limit 50;
        ${info_NOTin_postgress_dictionary}     Query To Dictionaries      ${info_NOTin_postgress}

        Set suite variable          ${card_notin_pg}         ${info_NOTin_postgress_dictionary}[0][card_id]
        Set suite variable          ${carrier_notin_pg}      ${info_NOTin_postgress_dictionary}[0][carrier_id]

        Create My User              persona_name=carrier_manager          entity_id=${carrier_notin_pg}
        IF  '${detail}'=='PAGEDLIST'
             ${url_stuff}                  create dictionary       None=${card_notin_pg}/carriers/${carrier_notin_pg}/trans-summaries
        ELSE IF   '${detail}'=='TRANSDETAIL'
             ${url_stuff}                  Create Dictionary       None=${card_notin_pg}  carriers=${carrier_notin_pg}  transactions=${transaction_pg}
        END
             ${result}  ${status}    Api request  GET  otr-cards   Y  ${url_stuff}  application=OTR_eMgr
        Remove Automation User

       Should Be Equal As Strings    ${status}               204
       Should Be Empty               ${result}
    ELSE IF  '${error.upper()}'=='CARD ID NOT SENT'

        ${url_stuff}                   Create Dictionary       carriers=${carrier_pg}  transactions=${transaction_pg}
        ${result}  ${status}     Api request  GET    otr-cards   Y  ${url_stuff}  application=OTR_eMgr

        ${response}                   Get Dictionary Keys     ${result}
        Should Be Equal As Strings    ${status}               404
        Should Be Equal As Strings    ${response}[0]          error
        Should Be Equal As Strings    ${response}[1]          path
        Should Be Equal As Strings    ${response}[2]          status
        Should Be Equal As Strings    ${response}[3]          timestamp
    ELSE IF  '${error.upper()}'=='CARD ID SET AS EMPTY'
        ${url_stuff}                   Create Dictionary       None=/carriers/${carrier_pg}/transactions/${transaction_pg}
        ${result}  ${status}     Api request  GET    otr-cards   Y  ${url_stuff}  application=OTR_eMgr

        ${response}                   Get Dictionary Keys     ${result}
        Should Be Equal As Strings    ${status}               500
        Should Be Equal As Strings    ${response}[0]          error
        Should Be Equal As Strings    ${response}[1]          path
        Should Be Equal As Strings    ${response}[2]          status
        Should Be Equal As Strings    ${response}[3]          timestamp
    ELSE IF  '${error.upper()}'=='INVALID CARD ID'
        ${url_stuff}                  Create Dictionary       None=INVALID  carriers=${carrier_pg}  transactions=${transaction_pg}
        ${result}  ${status}     Api request  GET    otr-cards   Y  ${url_stuff}  application=OTR_eMgr

        Should Be Equal As Strings    ${status}              400
        Should Be Empty               ${result}
    ELSE IF  '${error.upper()}'=='CARRIER ID NOT RELATED TO CARD ID SELECTED'
        ${url_stuff}                  Create Dictionary       None=${card_pg}  carriers=INVALID  transactions=${transaction_pg}
        ${result}  ${status}     Api request  GET    otr-cards   Y  ${url_stuff}  application=OTR_eMgr

        ${response}                   Get Dictionary Keys     ${result}
        Should Be Equal As Strings    ${status}               403
        Should Be Equal As Strings    ${response}[1]          name
        Should Be Equal As Strings    ${response}[0]          message
    ELSE IF  '${error.upper()}'=='CARRIER ID NOT SENT'
        ${url_stuff}                  Create Dictionary       None=${card_pg}/carriers/transactions/${transaction_pg}
        ${result}  ${status}    API Request  GET    otr-cards   Y  ${url_stuff}  application=OTR_eMgr

        Should Be Equal As Strings    ${status}               405
        Should Be Empty               ${result}
    ELSE IF  '${error.upper()}'=='TRANSACTION ID NOT SENT'
        ${url_stuff}                 Create Dictionary   None=${card_pg}/carriers/${carrier_pg}/transactions/
        ${result}  ${status}   API Request  GET    otr-cards   Y  ${url_stuff}  application=OTR_eMgr

        Should Be Equal As Strings    ${status}       405
        Should Be Empty               ${result}
    ELSE IF  '${error.upper()}'=='INVALID TRANSACTION ID'
        ${url_stuff}                 Create Dictionary   None=${card_pg}  carriers=${carrier_pg}  transactions=INVALID
        ${result}  ${status}   API Request  GET    otr-cards   Y  ${url_stuff}  application=OTR_eMgr

        Should Be Equal As Strings    ${status}       400
        Should Be Empty               ${result}
    ELSE IF  '${error.upper()}'=='TRANSACTION ID NOT IN POSTGRES'
        ${url_stuff}                 Create Dictionary   None=${card_pg}/carriers/${carrier_pg}/transactions/9999999999999999
        ${result}  ${status}   API Request  GET    otr-cards   Y  ${url_stuff}  application=OTR_eMgr

        Should Be Equal As Strings    ${status}               204
        Should Be Empty               ${result}
    ELSE
       Fail     Error '${error.upper()}' not implemented
    END

Check for User
    [Documentation]  checks if the user is in db, if it is removes it
    ${query}  Catenate  select id from otr_user where email LIKE 'robot+automationuser_${SUITENAME}@wexinc.com'
    Get into DB  postgrespgusers
    ${result}  Query and Strip  ${query}
    Disconnect from Database
    IF  '${result}'!='${NONE}'
        Remove Automation User  ${result}
    END

Remove User if Necessary
    [Documentation]  removes the user if the test fails, if not it will not be removed
    IF  '${TESTSTATUS}'!='PASS'
        Remove Automation User
        Set Suite Variable  ${user_status}  default
    END

Remove User if Still Exists
    ${exists}  get variable value  $auto_user_id  default
    IF  $exists!='default'
        Remove Automation User
    END