*** Settings ***
Resource  ../../Variables/validUser.robot
Library  String
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  Collections
Resource  otr_robot_lib/robot/RobotKeywords.robot

Force Tags  Web Services

Suite Setup  Setup WS
Suite Teardown  Teardown WS

*** Test Cases ***
Find Valid Order
    [Tags]  JIRA:BOT-1900  qTest:31768724  Regression  refactor
    [Documentation]  This is a method that allows you to search card orders under your customer.

    ${WS_INFO}  findOrders  startDate=2019-04-23  startTime=00:15:00  endDate=2019-04-23  endTime=01:15:00  orderStatus=Y

    Remove From Dictionary  ${WS_INFO}  embossedName
    Remove From Dictionary  ${WS_INFO}  shipToFirst
    Remove From Dictionary  ${WS_INFO}  shipToLast
    Remove From Dictionary  ${WS_INFO}  shipToAddress1
    Remove From Dictionary  ${WS_INFO}  shipToAddress2
    Remove From Dictionary  ${WS_INFO}  shipToCity
    Remove From Dictionary  ${WS_INFO}  shipToState
    Remove From Dictionary  ${WS_INFO}  shipToZip
    Remove From Dictionary  ${WS_INFO}  shipToCountry

    ${createdDate}  Format Date to Dic  ${WS_INFO}  createdDate
    Set To Dictionary  ${WS_INFO}  createdDate=${createdDate}

    Tch Logging  \n WS_INFO:${WS_INFO}
    ${DB_INFO}  Get Order Info
    Tch Logging  \n DB_INFO:${DB_INFO}

    ${same_dict}  Compare Dictionaries As Strings  ${WS_INFO}  ${DB_INFO[0]}
    Should Be True  ${same_dict}

Find Order Using Empty Parameters
    [Tags]  JIRA:BOT-1900  qTest:31768831  Regression  refactor
    [Documentation]  Make sure you can't fetch any information from findOrder ws call when you have no parameters filled out.

    ${WS_INFO}  findOrders  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}

#   GET ALL ORDERS BASED ON THE CARRIER ID - THIS QUERY IS LIMITED BY 1000 BECAUSE THAT'S THE NUMBER OF RESULTS COMING FROM DB.
#   YES, I HAD TO COUNT.
    ${QUERY}  catenate  SELECT ccb_card_order_id AS orderId, TO_CHAR(created,'%Y-%m-%dT%H:%M:%S') AS createdDate, order_status AS orderStatus,
    ...     TRIM(DECODE(status_msg, NULL, 'None', status_msg)) AS statusMsg, order_qty AS orderQty, ccb_card_option_id AS orderType, Policy AS policyNumber,
    ...     card_style AS cardStyle, DECODE(shipping_method_id, NULL, 0, shipping_method_id) AS shippingMethod, TRIM(DECODE(rush_processing, NULL, 'None', rush_processing)) AS rushProcessing FROM ccb_card_orders WHERE carrier_id = ${validCard.carrier.id}
    ...     ORDER BY ccb_card_order_id ASC limit 1000

    ${DB_INFO}  Query To Dictionaries  ${QUERY}

    Remove Non Matching Values  ${WS_INFO}  ${DB_INFO}

    ${same_dict}  Compare List Dictionaries As Strings  ${DB_INFO}  ${WS_INFO}
    Should Be True   ${same_dict}

Find Order Using Parameters With Typo
    [Tags]  JIRA:BOT-1900  qTest:31773441  Regression
    [Documentation]  Make sure you can't fetch any information from findOrder ws call when you have a typo on any parameter

#   START TIME
    ${WS_INFO}  Run Keyword And Return Status  findOrders  20A19-04-24  00:00:00  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}
    Should Not Be True  ${WS_INFO}

    ${WS_INFO}  Run Keyword And Return Status  findOrders  2019-0B4-24  00:00:00  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}
    Should Not Be True  ${WS_INFO}

    ${WS_INFO}  Run Keyword And Return Status  findOrders  2019-04-2C4  00:00:00  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}
    Should Not Be True  ${WS_INFO}

    ${WS_INFO}  Run Keyword And Return Status  findOrders  2019-04-24  0A:00:00  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}
    Should Not Be True  ${WS_INFO}

    ${WS_INFO}  Run Keyword And Return Status  findOrders  2019-04-24  00:0A:00  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}
    Should Not Be True  ${WS_INFO}

    ${WS_INFO}  Run Keyword And Return Status  findOrders  2019-04-24  00:00:0A  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}
    Should Not Be True  ${WS_INFO}

#    END TIME
    ${WS_INFO}  Run Keyword And Return Status  findOrders  ${EMPTY}  20A19-04-24  00:00:00  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}
    Should Not Be True  ${WS_INFO}

    ${WS_INFO}  Run Keyword And Return Status  findOrders  ${EMPTY}  2019-0B4-24  00:00:00  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}
    Should Not Be True  ${WS_INFO}

    ${WS_INFO}  Run Keyword And Return Status  findOrders  ${EMPTY}  2019-04-2C4  00:00:00  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}
    Should Not Be True  ${WS_INFO}

    ${WS_INFO}  Run Keyword And Return Status  findOrders  ${EMPTY}  2019-04-24  0A:00:00  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}
    Should Not Be True  ${WS_INFO}

    ${WS_INFO}  Run Keyword And Return Status  findOrders  ${EMPTY}  2019-04-24  00:0A:00  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}
    Should Not Be True  ${WS_INFO}

    ${WS_INFO}  Run Keyword And Return Status  findOrders  ${EMPTY}  2019-04-24  00:00:0A  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}
    Should Not Be True  ${WS_INFO}

Find Order Using Invalid Parameters
    [Tags]  JIRA:BOT-1900  qTest:31773464  Regression
    [Documentation]  Make sure you can't fetch any information from findOrders ws call when you have invalid parameters

#   START TIME
    ${WS_INFO}  Run Keyword And Return Status  findOrders  0-04-24  00:00:00  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}
    Should Not Be True  ${WS_INFO}

    ${WS_INFO}  Run Keyword And Return Status  findOrders  2019-54-24  00:00:00  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}
    Should Not Be True  ${WS_INFO}

    ${WS_INFO}  Run Keyword And Return Status  findOrders  2019-04-62  00:00:00  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}
    Should Not Be True  ${WS_INFO}

    ${WS_INFO}  Run Keyword And Return Status  findOrders  2019-04-24  70:00:00  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}
    Should Not Be True  ${WS_INFO}

    ${WS_INFO}  Run Keyword And Return Status  findOrders  2019-04-24  00:85:00  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}
    Should Not Be True  ${WS_INFO}

    ${WS_INFO}  Run Keyword And Return Status  findOrders  2019-04-24  00:00:92  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}
    Should Not Be True  ${WS_INFO}

#    END TIME
    ${WS_INFO}  Run Keyword And Return Status  findOrders  ${EMPTY}  0-04-24  00:00:00  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}
    Should Not Be True  ${WS_INFO}

    ${WS_INFO}  Run Keyword And Return Status  findOrders  ${EMPTY}  2019-54-24  00:00:00  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}
    Should Not Be True  ${WS_INFO}

    ${WS_INFO}  Run Keyword And Return Status  findOrders  ${EMPTY}  2019-04-62  00:00:00  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}
    Should Not Be True  ${WS_INFO}

    ${WS_INFO}  Run Keyword And Return Status  findOrders  ${EMPTY}  2019-04-24  70:00:00  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}
    Should Not Be True  ${WS_INFO}

    ${WS_INFO}  Run Keyword And Return Status  findOrders  ${EMPTY}  2019-04-24  00:85:00  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}
    Should Not Be True  ${WS_INFO}

    ${WS_INFO}  Run Keyword And Return Status  findOrders  ${EMPTY}  2019-04-24  00:00:92  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}
    Should Not Be True  ${WS_INFO}

Find Order Using Parameters With Special Characters
    [Tags]  JIRA:BOT-1900  qTest:31773527  Regression
    [Documentation]  Make sure you can't fetch any information from findOrders ws call when you have invalid parameters

#   START TIME
    ${WS_INFO}  Run Keyword And Return Status  findOrders  @#@$-04-24  00:00:00  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}
    Should Not Be True  ${WS_INFO}

    ${WS_INFO}  Run Keyword And Return Status  findOrders  2019-!4-24  00:00:00  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}
    Should Not Be True  ${WS_INFO}

    ${WS_INFO}  Run Keyword And Return Status  findOrders  2019-04-6@  00:00:00  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}
    Should Not Be True  ${WS_INFO}

    ${WS_INFO}  Run Keyword And Return Status  findOrders  2019-04-24  &0:00:00  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}
    Should Not Be True  ${WS_INFO}

    ${WS_INFO}  Run Keyword And Return Status  findOrders  2019-04-24  00:8#:00  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}
    Should Not Be True  ${WS_INFO}

    ${WS_INFO}  Run Keyword And Return Status  findOrders  2019-04-24  00:00:9$  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}
    Should Not Be True  ${WS_INFO}

#    END TIME
    ${WS_INFO}  Run Keyword And Return Status  findOrders  ${EMPTY}  @#@$-04-24  00:00:00  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}
    Should Not Be True  ${WS_INFO}

    ${WS_INFO}  Run Keyword And Return Status  findOrders  ${EMPTY}  2019-!4-24  00:00:00  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}
    Should Not Be True  ${WS_INFO}

    ${WS_INFO}  Run Keyword And Return Status  findOrders  ${EMPTY}  2019-04-6@  00:00:00  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}
    Should Not Be True  ${WS_INFO}

    ${WS_INFO}  Run Keyword And Return Status  findOrders  ${EMPTY}  2019-04-24  &0:00:00  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}
    Should Not Be True  ${WS_INFO}

    ${WS_INFO}  Run Keyword And Return Status  findOrders  ${EMPTY}  2019-04-24  00:8#:00  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}
    Should Not Be True  ${WS_INFO}

    ${WS_INFO}  Run Keyword And Return Status  findOrders  ${EMPTY}  2019-04-24  00:00:9$  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}
    Should Not Be True  ${WS_INFO}

*** Keywords ***
Setup WS
    Get Into DB  TCH
    log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

Teardown WS
    Disconnect From Database
    Logout

Get Order Info
    ${query}  catenate
    ...     SELECT ccb_card_order_id AS orderId,
    ...     TO_CHAR(created,'%Y-%m-%dT%H:%M:%S') AS createdDate,
    ...     order_status AS orderStatus,
    ...     TRIM(status_msg) AS statusMsg,
    ...     order_qty AS orderQty,
    ...     ccb_order_type_id AS orderType,
    ...     policy AS policyNumber,
    ...     card_style AS cardStyle,
    ...     shipping_method_id AS shippingMethod,
    ...     rush_processing AS rushProcessing
    ...     FROM ccb_card_orders
    ...     WHERE carrier_id = 103866
    ...     AND   created = '2019-04-23 01:15'
    ${results}  Query To Dictionaries  ${query}
    [Return]  ${results}

Format Date to Dic
    [Arguments]  ${WS_INFO}  ${key}
    ${pos_date}  Get From Dictionary  ${WS_INFO}  ${key}
    ${pos_date}  Get Substring  ${pos_date}  0  -10
    [Return]  ${pos_date}

Remove Non Matching Values
    [Arguments]  ${WS_INFO}  ${DB_INFO}

    FOR  ${INFO}  IN  @{WS_INFO}
        Remove From Dictionary  ${INFO}  embossedName
        Remove From Dictionary  ${INFO}  shipToFirst
        Remove From Dictionary  ${INFO}  shipToLast
        Remove From Dictionary  ${INFO}  shipToAddress1
        Remove From Dictionary  ${INFO}  shipToAddress2
        Remove From Dictionary  ${INFO}  shipToCity
        Remove From Dictionary  ${INFO}  shipToState
        Remove From Dictionary  ${INFO}  shipToZip
        Remove From Dictionary  ${INFO}  shipToCountry
        ${createdDate}  Format Date to Dic  ${INFO}  createdDate
        Set To Dictionary  ${INFO}  createdDate=${createdDate}
    END

    FOR  ${db}  IN  @{DB_INFO}
        Run Keyword IF  '${db['statusmsg']}'=='None'  Remove From Dictionary  ${db}  statusmsg
        Run Keyword IF  '${db['rushprocessing']}'=='None'  Remove From Dictionary  ${db}  rushprocessing
    END