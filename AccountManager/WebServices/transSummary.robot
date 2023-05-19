*** Settings ***
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService

Force Tags  Web Services
Suite Setup  Setup WS

*** Test Cases ***

Get The Transaction Summary Information
    [Tags]  JIRA:BOT-1625  qTest:30809287  Regression  refactor
    [Documentation]  Summarizes fuel Transaction Summary Summary information for a customer for a time period, including the count and total amount.

    ${WS_INFO}  transSummary  2019-04-03  2019-04-03  01:00:00  22:00:00

    ${transTotal}  Format Trans Total  ${WS_INFO}  tranTotal
    Set To Dictionary  ${WS_INFO}  tranTotal=${transTotal}

#   THE WEBSERVICE RUNS IN GMT, SO IN ORDER TO REQUEST THE INFORMATION YOU HAVE TO GIVE AN HOUR EARLY
#   THAT'S WHY YOU NEED TO ADD +1 HOUR ON THE DB SQL

    ${DB_INFO}  Get Transaction Summary From DB

    ${same_dict}  Compare Dictionaries As Strings  ${WS_INFO}  ${DB_INFO[0]}
    Should Be True  ${same_dict}

Get The Transaction Summary Using Only Begin Date
    [Tags]  JIRA:BOT-1562  qTest:30809355  Regression
    ${status}  Run Keyword And Return Status  transSummary  2019-03-24  ${empty}  00:00:00  ${empty}
    Should Not Be True  ${status}

Get The Transaction Summary Using Only End Date
    [Tags]  JIRA:BOT-1562  qTest:30809380  Regression
    ${status}  Run Keyword And Return Status  transSummary  ${empty}  2019-03-24  ${empty}  00:00:00
    Should Not Be True  ${status}

Get The Transaction Summary Using Null Parameters
    [Tags]  JIRA:BOT-1562  qTest:30809388  Regression
    ${status}  Run Keyword And Return Status  transSummary  ${empty}  ${empty}  ${empty}  ${empty}
    Should Not Be True  ${status}

Get The Transaction Summary With a Typo On the Date
    [Tags]  JIRA:BOT-1562  qTest:30809397  Regression
    [Documentation]  Validate that's not possible to get Transaction Summarys Get Theing by when it has a typo.

        ${beginDate}  getDateTimeNow  %Y-%m-%d
        ${endDate}  getDateTimeNow  %Y-%m-%d

#   TYPO ON THE BEGIN DATE
    ${status}  Run Keyword And Return Status  transSummary  2019-03-2X  ${endDate}
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  transSummary  2019-?!-25  ${endDate}
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  transSummary  201@-03-25  ${endDate}
    Should Not Be True  ${status}

#   TYPO ON THE END DATE
    ${status}  Run Keyword And Return Status  transSummary  ${beginDate}  2019-03-2X
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  transSummary  ${beginDate}  2019-?!-25
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  transSummary  ${beginDate}  201@-03-25
    Should Not Be True  ${status}

Get The Transaction Summary With Extra Character On the Time
    [Tags]  JIRA:BOT-1562  qTest:30809450  Regression
    [Documentation]  Validate that's not possible to get Transaction Summary when Begin/End Time when it has a typo. 03 scenarios

        ${beginDate}  getDateTimeNow  %Y-%m-%d
        ${endDate}  getDateTimeNow  %Y-%m-%d  days=-1

#   EXTRA CHARACTER ON THE BEGIN TIME
    ${status}  Run Keyword And Return Status  transSummary  ${beginDate}  ${endDate}  000:59:59  00:00:00
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  transSummary  ${beginDate}  ${endDate}  00:599:00  00:00:00
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  transSummary  ${beginDate}  ${endDate}  00:59:599  00:00:00
    Should Not Be True  ${status}

#   EXTRA CHARACTER ON THE END TIME

    ${status}  Run Keyword And Return Status  transSummary  ${beginDate}  ${endDate}  00:00:00  233:59:59
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  transSummary  ${beginDate}  ${endDate}  00:00:00  23:599:59
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  transSummary  ${beginDate}  ${endDate}  00:00:00 23:59:599
    Should Not Be True  ${status}

Get The Transaction Summarys With Extra Character On the Date
    [Tags]  JIRA:BOT-1562  qTest:30809487  Regression
    [Documentation]  Validate that's not possible to get Transaction Summarys Get Theing using a wrong date format.

        ${beginDate}  getDateTimeNow  %Y-%m-%d
        ${endDate}  getDateTimeNow  %Y-%m-%d  days=-1

#   EXTRA CHARACTER ON THE BEGIN DATE
    ${status}  Run Keyword And Return Status  transSummary  20190-03-25  ${endDate}
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  transSummary  2019-003-25  ${endDate}
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  transSummary  2019-03-250  ${endDate}
    Should Not Be True  ${status}

#   EXTRA CHARACTER ON THE END DATE
    ${status}  Run Keyword And Return Status  transSummary  ${beginDate}  20190-03-25
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  transSummary  ${beginDate}  2019-003-25
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  transSummary  ${beginDate}  2019-03-250
    Should Not Be True  ${status}

Get The Transaction Summary With Invalid Date
    [Tags]  JIRA:BOT-1562  qTest:30809509  Regression
    [Documentation]  Validate that's not possible to get Transaction Summary using Invalid Begin/End Date

    ${BeginDate}  getDateTimeNow  %Y-%m-%d
    ${EndDate}  getDateTimeNow  %Y-%m-%d

#   INVALID BEGIN DATE
    ${status}  Run Keyword And Return Status  transSummary  2019-03-65  ${EndDate}
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  transSummary  2019-15-26  ${EndDate}
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  transSummary  0000-03-10  ${EndDate}
    Should Not Be True  ${status}

#INVALID END DATE
    ${status}  Run Keyword And Return Status  transSummary  ${BeginDate}  2019-03-65
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  transSummary  ${BeginDate}  2019-15-26
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  transSummary  ${BeginDate}  00193-03-10
    Should Not Be True  ${status}

Get The Transaction Summary With Incomplete Dates
    [Tags]  JIRA:BOT-1562  qTest:30809681  Regression
    [Documentation]  Validate that's not possible to get Transaction Summary using incomplete date/time format

#   INCOMPLETE BEGIN DATE
    ${status}  Run Keyword And Return Status  transSummary  201-03-25  2019-03-10
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  transSummary  2019-3-25  2019-03-10
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  transSummary  2019-03-5  2019-03-10
    Should Not Be True  ${status}

#   INCOMPLETE END DATE
    ${status}  Run Keyword And Return Status  transSummary  2019-03-10  201-03-25
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  transSummary  2019-03-10  2019-3-10
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  transSummary  2019-03-10  2019-03-0
    Should Not Be True  ${status}

Get The Transaction Summary With Incomplete Times
    [Tags]  JIRA:BOT-1562  qTest:30809682  Regression
    [Documentation]  Validate that's not possible to get Transaction Summary using incomplete date format

    ${beginDate}  getDateTimeNow  %Y-%m-%d
    ${endDate}  getDateTimeNow  %Y-%m-%d

#   INCOMPLETE BEGIN TIME
    ${status}  Run Keyword And Return Status  transSummary  ${beginDate}  ${endDate}  2:59:59  00:00:00
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  transSummary  ${beginDate}  ${endDate}  23:5:59  00:00:00
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  transSummary  ${beginDate}  ${endDate}  23:59:4  00:00:00
    Should Not Be True  ${status}

#   INCOMPLETE END TIME
    ${status}  Run Keyword And Return Status  transSummary  ${beginDate}  ${endDate}  00:00:00  2:59:59
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  transSummary  ${beginDate}  ${endDate}  00:00:00  23:5:59
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  transSummary  ${beginDate}  ${endDate}  00:00:00  23:59:0
    Should Not Be True  ${status}

*** Keywords ***
Setup WS
    Get Into DB  TCH
    log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

Tear Me Down
    Disconnect From Database
    Logout

Get Transaction Summary From DB
    ${query}  catenate
    ...     SELECT DISTINCT count(trans_id) AS tranCount, SUM(funded_total) AS tranTotal
    ...     FROM Transaction
    ...     WHERE carrier_id = 103866
    ...     AND   trans_date BETWEEN '2019-04-03 00:00' AND '2019-04-03 23:59'
    ${results}  Query To Dictionaries  ${query}
    [Return]  ${results}

Format Trans Total
    [Arguments]  ${ws_info}  ${key}
    ${pos_date}  Get From Dictionary  ${ws_info}  ${key}
    ${pos_date}  Get Substring  ${pos_date}  0  -10
    [Return]  ${pos_date}