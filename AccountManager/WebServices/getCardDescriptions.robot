*** Settings ***
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService

Force Tags  Web Services
Suite Setup  Setup WS

*** Test Cases ***
Get Card Descriptions With Invalid Created Since Date
    [Tags]  JIRA:BOT-1614  qTest:30705914  Regression
    [Documentation]  Make sure you can't fetch informations from getCardDescriptions with an invalid Date

    ${status}  Run Keyword And Return Status  getCardDescriptions  20197-03-29T00:00:00
    Should Not Be True  ${status}

     ${status}  Run Keyword And Return Status  getCardDescriptions  2019-35-29T00:00:00
    Should Not Be True  ${status}

     ${status}  Run Keyword And Return Status  getCardDescriptions  20197-03-163T00:00:00
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  getCardDescriptions  2019-03-29T25:00:00
    Should Not Be True  ${status}

     ${status}  Run Keyword And Return Status  getCardDescriptions  2019-03-29T00:65:00
    Should Not Be True  ${status}

     ${status}  Run Keyword And Return Status  getCardDescriptions  2019-03-29T00:00:65
    Should Not Be True  ${status}

Get Card Descriptions With valid Created Since Date
    [Tags]  JIRA:BOT-1614  qTest:30705928  Regression  refactor
    [Documentation]  Make sure you can fetch information from getCardDescriptions ws call using a valid created since date
    ${CardDescriptions}  getCardDescriptions  2019-03-29  00:00:00
    ${db_infos}  Get Cards From DB
    ${same_dict}  Compare List Dictionaries As Strings  ${db_infos}  ${CardDescriptions}
    Should Be True  ${same_dict}

Get Card Descriptions With EMPTY Created Since Date
    [Tags]  JIRA:BOT-1614  qTest:30705932  Regression
    [Documentation]  Make sure you can't fetch informations from getCardDescriptions with an empty created since field
    ${status}  Run Keyword And Return Status  getCardDescriptions  ${EMPTY}
    Should Not Be True  ${status}

Get Card Descriptions With SPACE Created Since Date
    [Tags]  JIRA:BOT-1614  qTest:30705941  Regression
    [Documentation]  Make sure you can't fetch informations from getCardDescriptions with a space created since field
    ${status}  Run Keyword And Return Status  getCardDescriptions  ${SPACE}
    Should Not Be True  ${status}

Get Card Descriptions With TYPO on Created Since Date
    [Tags]  JIRA:BOT-1614  qTest:30705942  Regression
    [Documentation]  Make sure you cant fetch information from getCardDescription ws call with a typo on a date
    ${status}  Run Keyword And Return Status  getCardDescriptions  201X-03-29T00:00:00
    Should Not Be True  ${status}

     ${status}  Run Keyword And Return Status  getCardDescriptions  2019-0X-29T00:00:00
    Should Not Be True  ${status}

     ${status}  Run Keyword And Return Status  getCardDescriptions  2019-03-2XT00:00:00
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  getCardDescriptions  2019-03-29T3X:00:00
    Should Not Be True  ${status}

     ${status}  Run Keyword And Return Status  getCardDescriptions  2019-03-29T00:3X:00
    Should Not Be True  ${status}

     ${status}  Run Keyword And Return Status  getCardDescriptions  2019-03-29T00:00:3X
    Should Not Be True  ${status}

*** Keywords ***
Setup WS
    Get Into DB  TCH
    log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

Get Cards From DB

    ${query}  catenate
    ...     SELECT TRIM(card_num) AS cardNumber,
    ...     coxref AS companyXRef
    ...     FROM cards
    ...     WHERE created='2019-03-29'
    ...     AND carrier_id=${userName}
    ...     AND cardoverride='0'
    ${results}  Query To Dictionaries  ${query}
    [Return]  ${results}