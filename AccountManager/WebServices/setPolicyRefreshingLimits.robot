*** Settings ***
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary

Force Tags  Web Services
Suite Setup  Setup WS
Suite Teardown  Teardown WS

*** Variables ***
${policy}  ${validCard.policy.id}

*** Test Cases ***
Valid Parameters For All Fields
    [Documentation]  Insert all parameters and expect a positive response.
    [Tags]  JIRA:BOT-1590  qTest:31050796  Regression  refactor
    ${day_cnt_limit}  Generate Random String  2  [NUMBERS]
    ${day_amt_limit}  Generate Random String  2  [NUMBERS]
    ${week_cnt_limit}  Generate Random String  2  [NUMBERS]
    ${week_amt_limit}  Generate Random String  2  [NUMBERS]
    ${mon_cnt_limit}  Generate Random String  2  [NUMBERS]
    ${mon_amt_limit}  Generate Random String  2  [NUMBERS]

    setPolicyRefreshingLimits  ${policy}  ${day_cnt_limit}  ${day_amt_limit}  ${week_cnt_limit}  ${week_amt_limit}  ${mon_cnt_limit}  ${mon_amt_limit}
    Check Policy Refreshing Limits for All Parameters  ${validCard.carrier.id}  ${policy}  ${day_cnt_limit}  ${day_amt_limit}  ${week_cnt_limit}  ${week_amt_limit}  ${mon_cnt_limit}  ${mon_amt_limit}

Invalid Policy Number
    [Documentation]  Insert Invalid Policy Number parameter and expect an error.
    [Tags]  JIRA:BOT-1590  qTest:31050797  Regression
    ${policy}  Set Variable  9999999
    Run Keyword And Expect Error  *  setPolicyRefreshingLimits  ${policy}

Invalid Day Count Limit
    [Documentation]  Insert Invalid Day Count Limit parameter and expect an error.
    [Tags]  JIRA:BOT-1590  qTest:31050798  Regression
    Run Keyword And Expect Error  *  setPolicyRefreshingLimits  ${policy}  dayCntLimit=1nv@l1d

Invalid Day Amount Limit
    [Documentation]  Insert Invalid Day Amount Limit parameter and expect an error.
    [Tags]  JIRA:BOT-1590  qTest:31050799  Regression
    Run Keyword And Expect Error  *  setPolicyRefreshingLimits  ${policy}  dayAmtLimit=1nv@l1d

Invalid Week Count Limit
    [Documentation]  Insert Invalid Week Count Limit parameter and expect an error.
    [Tags]  JIRA:BOT-1590  qTest:31050800  Regression
    Run Keyword And Expect Error  *  setPolicyRefreshingLimits  ${policy}  weekCntLimit=1nv@l1d

Invalid Week Amount Limit
    [Documentation]  Insert Invalid Week Amount Limit parameter and expect an error.
    [Tags]  JIRA:BOT-1590  qTest:31050801  Regression
    Run Keyword And Expect Error  *  setPolicyRefreshingLimits  ${policy}  weekAmtLimit=1nv@l1d

Invalid Month Count Limit
    [Documentation]  Insert Invalid Month Count Limit parameter and expect an error.
    [Tags]  JIRA:BOT-1590  qTest:31050802  Regression
    Run Keyword And Expect Error  *  setPolicyRefreshingLimits  ${policy}  monCntLimit=1nv@l1d

Invalid Month Amount Limit
    [Documentation]  Insert Invalid Month Amount Limit parameter and expect an error.
    [Tags]  JIRA:BOT-1590  qTest:31050803  Regression
    Run Keyword And Expect Error  *  setPolicyRefreshingLimits  ${policy}  monAmtLimit=1nv@l1d

Typo Policy Number
    [Documentation]  Insert Typo Policy Number parameter and expect an error.
    [Tags]  JIRA:BOT-1590  qTest:31050804  Regression
    Run Keyword And Expect Error  *  setPolicyRefreshingLimits  ${policy}f

Typo Day Count Limit
    [Documentation]  Insert Typo Day Count Limit parameter and expect an error.
    [Tags]  JIRA:BOT-1590  qTest:31050805  Regression
    Run Keyword And Expect Error  *  setPolicyRefreshingLimits  ${policy}  dayCntLimit=1a

Typo Day Amount Limit
    [Documentation]  Insert Typo Day Amount Limit parameter and expect an error.
    [Tags]  JIRA:BOT-1590  qTest:31050806  Regression
    Run Keyword And Expect Error  *  setPolicyRefreshingLimits  ${policy}  dayAmtLimit=1a

Typo Week Count Limit
    [Documentation]  Insert Typo Week Count Limit parameter and expect an error.
    [Tags]  JIRA:BOT-1590  qTest:31050807  Regression
    Run Keyword And Expect Error  *  setPolicyRefreshingLimits  ${policy}  weekCntLimit=1a

Typo Week Amount Limit
    [Documentation]  Insert Typo Week Amount Limit parameter and expect an error.
    [Tags]  JIRA:BOT-1590  qTest:31050808  Regression
    Run Keyword And Expect Error  *  setPolicyRefreshingLimits  ${policy}  weekAmtLimit=1a

Typo Month Count Limit
    [Documentation]  Insert Typo Month Count Limit parameter and expect an error.
    [Tags]  JIRA:BOT-1590  qTest:31050809  Regression
    Run Keyword And Expect Error  *  setPolicyRefreshingLimits  ${policy}  monCntLimit=1a

Typo Month Amount Limit
    [Documentation]  Insert Typo Month Amount Limit parameter and expect an error.
    [Tags]  JIRA:BOT-1590  qTest:31050810  Regression
    Run Keyword And Expect Error  *  setPolicyRefreshingLimits  ${policy}  monAmtLimit=1a

Empty Policy Number
    [Documentation]  Insert Empty Policy Number parameter and expect an error.
    [Tags]  JIRA:BOT-1590  qTest:31050811  Regression
    Run Keyword And Expect Error  *  setPolicyRefreshingLimits  ${empty}

*** Keywords ***
Setup WS
    Get Into DB  TCH
    log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

Teardown WS
    Disconnect From Database
    Logout

Check Policy Refreshing Limits for All Parameters
    [Arguments]  ${carrier_id}  ${policy}  ${day_cnt_limit}  ${day_amt_limit}  ${week_cnt_limit}  ${week_amt_limit}  ${mon_cnt_limit}  ${mon_amt_limit}
    ${query}  Catenate  SELECT * FROM def_card
    ...     WHERE id='${carrier_id}'
    ...     AND ipolicy='${policy}'
    ...     AND day_cnt_limit='${day_cnt_limit}'
    ...     AND day_amt_limit='${day_amt_limit}'
    ...     AND week_cnt_limit='${week_cnt_limit}'
    ...     AND week_amt_limit='${week_amt_limit}'
    ...     AND mon_cnt_limit='${mon_cnt_limit}'
    ...     AND mon_amt_limit='${mon_amt_limit}'
    Row Count Is Equal To X  ${query}  1