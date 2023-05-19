*** Settings ***
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService

Force Tags  Web Services
Suite Setup  Setup WS

*** Test Cases ***
Create Info Limit Card Using Valid Parameters
    [Tags]  JIRA:BOT-1616  qTest:30779575  Regression
    [Documentation]  Creates a virtual card with limits that can be tied to a driver's card with a trip number.
    ...     When a driver is linked to a trip card, purchases will pull from that virtual card.

    Set Test Variable  ${infoId}  UNIT
    Set Test Variable  ${reportValue}  1234
    Set Test Variable  ${card_num}  ${validCard.carrier.id}${infoId}${reportValue}

    ${WS_INFO}  createInfoLmitCard  1  ${infoId}  ${reportValue}
    ${DB_INFO}  Check Card Exists on DB

    Should Be Equal As Strings  ${WS_INFO}  ${DB_INFO}

Create Info Limit Card Using EMPTY Prompt Type
    [Tags]  JIRA:BOT-1616  qTest:30779743  Regression
    [Documentation]  Make sure you can't create a virtual card when you have an empty parameter.

    ${status}  Run Keyword And Return Status  createInfoLmitCard  1  ${EMPTY}  1234
    Should Not Be True  ${status}

Create Info Limit Card Using EMPTY Policy Type
    ${status}  Run Keyword And Return Status  createInfoLmitCard  ${EMPTY}  DRID  1234
    Should Not Be True  ${status}

Create Info Limit Card Using EMPTY Prompt Value
    ${status}  Run Keyword And Return Status  createInfoLmitCard  1  DRID  ${EMPTY}
    Should Not Be True  ${status}

Create Info Limit Card Using Special Characters In Policy
    [Tags]  JIRA:BOT-1616  qTest:30779797  Regression
    [Documentation]  Make sure you can't create a virtual card when you have a Special Character parameter.

    ${status}  Run Keyword And Return Status  createInfoLmitCard  !  DRID  1234
    Should Not Be True  ${status}

Create Info Limit Card Using Special Characters In Prompt Type
    ${status}  Run Keyword And Return Status  createInfoLmitCard  1  UNIT@  1234
    Should Not Be True  ${status}

Create Info Limit Card Using Special Characters In Prompt Value
    ${status}  Run Keyword And Return Status  createInfoLmitCard  1  DRID  !@$#
    Should Not Be True  ${status}

Create Info Limit Card Using SPACE In The Policy
    [Tags]  JIRA:BOT-1616  qTest:30779833  Regression
    [Documentation]  Make sure you can't create a virtual card when you have a Space Character parameter.

    ${status}  Run Keyword And Return Status  createInfoLmitCard  ${SPACE}  DRID  1234
    Should Not Be True  ${status}

Create Info Limit Card Using SPACE In The Prompt Type
    ${status}  Run Keyword And Return Status  createInfoLmitCard  1  ${SPACE}  1234
    Should Not Be True  ${status}

Create Info Limit Card Using SPACE In The Prompt Value
    ${status}  Run Keyword And Return Status  createInfoLmitCard  1  DRID  ${SPACE}
    Should Not Be True  ${status}

Create Info Limit Card With Invalid Policy
    [Tags]  JIRA:BOT-1616  qTest:37189594  Regression  JIRA:FRNT-55  refactor
    [Documentation]  Make sure you can't create a virtual card when you have a typo in one of the parameters.

    ${status}  Run Keyword And Return Status  createInfoLmitCard  9999  DRID  1234
    Should Not Be True  ${status}
    should contain  ${ws_error}  Invalid policy number

Create Info Limit Card With Invalid Prompt Type
    ${status}  Run Keyword And Return Status  createInfoLmitCard  1  DRIDOA  1234
    Should Not Be True  ${status}


*** Keywords ***
Setup WS
    Get Into DB  TCH
    log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

Tear Me Down
    Disconnect From Database
    Logout

Check Card Exists on DB

    ${query}  catenate
    ...     SELECT TRIM(card_num) FROM cards
    ...     WHERE card_num='${card_num}'
    ...     ORDER BY created DESC limit 1
    ${results}  Query And Strip  ${query}
    [Return]  ${results}