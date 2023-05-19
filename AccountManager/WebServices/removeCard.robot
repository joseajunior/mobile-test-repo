*** Settings ***
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService

Force Tags  Web Services
Suite Setup  Setup WS
Test Teardown  Tear Me Down

*** Test Cases ***

Try To Remove a Card Using a Valid Card
    [Tags]  JIRA:BOT-1610  qTest:30833379  Regression  refactor

    Get Into DB  TCH
    ${WS_INFO_CreateInfoLimit}  createInfoLmitCard  1  UNIT  5689
    Row Count Is Equal To X  SELECT * FROM cards WHERE card_num='${validCard.carrier.id}UNIT7890'  1
    ${WS_INFO_removeCard}  removeCard  103866UNIT5689
    ${query}  catenate
    ...     SELECT status FROM cards WHERE card_num='${validCard.carrier.id}UNIT5689'
    ${results}  Query And Strip  ${query}
    Should Be Equal As Strings  ${results}  D


Try To Remove a Card Using an Inactive Card
    [Tags]  JIRA:BOT-1610  qTest:30833635  Regression

    Get Into DB  TCH
    log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    ${GetInactiveCard}  catenate
    ...     SELECT TRIM(card_num) AS card_num FROM cards WHERE status='I' AND carrier_id=${validCard.carrier.id} AND card_num NOT LIKE '%OVER%' AND cardoverride='0' ORDER BY created ASC limit 1;
    ${InactiveCard}  Query And Strip  ${GetInactiveCard}
    Tch Logging  ${InactiveCard}
    ${WS_INFO_removeCard}  removeCard  ${InactiveCard}

    ${query}  catenate
    ...     SELECT status FROM cards WHERE card_num='${InactiveCard}'
    ${results}  Query And Strip  ${query}
    Should Be Equal As Strings  ${results}  D

Try To Remove a Card With a Typo On the Card Number
    [Tags]  JIRA:BOT-1610  qTest:30833658  Regression

    ${status}  Run Keyword And Return Status  removeCard  7083059961AA000100018
    Should Not Be True  ${status}

Try To Remove a Card With an EMPTY value
    [Tags]  JIRA:BOT-1610  qTest:30833676  Regression

    ${status}  Run Keyword And Return Status  removeCard  ${EMPTY}
    Should Not Be True  ${status}

Try To Remove a Card With a SPACE On the Card Number
    [Tags]  JIRA:BOT-1610  qTest:30833683  Regression

    ${status}  Run Keyword And Return Status  removeCard  ${SPACE}
    Should Not Be True  ${status}

Try To Remove a Card With Special Characters On the Card Number
    [Tags]  JIRA:BOT-1610  qTest:30833692  Regression

    ${status}  Run Keyword And Return Status  removeCard  70830!@#$$#%@00018
    Should Not Be True  ${status}

*** Keywords ***
Setup WS
    Get Into DB  TCH
    log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

Tear Me Down
    Disconnect From Database
    Logout