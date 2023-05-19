*** Settings ***
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary

Force Tags  Web Services

Suite Setup  Setup WS

*** Variables ***
${Acc_Num}  44778833
${CardNu}  7083051014152600035
${CardNu_pin}  4321

*** Test Cases ***
Get The SmartPay Transfer History Information
    [Tags]  JIRA:BOT-1607  qTest:30889948  Regression  run
    [Documentation]  Make sure you can retrieve SmartFunds transfers for a card

    ${WS_INFO}  smartPayTransferHistory  7083051014152600035  5

    ${ppd_details}  Set Variable  ${EMPTY}
    FOR  ${smart_pay}  IN  @{WS_INFO}
        tch logging  ${smart_pay}
        ${create_date}  Tratar Data  ${smart_pay['createDate']}
        ${sent_date}  Tratar Data  ${smart_pay['sentDate']}
        Set To Dictionary  ${smart_pay}  createDate=${create_date}
        Set To Dictionary  ${smart_pay}  sentDate=${sent_date}
        ${ppd_details}  Catenate  ${ppd_details}${smart_pay['ppdDetailId']},
    END

    ${ppd_details}  Get Substring  ${ppd_details}  0  -1

    ${DB_INFO}  Get SmartPay Transfer History Information  ${ppd_details}

    ${status}  Compare List Dictionaries As Strings  ${DB_INFO}  ${WS_INFO}
    Should Be True  ${status}


Get The SmartPay Transfer History Information With a Typo On The Card Number/Count Parameter
    [Tags]  JIRA:BOT-1607  qTest:30889968  Regression
    [Documentation]  Make sure you can't retrieve SmartFunds transfers for a card when there's a typo on one of the parameters

    ${status}  Run Keyword And Return Status  smartPayTransferHistory  7083051014ADF152600035  1
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  smartPayTransferHistory  7083051014152600035  AF1
    Should Not Be True  ${status}

Get The SmartPay Transfer History Information With a SPACE On The Card Number/Count Parameter
    [Tags]  JIRA:BOT-1607  qTest:30889989  Regression
    [Documentation]  Make sure you can't retrieve SmartFunds transfers for a card when there's a space on one of the parameters

    ${status}  Run Keyword And Return Status  smartPayTransferHistory  ${SPACE}  1
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  smartPayTransferHistory  7083051014152600035  ${SPACE}
    Should Not Be True  ${status}

Get The SmartPay Transfer History Information With an EMPTY Card Number/Count Parameter
    [Tags]  JIRA:BOT-1607  qTest:30890002  Regression
    [Documentation]  Make sure you can't retrieve SmartFunds transfers for a card when there's an empty parameter

    ${status}  Run Keyword And Return Status  smartPayTransferHistory  ${EMPTY}  1
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  smartPayTransferHistory  7083051014152600035  ${EMPTY}
    Should Not Be True  ${status}

Get The SmartPay Transfer History Information With a Special Character Card Number/Count Parameter
    [Tags]  JIRA:BOT-1607  qTest:30890086  Regression
    [Documentation]  Make sure you can't retrieve SmartFunds transfers for a card when there's an empty parameter

    ${status}  Run Keyword And Return Status  smartPayTransferHistory  7083051!@#14152600035  1
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  smartPayTransferHistory  7083051014152600035  1!@
    Should Not Be True  ${status}


*** Keywords ***
Setup WS
    Get Into DB  TCH
    log into card management web services  7083051014152600035  4321

Set Date
    [Arguments]  ${WS_INFO}
    tch logging  eu entrei aqui quararaqua
    ${formated_date}  Format Date To Dict  ${WS_INFO}  sentDate
    Set To Dictionary  ${WS_INFO}  sentDate=${sentDate}

Format Date to Dict
    [Arguments]  ${WS_INFO}  ${key}
    ${create_date}  Get From Dictionary  ${WS_INFO}  ${key}
    ${create_date}  Get Substring  ${create_date}  0  -10
    [Return]  ${create_date}

Get SmartPay Transfer History Information
    [Arguments]  ${ppd_detail_ids}

    ${query}  catenate
    ...     SELECT ad.ppd_detail_id AS ppdDetailId,
    ...            ad.status AS status,
    ...            TO_CHAR(ad.create_date, '%Y-%m-%d') AS createDate,
    ...            TO_CHAR(ad.sent_date, '%Y-%m-%d') AS sentDate,
    ...            TO_CHAR(ad.amount,'&.&') AS amount,
    ...            ad.trace_number AS traceNumber,
    ...            TRIM(ah.description) AS description
    ...     FROM   ach_ppd_detail ad,
    ...            ach_ppd_header ah
    ...     WHERE ad.ppd_header_id=ah.ppd_header_id
    ...     AND   ad.ppd_detail_id IN (${ppd_detail_ids})
    ...     ORDER BY  ad.ppd_detail_id DESC
    tch logging  ${query}
    ${results}  Query To Dictionaries  ${query}
    [Return]  ${results}

Tratar Data
    [Arguments]  ${data}
    ${create_date}  Run Keyword If  '${data}'!='None'
    ...  Get Substring  ${data}  0  -19
    [Return]  ${create_date}
