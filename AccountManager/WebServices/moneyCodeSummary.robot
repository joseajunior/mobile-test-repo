*** Settings ***
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary

Force Tags  Web Services

Suite Setup  Setup WS
Suite Teardown  Teardown WS

*** Test Cases ***

Search Money Code Summary With Valid Date Ranges
    [Tags]  JIRA:BOT-1886  qTest:31798165  Regression
    [Documentation]  Input a valid data parameter and expect a valid response.

    Set Test Variable  ${beginDate}  2019-04-28
    Set Test Variable  ${endDate}  2019-03-28
    Set Test Variable  ${beginTime}  01:00:00
    Set Test Variable  ${endTime}  00:39:00

    ${status}  Run Keyword And Return Status  moneyCodeSummary  ${beginDate}  ${endDate}  ${beginTime}  ${endTime}
    Should Be True  ${status}

Search Money Code Summary Using Only Begin Date
    [Tags]  JIRA:BOT-1886  qTest:31798166  Regression
    [Documentation]  Insert only beginDate and expect an error.
    ${status}  Run Keyword And Return Status  moneyCodeSummary  2019-03-24  ${empty}  00:00:00  ${empty}
    Should Not Be True  ${status}

Search Money Code Summary Using Only End Date
    [Tags]  JIRA:BOT-1886  qTest:31798167  Regression
    [Documentation]  Insert only endDate and expect an error.
    ${status}  Run Keyword And Return Status  moneyCodeSummary  ${empty}  2019-03-24  ${empty}  00:00:00
    Should Not Be True  ${status}

Search Money Code Summary Using Null Parameters
    [Tags]  JIRA:BOT-1886  qTest:31798168  Regression
    [Documentation]  Insert null parameters and expect an error.
    ${status}  Run Keyword And Return Status  moneyCodeSummary  ${empty}  ${empty}  ${empty}  ${empty}
    Should Not Be True  ${status}

Search Money Code Summary Using Date on Future
    [Tags]  JIRA:BOT-1886  qTest:31798169  Regression  BUGGED:Is accepting a future date.
    [Documentation]  Insert future date as parameters and expect an error.
    ${beginDate}  GetDateTimeNow  %Y-%m-%d  days=1
    ${endDate}  GetDateTimeNow  %Y-%m-%d  days=2

    ${status}  Run Keyword And Return Status  moneyCodeSummary  ${beginDate}  ${endDate}
    Should Not Be True  ${status}

Search Money Code Summary With a Typo On the Date
    [Tags]  JIRA:BOT-1886  qTest:31798170  Regression
    [Documentation]  Make sure you can't search for transaction if there's a typo on a date.
    ${beginDate}  getDateTimeNow  %Y-%m-%d
    ${endDate}  getDateTimeNow  %Y-%m-%d

#   TYPO ON THE BEGIN DATE
    ${status}  Run Keyword And Return Status  moneyCodeSummary  2019-03-2X  ${endDate}
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  moneyCodeSummary  2019-?!-25  ${endDate}
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  moneyCodeSummary  201@-03-25  ${endDate}
    Should Not Be True  ${status}

#   TYPO ON THE END DATE
    ${status}  Run Keyword And Return Status  moneyCodeSummary  ${beginDate}  2019-03-2X
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  moneyCodeSummary  ${beginDate}  2019-?!-25
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  moneyCodeSummary  ${beginDate}  201@-03-25
    Should Not Be True  ${status}

Search Money Code Summary With Extra Character On the Time
    [Tags]  JIRA:BOT-1886  qTest:31798171  Regression
    [Documentation]  Make sure you can't search for transactions with extra characters on the time.
    ${beginDate}  getDateTimeNow  %Y-%m-%d
    ${endDate}  getDateTimeNow  %Y-%m-%d  days=-1

#   EXTRA CHARACTER ON THE BEGIN TIME
    ${status}  Run Keyword And Return Status  moneyCodeSummary  ${beginDate}  ${endDate}  000:59:59  00:00:00
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  moneyCodeSummary  ${beginDate}  ${endDate}  00:599:00  00:00:00
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  moneyCodeSummary  ${beginDate}  ${endDate}  00:59:599  00:00:00
    Should Not Be True  ${status}

#   EXTRA CHARACTER ON THE END TIME

    ${status}  Run Keyword And Return Status  moneyCodeSummary  ${beginDate}  ${endDate}  00:00:00  233:59:59
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  moneyCodeSummary  ${beginDate}  ${endDate}  00:00:00  23:599:59
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  moneyCodeSummary  ${beginDate}  ${endDate}  00:00:00 23:59:599
    Should Not Be True  ${status}

Search Money Code Summary With Extra Character On the Date
    [Tags]  JIRA:BOT-1886  qTest:31798172  Regression
    [Documentation]  Make sure you can't search for transactions with extra characters on the date.
    ${beginDate}  getDateTimeNow  %Y-%m-%d
    ${endDate}  getDateTimeNow  %Y-%m-%d  days=-1

#   EXTRA CHARACTER ON THE BEGIN DATE
    ${status}  Run Keyword And Return Status  moneyCodeSummary  20190-03-25  ${endDate}
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  moneyCodeSummary  2019-003-25  ${endDate}
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  moneyCodeSummary  2019-03-250  ${endDate}
    Should Not Be True  ${status}

#   EXTRA CHARACTER ON THE END DATE
    ${status}  Run Keyword And Return Status  moneyCodeSummary  ${beginDate}  20190-03-25
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  moneyCodeSummary  ${beginDate}  2019-003-25
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  moneyCodeSummary  ${beginDate}  2019-03-250
    Should Not Be True  ${status}

Search Money Code Summary With Invalid Date
    [Tags]  JIRA:BOT-1886  qTest:31798173  Regression
    [Documentation]  Make sure you can't fetch results from getTransactions ws call using invalid dates.
    ${BeginDate}  getDateTimeNow  %Y-%m-%d
    ${EndDate}  getDateTimeNow  %Y-%m-%d

#   INVALID BEGIN DATE
    ${status}  Run Keyword And Return Status  moneyCodeSummary  2019-03-65  ${EndDate}
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  moneyCodeSummary  2019-15-26  ${EndDate}
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  moneyCodeSummary  0000-03-10  ${EndDate}
    Should Not Be True  ${status}

#INVALID END DATE
    ${status}  Run Keyword And Return Status  moneyCodeSummary  ${BeginDate}  2019-03-65
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  moneyCodeSummary  ${BeginDate}  2019-15-26
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  moneyCodeSummary  ${BeginDate}  00193-03-10
    Should Not Be True  ${status}

Search Money Code Summary With Incomplete Dates
    [Tags]  JIRA:BOT-1886  qTest:31798174  Regression
    [Documentation]  Make sure you can't fetch results from getTransactions ws call using incomplete dates.

#   INCOMPLETE BEGIN DATE
    ${status}  Run Keyword And Return Status  moneyCodeSummary  201-03-25  2019-03-10
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  moneyCodeSummary  2019-3-25  2019-03-10
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  moneyCodeSummary  2019-03-5  2019-03-10
    Should Not Be True  ${status}

#   INCOMPLETE END DATE
    ${status}  Run Keyword And Return Status  moneyCodeSummary  2019-03-10  201-03-25
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  moneyCodeSummary  2019-03-10  2019-3-10
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  moneyCodeSummary  2019-03-10  2019-03-0
    Should Not Be True  ${status}

Search Money Code Summary With Incomplete Times
    [Tags]  JIRA:BOT-1886  qTest:31798175  Regression
    [Documentation]  Make sure you can't fetch results from getTransactions ws call using incomplete timestamps.
    ${beginDate}  getDateTimeNow  %Y-%m-%d
    ${endDate}  getDateTimeNow  %Y-%m-%d

#   INCOMPLETE BEGIN TIME
    ${status}  Run Keyword And Return Status  moneyCodeSummary  ${beginDate}  ${endDate}  2:59:59  00:00:00
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  moneyCodeSummary  ${beginDate}  ${endDate}  23:5:59  00:00:00
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  moneyCodeSummary  ${beginDate}  ${endDate}  23:59:4  00:00:00
    Should Not Be True  ${status}

#   INCOMPLETE END TIME
    ${status}  Run Keyword And Return Status  moneyCodeSummary  ${beginDate}  ${endDate}  00:00:00  2:59:59
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  moneyCodeSummary  ${beginDate}  ${endDate}  00:00:00  23:5:59
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  moneyCodeSummary  ${beginDate}  ${endDate}  00:00:00  23:59:0
    Should Not Be True  ${status}

*** Keywords ***
Setup WS
    Get Into DB  TCH

    log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

Teardown WS
    Disconnect From Database
    Logout