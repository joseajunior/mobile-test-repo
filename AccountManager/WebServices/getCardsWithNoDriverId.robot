*** Settings ***
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService

Force Tags  Web Services
Suite Setup  Setup WS

*** Test Cases ***

Get Cards With No Driver Id
    [Tags]  JIRA:BOT-1617  qTest:30808602  Regression
    [Documentation]  Make sure you can pull up the cards that has no driver id assigned

    ${WS_INFO}  getCardsWithNoDriverId

    Should Not Be Empty  ${WS_INFO}

Get Cards With No Driver Id With An Invalid Card Type
    [Tags]  JIRA:BOT-1617  qTest:30808618  Regression
    [Documentation]  Make sure you can't pull up the cards that has no driver id assigned when you have an invalid card typ

    ${status}  Run Keyword And Return Status  getCardsWithNoDriverId  TCHAAA123
    Should Not Be True  ${status}


Get Cards With No Driver Id With Special Characters On the Card Type Parameter
    [Tags]  JIRA:BOT-1617  qTest:30808639  Regression
    [Documentation]  Make sure you can't pull up the cards that has no driver id assigned when you have special characters
     ...    on the card type

    ${status}  Run Keyword And Return Status  getCardsWithNoDriverId  TCH!@#
    Should Not Be True  ${status}

*** Keywords ***
Setup WS
    Get Into DB  TCH
    log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

Get Cards With No DRID
    ${query}  catenate
    ...     SELECT DISTINCT TRIM(c.card_num)
    ...     FROM cards c,
    ...          card_inf cf,
    ...          def_info df
    ...     WHERE c.card_num = cf.card_num
    ...     AND   c.carrier_id = 103866
    ...     AND   c.carrier_id=df.carrier_id
    ...     AND   cf.info_id NOT LIKE '%DRID%'
    ...     AND   df.info_id NOT LIKE '%DRID%'
    ...     AND   c.cardoverride ='0' AND c.status='A'
    ${results}  Query To Dictionaries  ${query}
    [Return]  ${results}