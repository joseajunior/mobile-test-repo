*** Settings ***
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary

Force Tags  Web Services

Suite Setup  Setup WS

*** Test Cases ***
Get Order Information With a Valid Order ID
    [Tags]  JIRA:BOT-1620  qTest:31723711  Regression  refactor
    [Documentation]  Make sure you can fetch information from the getOrder using a valid order Id number

    Set Test Variable  ${order_id}  42879

    ${WS_INFO}  getOrder  ${order_id}
    Remove From Dictionary  ${WS_INFO}  props
    ${DB_INFO}  Fetch Order From DB

    ${same_dict}  compare dictionaries as strings  ${WS_INFO}  ${DB_INFO[0]}
    Should Be True  ${same_dict}

Get Order Information With an Empty Order ID
    [Tags]  JIRA:BOT-1620  qTest:31723917  Regression
    [Documentation]  Make sure you can't fetch information from the getOrder with no order ID number

    ${status}  Run Keyword And Return Status  getOrder  ${EMPTY}
    Should Not Be True  ${status}

Get Order Information With an Invalid Order ID
    [Tags]  JIRA:BOT-1620  qTest:31723999  Regression
    [Documentation]  Make sure you can't fecth information from getOrder WS call with an invalid Order ID

    ${status}  Run Keyword And Return Status  getOrder  1nv4L!@
    Should Not Be True  ${status}

Get Order Information With a typo On The Order ID
    [Tags]  JIRA:BOT-1620  qTest:31724059  Regression
    [Documentation]  Make sure you can't fecth information from getOrder WS call when you have a typo on Order ID number

    ${status}  Run Keyword And Return Status  getOrder  58A59
    Should Not Be True  ${status}

Get Order Information With a Space On The Order ID
    [Tags]  JIRA:BOT-1620  qTest:31724121  Regression
    [Documentation]  Make sure you can't fecth information from getOrder WS call when you have a space on Order ID number

    ${status}  Run Keyword And Return Status  getOrder  58${SPACE}59
    Should Not Be True  ${status}

*** Keywords ***

Setup WS
    Get Into DB  TCH
    log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

Fetch Order From DB

    ${query}  catenate
    ...     SELECT ccb_card_order_id AS orderId,
    ...     policy AS policyNumber,
    ...     ccb_order_type_id AS orderType,
    ...     card_style AS cardStyle
    ...     FROM ccb_card_orders
    ...     WHERE carrier_id = ${validCard.carrier.id}
    ...     AND   ccb_card_order_id = ${order_id}
    ${result}  Query To Dictionaries  ${query}
    [Return]  ${result}