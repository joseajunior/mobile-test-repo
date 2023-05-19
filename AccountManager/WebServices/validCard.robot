*** Settings ***
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  otr_model_lib.Models
Library  otr_robot_lib.support.PyLibrary

Force Tags  Web Services

Suite Setup  Setup WS

*** Variables ***
${DRID}  1234


*** Test Cases ***
Get A Valid Card Info
    [Tags]  JIRA:BOT-1871  qTest:31240860  Regression  refactor
    [Documentation]  Make sure you can fetch information from validCard ws request when you have valid info.

    ${WS_INFO}  validCard  ${mobi_card.card_num}  ${card_pin}  ${DRID}

    ${DB_INFO}  Get Valid Card Info

    Should Be Equal As Strings  ${DB_INFO['name']}   ${WS_INFO['result']}
    Should Be Equal As Strings  ${DB_INFO['carrierId']}  ${WS_INFO['carrierId']}

Get A Valid Card Info With Empty Parameter
    [Tags]  JIRA:BOT-1871  qTest:31241275  Regression
    [Documentation]  Make sure you can't fetch information from validCard ws request when you have empty parameters

    ${status}  validCard  ${mobi_card.card_num}  ${EMPTY}  ${DRID}
    Should Be Equal As Strings  ${status['result']}  Invalid card number or pin

    ${status}  validCard  ${mobi_card.card_num}  ${card_pin}  ${EMPTY}
    Should Be Equal As Strings  ${status['result']}  Invalid driver id

    ${status}  validCard  ${EMPTY}  ${card_pin}  101010
    Should Be Equal As Strings  ${status['result']}  Invalid card number or pin

Get A Valid Card Info With Typo On Parameter
    [Tags]  JIRA:BOT-1871  qTest:31241351  Regression
    [Documentation]  Make sure you can't fetch information from validCard ws request when you have typo on the parameters

    ${status}  validCard  ${mobi_card.card_num}  ${card_pin}A99  ${DRID}
    Should Be Equal As Strings  ${status['result']}  Invalid card number or pin

    ${status}  validCard  ${mobi_card.card_num}  ${card_pin}  1${DRID}0A10
    Should Be Equal As Strings  ${status['result']}  Invalid driver id

    ${status}  validCard  7083050A91B03C86616252  ${card_pin}  ${DRID}
    Should Be Equal As Strings  ${status['result']}  Invalid card number or pin

Get A Valid Card Info With Space On Parameter
    [Tags]  JIRA:BOT-1871  qTest:31241381  Regression
    [Documentation]  Make sure you can't fetch information from validCard ws request when you have space on the parameters.

    ${status}  validCard  ${SPACE}  ${card_pin}  ${DRID}
    Should Be Equal As Strings  ${status['result']}  Invalid card number or pin

    ${status}  validCard  ${mobi_card.card_num}  ${SPACE}  ${DRID}
    Should Be Equal As Strings  ${status['result']}  Invalid card number or pin

    ${status}  validCard  ${mobi_card.card_num}  ${card_pin}  ${SPACE}
    Should Be Equal As Strings  ${status['result']}  Invalid driver id

Get A Valid Card Info With Invalid Parameter
    [Tags]  JIRA:BOT-1871  qTest:31241395  Regression
    [Documentation]  Make sure you can't fetch information from validCard ws request when you have invalid info.

    ${status}  validCard  708305!@#$@!6616252  ${card_pin}  ${DRID}
    Should Be Equal As Strings  ${status['result']}  Invalid card number or pin

    ${status}  validCard  ${mobi_card.card_num}  ${card_pin}!@#999  ${DRID}
    Should Be Equal As Strings  ${status['result']}  Invalid card number or pin

    ${status}  validCard  ${mobi_card.card_num}  ${card_pin}  ${DRID}@#!$#0
    Should Be Equal As Strings  ${status['result']}  Invalid driver id

*** Keywords ***

Setup WS

    Get Into DB  TCH
    ${query}  catenate  SELECT TRIM(c.card_num) AS card_num FROM cards c, card_pins cp
    ...    WHERE c.card_num LIKE '708305%'
    ...    AND c.card_num NOT LIKE '%OVER'
    ...    AND c.card_num=cp.card_num
    ...    AND cp.pin IS NOT NULL
    ...    AND cp.status='A'
    ...    AND cp.valid='A'
    ...    AND c.payr_use = 'B'
    ...    ANd c.status='A'
    ...    AND c.mrcsrc = 'N'

    ${mobi_card}  Find Card Variable  ${query}
    Set Suite Variable  ${mobi_card}
    Tch Logging  ${mobi_card.card_num}

    ${card_pin}  Query And Strip  SELECT pin FROM card_pins WHERE card_num='${mobi_card.card_num}'
    Set Suite Variable  ${card_pin}

    Tch Logging  ${mobi_card.carrier.id}|${mobi_card.carrier.password}
    Log Into Card Management Web Services  ${mobi_card.carrier.id}  ${mobi_card.carrier.password}

    Start Setup Card  ${mobi_card.card_num}
    Setup Card Prompts  DRID=V${DRID}


Get Valid Card Info

    Get Into DB  MYSQL
    ${query}  catenate
    ...     SELECT TRIM(sc.name) AS name, sc.company_id AS carrierId FROM sec_user s, sec_company sc WHERE s.user_id LIKE '${mobi_card.carrier.id}' AND sc.company_id=s.company_id;
    ${results}  Query And Strip To Dictionary  ${query}

    [Return]  ${results}