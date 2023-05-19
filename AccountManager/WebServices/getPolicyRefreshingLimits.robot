*** Settings ***
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.setup.PySetup

Force Tags  Web Services  refactor
Suite Setup  Setup WS
Suite Teardown  Tear Me Down

*** Test Cases ***
Get Policy Refreshing Limits With a Valid Policy Number
    [Tags]  JIRA:BOT-1613  qTest:30782691  Regression  JIRA:BOT-2041
    [Documentation]  Make sure you can fetch the refreshing limits information for a specific policy.

    Set Test Variable  ${policy}  1

    ${WS_INFO}  getPolicyRefreshingLimits  ${policy}
    ${DB_INFO}  Policy Refreshing Limits From DB

    ${same_dict}  Compare Dictionaries As Strings  ${DB_INFO[0]}  ${WS_INFO}
    Should Be True  ${same_dict}

Get Policy Refreshing Limits With a Typo on A Policy Number
    [Tags]  JIRA:BOT-1613  qTest:37192398  Regression  JIRA:FRNT-55
    [Documentation]  Make sure you can't fetch informatiom from getPolicyRefreshingLimits with a typo on a policy

    ${status}  Run Keyword And Return Status  getPolicyRefreshingLimits  9999
    Should Not Be True  ${status}
    should contain  ${ws_error}  Invalid policy number

Get Policy Refreshing Limits With a Special Character on a Policy Number
    [Tags]  JIRA:BOT-1613  qTest:30782744  Regression
    [Documentation]  Make sure you can't fetch information from getPolicyRefreshingLimits with a special character on a policy

    ${status}  Run Keyword And Return Status  getPolicyRefreshingLimits  $@
    Should Not Be True  ${status}

Get Policy Refreshing Limits With Empty Value On a Policy Number
    [Tags]  JIRA:BOT-1613  qTest:30782783  Regression
    [Documentation]  Make sure you can't fetch information from getPolicyRefreshingLimits with an empty policy number;

    ${status}  Run Keyword And Return Status  getPolicyRefreshingLimits  ${EMPTY}
    Should Not Be True  ${status}

Get Policy Refreshing Limits With A SPACE Value On a Policy Number
    [Tags]  JIRA:BOT-1613  qTest:30782819  Regression
    [Documentation]  Make sure you can't fetch information from getPolicyRefreshingLimits with an empty policy number;

    ${status}  Run Keyword And Return Status  getPolicyRefreshingLimits  ${SPACE}
    Should Not Be True  ${status}

*** Keywords ***
Setup WS
    Ensure Member is Not Suspended  ${validCard.carrier.id}
    Get Into DB  TCH
    Start Setup Policy  ${validCard.carrier.id}  2
    Setup Policy Contract  velocity_enabled=Y
    Log Into Card Management Web Services  ${validCard.carrier.id}  ${validCard.carrier.password}

Tear Me Down
    Disconnect From Database

Policy Refreshing Limits From DB

    ${query}  catenate
    ...     SELECT day_cnt_limit AS dayCntLimit,
    ...            day_amt_limit AS dayAmtLimit,
    ...            week_cnt_limit AS weekCntLimit,
    ...            week_amt_limit AS weekAmtLimit,
    ...            mon_cnt_limit AS monCntLimit,
    ...            mon_amt_limit AS monAmtLimit
    ...     FROM def_card
    ...     WHERE id = ${validCard.carrier.id}
    ...     AND ipolicy=${policy}
    ${results}  Query To Dictionaries  ${query}
    [Return]  ${results}