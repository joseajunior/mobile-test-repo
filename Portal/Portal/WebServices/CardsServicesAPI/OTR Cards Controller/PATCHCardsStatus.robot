*** Settings ***
Library         String
Library         otr_robot_lib.ws.PortalWS
Library         otr_model_lib.services.GenericService
Library         Collections
Library         otr_robot_lib.ws.OKTA_Automation_User.OKTA_Automation_User
Library         otr_robot_lib.ws.RestAPI.RestAPIService
Library         otr_robot_lib.ws.UserServiceAPI.UserAPIService
Resource        otr_robot_lib/robot/APIKeywords.robot

Documentation   This is to test the Cards Service API available at URL: (https://cardsservice.{env}.efsllc.com),
...             we can find endpoints for:
...             - CARD CASH (API to manage Card Cash),
...             - OTR CARD TRANSACTIONS (API to manage OTR Card Transactions)
...             - OTR CARDS (API to manage OTR cards)
...             - OTR POLICES (API to manage OTR policies)
...             NOTES = (currently only works in dit because okta service is set up there) -- MORE ENDPOINTS COMING
Force Tags      CardServicesAPI  API  refactor

*** Test Cases ***

(OTR-Cards) PATCH Card Status Update (Company cards N)
    [Documentation]     Test Perform Card Status Update in Company cards
    [Tags]      PI:14  JIRA:O5SA-160  qTest:56261393  OTR-Cards      checked
    [Setup]                            UPDATE Looking For Data To Use      N           A           TRUE
    Card Status Update                  INACTIVE        COMPANY_CARD
    Compare Result In Database          I       I       N       A
    Card Status Update                  ACTIVE          COMPANY_CARD
    Compare Result In Database          A       A       N       A
    Card Status Update                  HOLD            COMPANY_CARD
    Compare Result In Database          H       A       N       A
    [Teardown]  Remove Automation User

(OTR-Cards) PATCH Card Status Update (Payroll cards P)
    [Documentation]     Test Perform Card Status Update in Payroll cards
    [Tags]  PI:14  JIRA:O5SA-160  qTest:56261393  OTR-Cards
    [Setup]                            UPDATE Looking For Data To Use      P       A       TRUE
    Card Status Update                  INACTIVE        SMART_FUNDS_CARD
    Compare Result In Database          I       I       N       A
    Card Status Update                  ACTIVE          SMART_FUNDS_CARD
    Compare Result In Database          A       A       N       A
    Card Status Update                  HOLD            SMART_FUNDS_CARD
    Compare Result In Database          H       A       N       A
    [Teardown]  Remove Automation User

(OTR-Cards) PATCH Card Status Update (Universal Card B - Company Card)
    [Documentation]     Test Perform Card Status Update in Universal cards - Company Card
    [Tags]      PI:14  JIRA:O5SA-160  qTest:56261393  OTR-Cards
    [Setup]                             UPDATE Looking For Data To Use      B       A       FALSE
    Card Status Update                  INACTIVE        COMPANY_CARD
    Compare Result In Database          I       I       N       A
    Card Status Update                  ACTIVE          COMPANY_CARD
    Compare Result In Database          A       A       N       A
    Card Status Update                  HOLD            COMPANY_CARD
    Compare Result In Database          H       A       N       A
    [Teardown]  Remove Automation User

(OTR-Cards) PATCH Card Status Update (Universal Card B - Smart Funds)
    [Documentation]     Test Perform Card Status Update in Universal cards - Smart Funds
    [Tags]      PI:14  JIRA:O5SA-160  qTest:56261393  OTR-Cards
    [Setup]                            UPDATE Looking For Data To Use      B       F       FALSE
    Card Status Update                  INACTIVE        SMART_FUNDS_CARD
    Compare Result In Database          A       A       A       I
    Card Status Update                  ACTIVE          SMART_FUNDS_CARD
    Compare Result In Database          A       A       A       A
    Card Status Update                  HOLD            SMART_FUNDS_CARD
    Compare Result In Database          A       A       A       H
    Card Status Update                  FOLLOW          SMART_FUNDS_CARD
    Compare Result In Database          A       A       A       F
    [Teardown]  Remove Automation User

(OTR-Cards) PATCH Card Status Update - EXP. Error - Invalid Token
    [Documentation]     Test Perform Card Status Update expected errors
    [Tags]      PI:14  JIRA:O5SA-160  qTest:56261393  OTR-Cards

    [Setup]     UPDATE Looking For Data To Use      B       F       TRUE
    PATCH - EXP. ERROR     Invalid Token       INACTIVE        COMPANY_CARD
    [Teardown]  Remove Automation User

(OTR-Cards) PATCH Card Status Update - EXP. Error - Carrier not Assigned
    [Documentation]     Test Perform Card Status Update expected errors
    [Tags]      PI:14  JIRA:O5SA-160  qTest:56261393  OTR-Cards

    [Setup]    UPDATE Looking For Data To Use       B       F       TRUE
    PATCH - EXP. ERROR     Carrier not Assigned        inactive        COMPANY_CARD
    [Teardown]  Remove Automation User

(OTR-Cards) PATCH Card Status Update - Exp.Error - CARD ID W/O AUTH. AND CARRIER ID WITH AUTH.
    [Documentation]     Test Perform Card Status Update expected errors
    [Tags]      PI:14  JIRA:O5SA-160  JIRA:O5SA-373  qTest:56261393  OTR-Cards

    [Setup]    UPDATE Looking For Data To Use       B       F       TRUE
    PATCH - EXP. ERROR     CARD ID W/O AUTH. AND CARRIER ID WITH AUTH.     inactive        COMPANY_CARD
    [Teardown]  Remove Automation User

(OTR-Cards) PATCH Card Status Update - EXP. Error - ERASE THE CARD ID
    [Documentation]     Test Perform Card Status Update expected errors
    [Tags]      PI:14  JIRA:O5SA-160  qTest:56261393  OTR-Cards

    [Setup]    UPDATE Looking For Data To Use       B       F       TRUE
    PATCH - EXP. ERROR     ERASE THE CARD ID       inactive        COMPANY_CARD
    [Teardown]  Remove Automation User

(OTR-Cards) PATCH Card Status Update - EXP. Error - NONEXISTENT CARD_ID
    [Documentation]     Test Perform Card Status Update expected errors
    [Tags]      PI:14  JIRA:O5SA-160  qTest:56261393  OTR-Cards

    [Setup]    UPDATE Looking For Data To Use       B       F       TRUE
    PATCH - EXP. ERROR     NONEXISTENT CARD_ID     inactive        COMPANY_CARD
    [Teardown]  Remove Automation User

(OTR-Cards) PATCH Card Status Update - EXP. Error - LETTERS AS CARD ID
    [Documentation]     Test Perform Card Status Update expected errors
    [Tags]      PI:14  JIRA:O5SA-160  qTest:56261393  OTR-Cards

    [Setup]    UPDATE Looking For Data To Use       B       F       TRUE
    PATCH - EXP. ERROR     LETTERS AS CARD ID      inactive        COMPANY_CARD
    [Teardown]  Remove Automation User

(OTR-Cards) PATCH Card Status Update - EXP. Error - CARD ID WITH AUTH.
    [Documentation]     Test Perform Card Status Update expected errors
    [Tags]      PI:14  JIRA:O5SA-160  qTest:56261393  OTR-Cards

    [Setup]    UPDATE Looking For Data To Use       B       F       TRUE
    PATCH - EXP. ERROR     CARD ID WITH AUTH. AND CARRIER ID EMPTY       inactive        COMPANY_CARD
    [Teardown]  Remove Automation User

(OTR-Cards) PATCH Card Status Update - EXP. Error - LETTERS AS CARRIER ID
    [Documentation]     Test Perform Card Status Update expected errors
    [Tags]      PI:14  JIRA:O5SA-160  qTest:56261393  OTR-Cards

    [Setup]    UPDATE Looking For Data To Use       B     F     TRUE
    PATCH - EXP. ERROR     LETTERS AS CARRIER ID       inactive        COMPANY_CARD
    [Teardown]  Remove Automation User

(OTR-Cards) PATCH Card Status Update - EXP. Error - REMOVE CASH TYPE
    [Documentation]     Test Perform Card Status Update expected errors
    [Tags]      PI:14  JIRA:O5SA-160  qTest:56261393  OTR-Cards

    [Setup]    UPDATE Looking For Data To Use       B       F       TRUE
    PATCH - EXP. ERROR     REMOVE CASH TYPE        inactive        ${EMPTY}
    [Teardown]  Remove Automation User

(OTR-Cards) PATCH Card Status Update - EXP. Error - LETTERS AS CASH TYPE
    [Documentation]     Test Perform Card Status Update expected errors
    [Tags]      PI:14  JIRA:O5SA-160  qTest:56261393  OTR-Cards

    [Setup]    UPDATE Looking For Data To Use       B       F       TRUE
    PATCH - EXP. ERROR     LETTERS AS CASH TYPE        inactive        ABCDEF
    [Teardown]  Remove Automation User

(OTR-Cards) PATCH Card Status Update - EXP. Error - CARRIER ID FROM THE AUTH. USER AND CARD ID FROM A PAYROLL CARD TYPE
    [Documentation]     Test Perform Card Status Update expected errors
    [Tags]       PI:14  JIRA:O5SA-160   JIRA:O5SA-373  qTest:56261393  OTR-Cards

    [Setup]    UPDATE Looking For Data To Use       B       F       TRUE
    PATCH - EXP. ERROR     CARRIER ID FROM AUTH. USER CARD ID FROM PAYROLL   inactive   COMPANY_CARD
    [Teardown]  Remove Automation User

(OTR-Cards) PATCH Card Status Update - EXP. Error - CARRIER ID FROM THE AUTH.USER AND CARD ID FROM A COMPANY CARD TYPE
    [Documentation]     Test Perform Card Status Update expected errors
    [Tags]      PI:14  JIRA:O5SA-160  qTest:56261393  OTR-Cards

    [Setup]    UPDATE Looking For Data To Use       B       F       TRUE
    PATCH - EXP. ERROR   CARRIER ID FROM THE AUTH. USER AND CARD ID FROM COMPANY C.   inactive   SMART_FUNDS_CARD
    [Teardown]  Remove Automation User

(OTR-Cards) PATCH Card Status Update - EXP. Error - CARRIER ID FROM AUTH.USER AND C.ID FROM COMP. CARD W/O REQUEST BODY
    [Documentation]     Test Perform Card Status Update expected errors
    [Tags]      PI:14  JIRA:O5SA-160    JIRA:O5SA-373  qTest:56261393  OTR-Cards

    [Setup]    UPDATE Looking For Data To Use       N       A       TRUE
    PATCH - EXP. ERROR   CARRIER ID AUTH.USER AND C.ID FROM COMPANY C. TYPE W/O REQUEST BODY   ${EMPTY}   COMPANY_CARD
    [Teardown]  Remove Automation User

(OTR-Cards) PATCH Card Status Update - EXP. Error - CARRIER ID AUTH.USER AND CARD ID COMP. CARD INV. CARD STATUS-FOLLOW
    [Documentation]     Test Perform Card Status Update expected errors
    [Tags]      PI:14  JIRA:O5SA-160    JIRA:O5SA-373  qTest:56261393  OTR-Cards

    [Setup]    UPDATE Looking For Data To Use       N       A       TRUE
    PATCH - EXP. ERROR   CARRIER ID AUTH. USER C.ID FROM COMPANY C. SENDING INV. C. STATUS   FOLLOW   SMART_FUNDS_CARD
    [Teardown]  Remove Automation User

(OTR-Cards) PATCH Card Status Update - EXP. Error - CARRIER ID AUTH.USER AND CARD ID COMP. CARD INV. CARD STATUS-DELETE
    [Documentation]     Test Perform Card Status Update expected errors
    [Tags]      PI:14  JIRA:O5SA-160  qTest:56261393  OTR-Cards

    [Setup]    UPDATE Looking For Data To Use          N     A     TRUE
    PATCH - EXP. ERROR   CARRIER ID AUTH. USER C.ID FROM COMPANY C. SENDING INV. C. STATUS   DELETE   SMART_FUNDS_CARD
    [Teardown]  Remove Automation User

(OTR-Cards) PATCH Card Status Update - EXP. Error - CARRIER ID AUTH.USER AND CARD ID COMP. CARD INV. CARD STATUS-12345
    [Documentation]     Test Perform Card Status Update expected errors
    [Tags]      PI:14  JIRA:O5SA-160  qTest:56261393  OTR-Cards

    [Setup]    UPDATE Looking For Data To Use          N     A     TRUE
    PATCH - EXP. ERROR   CARRIER ID AUTH. USER C.ID FROM COMPANY C. SENDING INV. C. STATUS   12345   SMART_FUNDS_CARD
    [Teardown]  Remove Automation User

(OTR-Cards) PATCH Card Status Update - EXP Error - CARRIER ID AUTH.USER AND CARD ID COMP.CARD INV. CARD STATUS-SUSPENDED
    [Documentation]     Test Perform Card Status Update expected errors
    [Tags]      PI:14  JIRA:O5SA-160  qTest:56261393  OTR-Cards

    [Setup]    UPDATE Looking For Data To Use       N       A       TRUE
    PATCH - EXP. ERROR   CARRIER ID AUTH. USER C.ID FROM COMPANY C. SENDING INV. C. STATUS  SUSPENDED   SMART_FUNDS_CARD
    [Teardown]  Remove Automation User

*** Keywords ***
Getting API URL
    [Documentation]  getting portion of url to be used for testing
    Get Url For Suite      ${cardsservice}

UPDATE Looking For Data To Use
    [Documentation]    Get list of cards,carrier_id and their respective status
    [Arguments]     ${card_type}        ${q_payr_status}      ${check4}     ${with_data}=N

    IF          '${check4}'=='TRUE'
         ${query_piece}  catenate   and (SUBSTR (TRIM ( BOTH  ' ' FROM c.card_num ) ,-4 )) = cp.pin and cp.valid <> 'A'
    ELSE IF      '${check4}'=='FALSE'
         ${query_piece}  catenate   and (SUBSTR (TRIM ( BOTH  ' ' FROM c.card_num ) ,-4 )) <> cp.pin and cp.valid = 'A'
    END

    IF          '${card_type}'=='B'
         ${Un_card_B}  catenate     and c.payr_status = '${q_payr_status}'
    ELSE
         ${Un_card_B}       Set Variable        ${EMPTY}
    END

    Get Into Db         TCH
    ${query_other}          Catenate        select c.card_id, c.carrier_id as carrier_id, c.payr_use, c.payr_status,
    ...                                     c.status as cards_status, cp.card_num,
    ...                                     SUBSTR (TRIM ( BOTH  ' ' FROM c.card_num ) ,-4 ) as last_four_num,
    ...                                     cp.pin as pin,
    ...   case
    ... 	when (SUBSTR (TRIM ( BOTH  ' ' FROM c.card_num ) ,-4 )) = cp.pin then 'TRUE'
    ... 	when (SUBSTR (TRIM ( BOTH  ' ' FROM c.card_num ) ,-4 )) <> cp.pin then 'FALSE'
    ...   end as check_four,
    ...   cp.status as pin_status
    ...   from cards c, card_pins cp, contract co
    ...   where c.card_num = cp.card_num and cp.status = 'A' and c.status = 'A' ${Un_card_B}
    ...   and ((cp.passcode_enabled_flag = 'Y' and cp.passcode_enabled_flag is NULL)
    ...   OR (cp.passcode_enabled_flag = 'N') OR (cp.passcode_enabled_flag is NULL)) and c.carrier_id = co.carrier_id
    ...   and c.payr_use = '${card_type}' ${query_piece} limit 1;

    ${other_carrier_id}   Query to dictionaries      ${query_other}
    Disconnect From Database
    Create My User  persona_name=carrier_manager  application_name=OTR_eMgr
    ...             entity_id=${other_carrier_id}[0][carrier_id]  with_data=${with_data}=N

    Set Test Variable       ${other_carrier_id}

Card Status Update
    [Documentation]     Update card status
    [Arguments]     ${status_update}        ${card_type}

    ${header}       Create Dictionary       content-type=application/merge-patch+json
    ${url_stuff}    Create Dictionary       None=${other_carrier_id}[0][card_id]
    ...                                     carriers=${other_carrier_id}[0][carrier_id]     ${card_type}=None
    ${payload}      Create Dictionary       status=${status_update}

    Getting API URL

    ${result}  ${status_code}  Api request  PATCH  otr-cards  Y  ${url_stuff}  application=OTR_eMgr  header=${header}
    ...                                     payload=${payload}

    Should Be Equal As Strings      ${status_code}      200

Compare Result In Database
    [Documentation]    Get list of cards,carrier_id and their respective status
    [Arguments]     ${r_cards_status}       ${r_pin_status}     ${r_valid}      ${r_payr_status}

    Get Into Db         TCH
    ${result_query_other}       Catenate        select c.card_id, c.carrier_id, c.payr_use, c.payr_status,
    ...                         c.status as cards_status, cp.card_num, cp.pin, cp.status as pin_status,
    ...                         cp.valid from cards c, card_pins cp
    ...                         where c.card_num = cp.card_num and c.carrier_id = '${other_carrier_id}[0][carrier_id]'
    ...                         and c.card_id ='${other_carrier_id}[0][card_id]';
    ${result_other_carrier_id}      Query And Strip To Dictionary       ${result_query_other}
    Disconnect From Database
    Set Test Variable            ${result_other_carrier_id}

    Should Be Equal As Strings   ${result_other_carrier_id}[cards_status]       ${r_cards_status}
    Should Be Equal As Strings   ${result_other_carrier_id}[pin_status]         ${r_pin_status}
    Should Be Equal As Strings   ${result_other_carrier_id}[valid]              ${r_valid}

    IF          '${r_valid}'=='B'
          Should Be Equal As Strings        ${result_other_carrier_id}[payr_status]     ${r_payr_status}
    END

PATCH - EXP. ERROR
    [Documentation]    Keyword to attempt and check the Patch cardserrors
    [Arguments]     ${mistake}      ${status_update}        ${card_type}    ${with_data}=N
    ${mistake}      String.Convert To Upper Case        ${mistake}

    Create My User    persona_name=carrier_manager  application_name=OTR_eMgr  entity_id=${other_carrier_id}[0][carrier_id]
    ...               with_data=${with_data}=N

    ${header}       Create Dictionary       content-type=application/merge-patch+json
    ${url_stuff}    Create Dictionary       None=${other_carrier_id}[0][card_id]
    ...                                     carriers=${other_carrier_id}[0][carrier_id]     ${card_type}=None
    ${payload}      Create Dictionary       status=${status_update}

    IF  '${mistake}'=='INVALID TOKEN'
    ${result}  ${status_code}  Api request  PATCH  otr-cards  I  ${url_stuff}  application=OTR_eMgr  header=${header}
    ...                                     payload=${payload}

        Should Be Equal As Strings      ${status_code}      401
        Should Be Empty                 ${result}

    ELSE IF  '${mistake}'=='CARRIER NOT ASSIGNED'
        Get Into Db     TCH
        ${carrier2}     Catenate        select carrier_id from contract
        ...                             where carrier_id <> '${other_carrier_id}[0][carrier_id]' limit 1
        ${carrier2}     Query And Strip To Dictionary       ${carrier2}
        Disconnect From Database

        Set To Dictionary       ${url_stuff}    carriers=${carrier2}
        ${result}  ${status_code}  Api request  PATCH  otr-cards  Y  ${url_stuff}  application=OTR_eMgr  header=${header}

        Set To Dictionary       ${url_stuff}        carriers=${other_carrier_id}[0][carrier_id]

        Should Be Equal As Strings      ${status_code}      403
        ${response}         Get Dictionary Keys     ${result}
        Should Be Equal     ${response}[0]      message
        Should Be Equal     ${response}[1]      name

    ELSE IF  '${mistake}'=='TOKEN WITHOUT PERMISSION'
        Get Into Db     TCH
        ${carrier2}     Catenate        select carrier_id from contract
        ...                             where carrier_id <> '${other_carrier_id}[0][carrier_id]' limit 1
        ${carrier2}     Query And Strip To Dictionary       ${carrier2}
        Disconnect From Database

        Set To Dictionary       ${url_stuff}    carriers=${carrier2}
        ${result}  ${status_code}  Api request  PATCH  otr-cards  Y  ${url_stuff}  application=OTR_eMgr  header=${header}

        Set To Dictionary       ${url_stuff}        carriers=${carrier2}[carrier_id]

        Should Be Equal As Strings      ${status_code}      500
        ${response}         Get Dictionary Keys     ${result}
        Should Be Equal     ${response}[0]      message
        Should Be Equal     ${response}[1]      name

    ELSE IF  '${mistake}'=='CARD ID W/O AUTH. AND CARRIER ID WITH AUTH.'
        Get Into Db     TCH
        ${carrier2}     Catenate        select carrier_id, card_id from cards
        ...                             where carrier_id <> '${other_carrier_id}[0][carrier_id]' limit 1
        ${carrier2}     Query And Strip To Dictionary       ${carrier2}
        Disconnect From Database

        Set To Dictionary       ${url_stuff}        None=${carrier2}[card_id]
        ...                     carriers=${other_carrier_id}[0][carrier_id]     ${card_type}=None

        ${result}  ${status_code}  Api request  PATCH  otr-cards  Y  ${url_stuff}  application=OTR_eMgr  header=${header}

        ${response}     Get Dictionary Keys     ${result}
        Should Be Equal As Strings      ${status_code}      422

        Should Be Equal     ${response}[0]      error_code
        Should Be Equal     ${response}[1]      message
        Should Be Equal     ${response}[2]      name

    ELSE IF  '${mistake}'=='ERASE THE CARD ID'
        Get Into Db         TCH
        ${carrier2}         Catenate        select carrier_id, card_id from cards
        ...                                 where carrier_id <> '${other_carrier_id}[0][carrier_id]' limit 1
        ${carrier2}         Query And Strip To Dictionary       ${carrier2}
        Disconnect From Database

        Set To Dictionary       ${url_stuff}        None=${EMPTY}       carriers=${other_carrier_id}[0][carrier_id]
        ...                     ${card_type}=None

        ${result}  ${status_code}  Api request  PATCH  otr-cards  Y  ${url_stuff}  application=OTR_eMgr  header=${header}

        Should Be Equal As Strings      ${status_code}      401
        Should Be Empty     ${result}

    ELSE IF  '${mistake}'=='NONEXISTENT CARD_ID'
        Set To Dictionary       ${url_stuff}        None=99999999999        carriers=${other_carrier_id}[0][carrier_id]
        ...                     ${card_type}=None

        ${result}  ${status_code}  Api request  PATCH  otr-cards  Y  ${url_stuff}  application=OTR_eMgr  header=${header}

        ${response}     Get Dictionary Keys     ${result}
        Should Be Equal As Strings      ${status_code}      422

        Should Be Equal     ${response}[0]      error_code
        Should Be Equal     ${response}[1]      message
        Should Be Equal     ${response}[2]      name

    ELSE IF  '${mistake}'=='LETTERS AS CARD ID'
        Set To Dictionary       ${url_stuff}        None=ABABABABABA        carriers=${other_carrier_id}[0][carrier_id]
        ...                     ${card_type}=None

        ${result}  ${status_code}  Api request  PATCH  otr-cards  Y  ${url_stuff}  application=OTR_eMgr  header=${header}

        Should Be Equal As Strings      ${status_code}      400
        Should Be Empty     ${result}

    ELSE IF  '${mistake}'=='CARD ID WITH AUTH. AND CARRIER ID EMPTY'
        Set To Dictionary       ${url_stuff}        None=${other_carrier_id}[0][card_id]        carriers=${EMPTY}
        ...                     ${card_type}=None

        ${result}  ${status_code}  Api request  PATCH  otr-cards  Y  ${url_stuff}  application=OTR_eMgr  header=${header}

        Should Be Equal As Strings      ${status_code}      401
        Should Be Empty     ${result}

    ELSE IF  '${mistake}'=='NONEXISTENT CARRIER_ID'
        Set To Dictionary       ${url_stuff}        None=${other_carrier_id}[0][card_id]        carriers=888888
        ...                     ${card_type}=None

        ${result}  ${status_code}  Api request  PATCH  otr-cards  Y  ${url_stuff}  application=OTR_eMgr  header=${header}

        Should Be Equal As Strings      ${status_code}      403
        ${response}         Get Dictionary Keys     ${result}
        Should Be Equal     ${response}[0]      message
        Should Be Equal     ${response}[1]      name

    ELSE IF  '${mistake}'=='LETTERS AS CARRIER ID'
        Set To Dictionary       ${url_stuff}        None=${other_carrier_id}[0][card_id]        carriers=CDCDCD
        ...                     ${card_type}=None

        ${result}  ${status_code}  Api request  PATCH  otr-cards  Y  ${url_stuff}  application=OTR_eMgr  header=${header}

        Should Be Equal As Strings      ${status_code}      403
        ${response}         Get Dictionary Keys     ${result}
        Should Be Equal     ${response}[0]      message
        Should Be Equal     ${response}[1]      name

    ELSE IF  '${mistake}'=='REMOVE CASH TYPE'
        Set To Dictionary       ${url_stuff}        None=${other_carrier_id}[0][card_id]
        ...                     carriers=${other_carrier_id}[0][carrier_id]     ${card_type}=None

        ${result}  ${status_code}  Api request  PATCH  otr-cards  Y  ${url_stuff}  application=OTR_eMgr  header=${header}
        Should Be Equal As Strings      ${status_code}      405
        Should Be Empty     ${result}


    ELSE IF  '${mistake}'=='LETTERS AS CASH TYPE'
        Set To Dictionary       ${url_stuff}        None=${other_carrier_id}[0][card_id]
        ...                     carriers=${other_carrier_id}[0][carrier_id]     ${card_type}=None
    ${result}  ${status_code}  Api request  PATCH  otr-cards  Y  ${url_stuff}  application=OTR_eMgr  header=${header}

        Should Be Equal As Strings      ${status_code}      400
        Should Be Empty     ${result}


    ELSE IF  '${mistake}'=='CARRIER ID FROM AUTH. USER CARD ID FROM PAYROLL'
        Get Into Db     TCH
        ${carrier3}     Catenate       select c.card_id, c.carrier_id, c.payr_use, c.payr_status,
        ...                            c.status as cards_status, cp.card_num,
        ...                            SUBSTR (TRIM ( BOTH  ' ' FROM c.card_num ) ,-4 ) as last_four_num, cp.pin as pin,
        ...  case
        ...      when (SUBSTR (TRIM ( BOTH  ' ' FROM c.card_num ) ,-4 )) = cp.pin then 'TRUE'
        ...      when (SUBSTR (TRIM ( BOTH  ' ' FROM c.card_num ) ,-4 )) <> cp.pin then 'FALSE'
        ...  end as check_four,
        ...  cp.status as pin_status
        ...  from cards c, card_pins cp
        ...  where c.card_num = cp.card_num and cp.status = 'A' and c.status = 'A' and c.payr_status = 'A'
        ...  and ((cp.passcode_enabled_flag = 'Y' and cp.passcode_enabled_flag is NULL)
        ...  OR (cp.passcode_enabled_flag = 'N') OR (cp.passcode_enabled_flag is NULL)) and c.payr_use = 'P' limit 1;

        ${carrier3}     Query And Strip To Dictionary       ${carrier3}
        Disconnect From Database
        Set To Dictionary       ${url_stuff}        carriers=${carrier3}

        Set To Dictionary       ${url_stuff}        None=${carrier3}[card_id]
        ...                     carriers=${other_carrier_id}[0][carrier_id]     ${card_type}=None

        ${result}  ${status_code}  Api request  PATCH  otr-cards  Y  ${url_stuff}  application=OTR_eMgr  header=${header}

        ${response}     Get Dictionary Keys     ${result}
        Should Be Equal As Strings      ${status_code}      422

        Should Be Equal     ${response}[0]      error_code
        Should Be Equal     ${response}[1]      message
        Should Be Equal     ${response}[2]      name

    ELSE IF  '${mistake}'=='CARRIER ID FROM THE AUTH. USER AND CARD ID FROM COMPANY C.'
        Get Into Db     TCH
        ${carrier3}     Catenate       select c.card_id, c.carrier_id, c.payr_use, c.payr_status,
        ...                            c.status as cards_status, cp.card_num,
        ...                            SUBSTR (TRIM ( BOTH  ' ' FROM c.card_num ) ,-4 ) as last_four_num, cp.pin as pin,
        ...  case
        ...      when (SUBSTR (TRIM ( BOTH  ' ' FROM c.card_num ) ,-4 )) = cp.pin then 'TRUE'
        ...      when (SUBSTR (TRIM ( BOTH  ' ' FROM c.card_num ) ,-4 )) <> cp.pin then 'FALSE'
        ...  end as check_four,
        ...  cp.status as pin_status
        ...  from cards c, card_pins cp
        ...  where c.card_num = cp.card_num and cp.status = 'A' and c.status = 'A' and c.payr_status = 'A'
        ...  and ((cp.passcode_enabled_flag = 'Y' and cp.passcode_enabled_flag is NULL)
        ...  OR (cp.passcode_enabled_flag = 'N') OR (cp.passcode_enabled_flag is NULL)) and c.payr_use = 'N' limit 1;

        ${carrier3}     Query And Strip To Dictionary       ${carrier3}
        Disconnect From Database
        Set To Dictionary       ${url_stuff}        carriers=${carrier3}

        Set To Dictionary       ${url_stuff}        None=${carrier3}[card_id]
        ...                     carriers=${other_carrier_id}[0][carrier_id]     ${card_type}=None

        ${result}  ${status_code}  Api request  PATCH  otr-cards  Y  ${url_stuff}  application=OTR_eMgr  header=${header}

       ${response}     Get Dictionary Keys     ${result}
        Should Be Equal As Strings      ${status_code}      422

        Should Be Equal     ${response}[0]      error_code
        Should Be Equal     ${response}[1]      message
        Should Be Equal     ${response}[2]      name

    ELSE IF  '${mistake}'=='CARRIER ID AUTH.USER AND C.ID FROM COMPANY C. TYPE W/O REQUEST BODY'
        Set To Dictionary       ${url_stuff}        None=${other_carrier_id}[0][card_id]
        ...                     carriers=${other_carrier_id}[0][carrier_id]     ${card_type}=None

        ${result}  ${status_code}  Api request  PATCH  otr-cards  Y  ${url_stuff}  application=OTR_eMgr  header=${header}

        ${response}     Get Dictionary Keys     ${result}
        Should Be Equal As Strings      ${status_code}      422

        Should Be Equal     ${response}[0]      error_code
        Should Be Equal     ${response}[1]      message
        Should Be Equal     ${response}[2]      name

    ELSE IF  '${mistake}'=='CARRIER ID AUTH. USER C.ID FROM COMPANY C. SENDING INV. C. STATUS'
        Set To Dictionary       ${url_stuff}        None=${other_carrier_id}[0][card_id]
        ...                     carriers=${other_carrier_id}[0][carrier_id]     ${card_type}=None

        ${result}  ${status_code}  Api request  PATCH  otr-cards  Y  ${url_stuff}  application=OTR_eMgr  header=${header}

        ${response}     Get Dictionary Keys     ${result}
        Should Be Equal As Strings      ${status_code}      422

        Should Be Equal     ${response}[0]      error_code
        Should Be Equal     ${response}[1]      message
        Should Be Equal     ${response}[2]      name

    ELSE
        Fail  The '${mistake}' is not an implemented expected error scenario
    END