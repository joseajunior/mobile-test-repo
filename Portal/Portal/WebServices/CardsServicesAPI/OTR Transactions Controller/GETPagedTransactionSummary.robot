*** Settings ***
Library         String
Library         otr_robot_lib.ws.PortalWS
Library         otr_model_lib.services.GenericService
Library         Collections
Library         otr_robot_lib.ws.OKTA_Automation_User.OKTA_Automation_User
Library         otr_robot_lib.ws.UserServiceAPI.UserAPIService
Library         otr_robot_lib.ws.RestAPI.RestAPIService
Resource        otr_robot_lib/robot/APIKeywords.robot

Documentation  Tests the GETPagedTransactionDetails endpoint in the Transaction controller
...  within the Cards API Services

Force Tags  ditOnly  CardServicesAPI  API
Suite Setup  Check For My Automation User
Suite Teardown  Remove User if Still exists

*** Variables ***
${page_size}  10

#TODO update test when O5SA-329 and 330 are implemented
*** Test Cases ***
GET Card Paged Transactions Details
    [Documentation]  Test the successful scenario to GET Paged Transaction Details for a Card
    [Tags]  JIRA:O5SA-170  JIRA:O5SA-138   qTest:56173740  PI:14  OTR-CardTransaction
    [Setup]  Generate Data for Request
    Send GET API Request for Card Paged Transactions Details
    Compare GET Endpoint Results
    [Teardown]  Remove User if Necessary

GET Card Paged Transaction Details using No Token
    [Documentation]  Test GET Paged Transaction Details sending no token
    [Tags]  JIRA:O5SA-170  JIRA:O5SA-138   qTest:56187042  PI:14  OTR-CardTransaction
    [Setup]  Generate Data for Request
    GET Card Paged Transaction Details Error using No Token
    [Teardown]  Remove User if Necessary

GET Card Paged Transaction Details using Invalid Token
    [Documentation]  Test GET Paged Transaction Details sending invalid token
    [Tags]  JIRA:O5SA-170  JIRA:O5SA-138   qTest:56187042  PI:14  OTR-CardTransaction
    [Setup]  Generate Data for Request
    GET Card Paged Transaction Details Error using Invalid Token
    [Teardown]  Remove User if Necessary

GET Card Paged Transaction Details using Carrier ID Not Sent
    [Documentation]  Test GET Paged Transaction Details without sending carrier id
    [Tags]  JIRA:O5SA-170  JIRA:O5SA-138   qTest:56187042  PI:14  OTR-CardTransaction
    [Setup]  Generate Data for Request
    GET Card Paged Transaction Details Error using Carrier ID Not Sent
    [Teardown]  Remove User if Necessary

GET Card Paged Transaction Details using Carrier ID Not Owned by User
    [Documentation]  Test GET Paged Transaction Details sending carrier id not owned by user
    [Tags]  JIRA:O5SA-170  JIRA:O5SA-138   qTest:56187042  PI:14  OTR-CardTransaction
    [Setup]  Generate Data for Request
    GET Card Paged Transaction Details Error using Carrier ID Not Owned by User
    [Teardown]  Remove User if Necessary

GET Card Paged Transaction Details using Card ID Not Sent
    [Documentation]  Test GET Paged Transaction Details without sending card id
    [Tags]  JIRA:O5SA-170  JIRA:O5SA-138   qTest:56187042  PI:14  OTR-CardTransaction
    [Setup]  Generate Data for Request
    GET Card Paged Transaction Details Error using Card ID Not Sent
    [Teardown]  Remove User if Necessary

GET Card Paged Transaction Details using Card ID Set as Empty
    [Documentation]  Test GET Paged Transaction Details sending card id as empty
    [Tags]  JIRA:O5SA-170  JIRA:O5SA-138   qTest:56187042  PI:14  OTR-CardTransaction
    [Setup]  Generate Data for Request
    GET Card Paged Transaction Details Error using Card ID Set as Empty
    [Teardown]  Remove User if Necessary

GET Card Paged Transaction Details using Invalid Card ID
    [Documentation]  Test GET Paged Transaction Details sending invalid card id
    [Tags]  JIRA:O5SA-170  JIRA:O5SA-138   qTest:56187042  PI:14  OTR-CardTransaction
    [Setup]  Generate Data for Request
    GET Card Paged Transaction Details Error using Invalid Card ID
    [Teardown]  Remove User if Necessary

GET Card Paged Transaction Details using Carrier ID with string
    [Documentation]  Test GET Paged Transaction Details sending carrier using letters
    [Tags]  JIRA:O5SA-170  JIRA:O5SA-138   qTest:56187042  PI:14  OTR-CardTransaction
    [Setup]  Generate Data for Request
    GET Card Paged Transaction Details Error using Carrier ID with string
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

Getting information from Postgress DB
    [Documentation]      Config - Getting information of CARD_ID and TRANSACTION_ID available to use with an expecific CARRIER_ID inside the postgress database
    ${good_carrierID}    Find Carrier in Oracle with transactions in Informix    A
    Get into DB         postgrespgcard
    ${pg_info}                         Catenate                    select card_id, carrier_id, transaction_id from card_activity
    ...                                                            where carrier_id = '${good_carrierID}' limit 100;
    ${pg_info_dictionary}              Query to Dictionaries       ${pg_info}
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

Getting API URL
    [Documentation]  getting portion of url to be used for testing
    Get url for suite    ${cardsservice}

Send ${response_type} API Request for Card Paged Transactions Details
    [Documentation]  sending request from api
    ${url_stuff}                    Create Dictionary      None=${card_pg}  carriers=${carrier_pg}  trans-summaries=None
    ${response}  ${status}          API Request            GET  otr-cards   Y  ${url_stuff}  application=OTR_eMgr
    Set Test Variable  ${status}
    Set Test Variable  ${response}

Compare ${response_type} Endpoint Results
    [Documentation]  compare response with data in postgres db
    Get into DB          postgrespgcard
    ${last_transactions_query}                  Catenate                    select * from card_activity where carrier_id = '${carrier_pg}' and card_id='${card_pg}' order by transaction_time desc limit ${page_size};
    ${last_transactions_query_dictionary}       Query to Dictionaries       ${last_transactions_query}
    Disconnect From Database
    ${trans_event}                              Evaluate                    json.loads('${last_transactions_query_dictionary}[0][transaction_event]')

    Should Be Equal As Strings      ${response}[name]                                OK
    Should Be Equal As Strings      ${response}[message]                             SUCCESSFUL
    Should Be Equal As Strings      ${response}[page][number]                        0
    Should Be Equal As Strings      ${response}[page][size]                          ${page_size}
    Should Be Equal As Strings      ${response}[details][type]                       TransSummaryDTO
    Should Be Equal As Strings      ${response}[details][data][0][card_id]           ${last_transactions_query_dictionary}[0][card_id]
    Should Be Equal As Strings      ${response}[details][data][0][carrier_id]        ${last_transactions_query_dictionary}[0][carrier_id]
    Should Be Equal As Strings      ${response}[details][data][0][transaction_id]    ${trans_event}[detail][transaction][transaction_id]
    Should Be Equal As Strings      ${response}[details][data][0][date_time]         ${trans_event}[detail][transaction][transaction_date]
    Should Be Equal As Strings      ${response}[details][data][0][amount]            ${trans_event}[detail][transaction][pref_total]
    Should Be Equal As Strings      ${response}[details][data][0][location_name]     ${trans_event}[detail][transaction][location][name]
    Should Contain                  ${response}[details][data][0]                    links
    Should Contain                  ${response}                                      links

${response_type} Card Paged Transaction Details Error using ${error}
    [Documentation]  check errors from api
    IF  '${error.upper()}'=='NO TOKEN'
        ${url_stuff}                  Create Dictionary   None=${card_pg}  carriers=${carrier_pg}  trans-summaries=None
        ${result}  ${status}    Api request         GET    otr-cards   N    ${url_stuff}  application=OTR_eMgr

        Should Be Equal As Strings    ${status}       401
        Should Be Empty               ${result}
    ELSE IF  '${error.upper()}'=='INVALID TOKEN'
        ${url_stuff}                  Create Dictionary   None=${card_pg}  carriers=${carrier_pg}  trans-summaries=None
        ${result}  ${status}    Api request         GET    otr-cards   I    ${url_stuff}  application=OTR_eMgr

        Should Be Equal As Strings    ${status}     401
        Should Be Empty               ${result}
    ELSE IF  '${error}'=='INCORRECT PERSONA OR PERMISSION'
        Create My User   persona_name=auth_gateway_client  entity_id=${carrier_pg}
        IF   '${detail}'=='PAGEDLIST'
             ${url_stuff}                  create dictionary   None=${card_pg}/carriers/${carrier_pg}/trans-summaries
        ELSE IF   '${detail}'=='TRANSDETAIL'
             ${url_stuff}                  Create Dictionary   None=${card_pg}  carriers=${carrier_pg}  transactions=${transaction_pg}
        END
             ${result}  ${status}    Api request         GET    otr-cards   Y    ${url_stuff}  application=OTR_eMgr
        Remove Automation User

        ${response}                   Get Dictionary Keys     ${result}
        Should Be Equal As Strings    ${status}               500
        should be equal               ${response}[0]          details
        should be equal               ${response}[1]          message
        should be equal               ${response}[2]          status
        should be equal               ${response}[3]          timeStamp
    ELSE IF  '${error.upper()}'=='CARRIER ID NOT OWNED BY USER'
        ${url_stuff}                  Create Dictionary       None=${card_pg}  carriers=1000042  trans-summaries=None
        ${result}  ${status}    Api request             GET    otr-cards   Y    ${url_stuff}  application=OTR_eMgr

        ${response}                   Get Dictionary Keys     ${result}
        Should Be Equal As Strings    ${status}               403
        Should Be Equal As Strings    ${response}[1]          name
        Should Be Equal As Strings    ${response}[0]          message
    ELSE IF  '${error}'=='CARD AND CARRIER NOT EXISTS AT POSTGRESS'
        Get into DB     TCH
        ${info_NOTin_postgress}                catenate                   select card_id, carrier_id, card_num from cards
        ...                                                               where card_num not in (select card_num from TRANSACTION where trans_date >= (CURRENT year to fraction(3) - interval(12) month(9) to month))
        ...                                                               and cardoverride = '0' limit 50;
        ${info_NOTin_postgress_dictionary}     Query To Dictionaries      ${info_NOTin_postgress}
        Disconnect from Database

        Set suite variable          ${card_notin_pg}         ${info_NOTin_postgress_dictionary}[0][card_id]
        Set suite variable          ${carrier_notin_pg}      ${info_NOTin_postgress_dictionary}[0][carrier_id]

    Create My User              persona_name=carrier_manager          entity_id=${carrier_notin_pg}
    IF  '${detail}'=='PAGEDLIST'
         ${url_stuff}                  create dictionary       None=${card_notin_pg}/carriers/${carrier_notin_pg}/trans-summaries
    ELSE IF   '${detail}'=='TRANSDETAIL'
         ${url_stuff}                  Create Dictionary       None=${card_notin_pg}  carriers=${carrier_notin_pg}  transactions=${transaction_pg}
    END
         ${result}  ${status}    Api request             GET    otr-cards   Y    ${url_stuff}  application=OTR_eMgr
    Remove Automation User

    Should Be Equal As Strings    ${status}               204
    Should Be Empty               ${result}
    ELSE IF  '${error.upper()}'=='CARD ID NOT SENT'
        ${url_stuff}                   Create Dictionary       None=carriers/${carrier_pg}/trans-summaries
        ${result}  ${status}     Api request             GET    otr-cards   Y    ${url_stuff}  application=OTR_eMgr

        ${response}                   Get Dictionary Keys     ${result}
        Should Be Equal As Strings    ${status}               404
        Should Be Equal As Strings    ${response}[0]          error
        Should Be Equal As Strings    ${response}[1]          path
        Should Be Equal As Strings    ${response}[2]          status
        Should Be Equal As Strings    ${response}[3]          timestamp
    ELSE IF  '${error.upper()}'=='CARD ID SET AS EMPTY'
        ${url_stuff}                   create dictionary       None=/carriers/${carrier_pg}/trans-summaries
        ${result}  ${status}     Api request             GET    otr-cards   Y    ${url_stuff}  application=OTR_eMgr

        ${response}                   Get Dictionary Keys     ${result}
        Should Be Equal As Strings    ${status}               500
        Should Be Equal As Strings    ${response}[0]          error
        Should Be Equal As Strings    ${response}[1]          path
        Should Be Equal As Strings    ${response}[2]          status
        Should Be Equal As Strings    ${response}[3]          timestamp
    ELSE IF  '${error.upper()}'=='INVALID CARD ID'
        ${url_stuff}                   Create Dictionary       None=INVALID  carriers=${carrier_pg}  trans-summaries=None
        ${result}  ${status}     Api request             GET    otr-cards   Y    ${url_stuff}  application=OTR_eMgr

        Should Be Equal As Strings    ${status}              400
        Should Be Empty               ${result}
    ELSE IF  '${error.upper()}'=='CARRIER ID WITH STRING'
        ${url_stuff}                   Create Dictionary       None=${card_pg}  carriers=INVALID  trans-summaries=None
        ${result}  ${status}     Api request             GET    otr-cards   Y    ${url_stuff}  application=OTR_eMgr

        ${response}                   Get Dictionary Keys     ${result}
        Should Be Equal As Strings    ${status}               403
        Should Be Equal As Strings    ${response}[1]          name
        Should Be Equal As Strings    ${response}[0]          message
    ELSE IF  '${error.upper()}'=='CARRIER ID NOT SENT'
        ${url_stuff}                  Create Dictionary       None=${card_pg}/carriers/trans-summaries
        ${result}  ${status}    Api request             GET    otr-cards   Y    ${url_stuff}  application=OTR_eMgr

        ${response}                   Get Dictionary Keys     ${result}
        Should Be Equal As Strings    ${status}               403
        Should Be Equal As Strings    ${response}[1]          name
        Should Be Equal As Strings    ${response}[0]          message
    ELSE
       Fail     Error '${error.upper()}' not implemented
    END