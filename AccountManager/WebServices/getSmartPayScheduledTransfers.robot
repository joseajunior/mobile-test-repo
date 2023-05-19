*** Settings ***
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary

Force Tags  Web Services

Suite Setup  Setup WS
Suite Teardown  Logout WS

*** Test Cases ***

Get SmartPay Scheduled Transfers Information Using An Valid Card
    [Tags]  JIRA:BOT-1621  qTest:30896758  Regression  run  refactor
    [Documentation]  Make sure you can fetch informatiom from the getSmartPayScheduledTransfers ws call using a valid card number

    ${WS_INFO}  getSmartPayScheduledTransfers  7083050910386616146
    tch logging  WS:${WS_INFO}

    ${effDate}  Format Date to Dic  ${WS_INFO}  effDate
    Set To Dictionary  ${WS_INFO}  effDate=${effDate}

    ${expDate}  Pop From Dictionary  ${WS_INFO}  expDate
    ${expDate}  Set Variable IF  '${expDate}'=='NULL'  None
    ${expDate}  Set Variable IF  '${expDate}'!='NULL'  ${expDate}  Format Date to Dic  ${WS_INFO}  sentDate
    Set To Dictionary  ${WS_INFO}  expDate=${expDate}
    tch logging  expDate${expDate}

    ${DB_INFO}  Get SmartPay Scheduled Transfer DB Info

    ${same_dict}  Compare Dictionaries As Strings  ${DB_INFO[0]}  ${WS_INFO}
    Should Be True  ${same_dict}


Get SmartPay Scheduled Transfers Information Using A Card Number With A Typo
    [Tags]  JIRA:BOT-1621  qTest:30897023  Regression
    [Documentation]  Make sure you can't fetch information from the getSmartPayScheduledTransfers ws call when there's a typo on the card number.

    ${status}  Run Keyword And Return Status  getSmartPayScheduledTransfers  708305
    Should Not Be True  ${status}

Get SmartPay Scheduled Transfers Information Using An Invalid Card
    [Tags]  JIRA:BOT-1621  qTest:30897003  Regression  refactor
    [Documentation]  Make sure you can't fetch information from the getSmartPayScheduledTransfers ws call using an invalid card.

    ${status}  Run Keyword And Return Status  getSmartPayScheduledTransfers  708305101ABD!@$#@4152600035
    Should Not Be True  ${status}

Get SmartPay Scheduled Transfers Information Using An Empty Card Number
    [Tags]  JIRA:BOT-1621  qTest:30897170  Regression  refactor
    [Documentation]  Make sure you can't fetch information from the getSmartPayScheduledTransfers ws call leaving the card number parameter empty

    ${status}  Run Keyword And Return Status  getSmartPayScheduledTransfers  ${EMPTY}
    Should Not Be True  ${status}

Get SmartPay Scheduled Transfers Information Using A Space on the Card Number
    [Tags]  JIRA:BOT-1621  qTest:30897207  Regression  refactor
    [Documentation]  Make sure you can't fetch information from the getSmartPayScheduledTransfers ws call when there's a space on the card number

    ${status}  Run Keyword And Return Status  getSmartPayScheduledTransfers  708305101${SPACE}4152600035
    Should Not Be True  ${status}


*** Keywords ***
Setup WS
    Get Into DB  TCH
    log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}


Logout WS
    Logout

Get SmartPay Scheduled Transfer DB Info
    ${query}  catenate
    ...     SELECT aas.aas_id AS scheduledTransferId,
    ...     aas.ppd_header_id AS transferAccountId,
    ...     TRIM(DECODE(aas.schedule_type, 'DD', 'DAILY', 'MD', 'DAY OF MONTH', 'TL', 'TRANSFER ON LOAD', 'WD', 'DAY OF WEEK')) AS scheduleType,
    ...     aas.schedule_value AS scheduleValue,
    ...     aas.transfer_type AS transferType,
    ...     TO_CHAR(aas.transfer_value, '&.&') AS transferValue,
    ...     TRIM(DECODE(aas.email_notification, 'Y', 'true', 'N', 'false')) AS emailNotification,
    ...     TO_CHAR(aas.eff_date, '%Y-%m-%dT%H:%M:%S') AS effDate,
    ...     TO_CHAR(aas.exp_date, '%Y-%m-%dT%H:%M:%S') AS expDate
    ...     FROM ach_acct_schedule aas,
    ...     ach_ppd_card_xref apcx
    ...     WHERE apcx.ppd_header_id = aas.ppd_header_id
    ...     AND   apcx.card_num = '7083051014152600035'
    ...     ORDER BY aas_id DESC limit 1
    ${results}  Query To Dictionaries  ${query}
    [Return]  ${results}

Format Date to Dic
    [Arguments]  ${Transactions}  ${key}
    ${pos_date}  Get From Dictionary  ${Transactions}  ${key}
    ${pos_date}  Get Substring  ${pos_date}  0  -10
    [Return]  ${pos_date}