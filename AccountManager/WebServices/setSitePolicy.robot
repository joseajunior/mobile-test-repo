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
${site_policy}  501
${policy}  ${validCard.policy.id}

*** Test Cases ***

Valid Parameters For All Fields Adding Policy
    [Documentation]  Insert all parameters with ADD option and expect a positive response.
    [Tags]  JIRA:BOT-1633  qTest:30997984  Regression  refactor
    ${ws}  setSitePolicy  ${site_policy}  ADD  ${policy}
    ${db}  Get Policies That Belongs to a Site Policy  ${userName}  ${site_policy}
    Compare Dictionaries as Strings  ${ws}  ${db}

Valid Parameters For All Fields Removing Policy
    [Documentation]  Insert all parameters with REMOVE option and expect a positive response.
    [Tags]  JIRA:BOT-1633  qTest:30997985  Regression  refactor
    ${ws}  setSitePolicy  ${site_policy}  REMOVE  ${policy}
    ${db}  Get Policies That Belongs to a Site Policy  ${userName}  ${site_policy}
    Compare Dictionaries as Strings  ${ws}  ${db}

Valid Parameters For All Fields Adding 2 Policies
    [Documentation]  Insert all parameters using 2 policies and ADD option and expect a positive response.
    [Tags]  JIRA:BOT-1633  qTest:30997986  Regression  refactor
    ${ws}  setSitePolicy  ${site_policy}  ADD  ${policy}  46
    ${db}  Get Policies That Belongs to a Site Policy  ${userName}  ${site_policy}
    Compare Dictionaries as Strings  ${ws}  ${db}

Valid Parameters For All Fields Removing 2 Policies
    [Documentation]  Insert all parameters using 2 policies and REMOVE option and expect a positive response.
    [Tags]  JIRA:BOT-1633  qTest:30997987  Regression  refactor
    ${ws}  setSitePolicy  ${site_policy}  ADD  ${policy}  46
    ${db}  Get Policies That Belongs to a Site Policy  ${userName}  ${site_policy}
    Compare Dictionaries as Strings  ${ws}  ${db}

Invalid Site Policy
    [Documentation]  Insert invalid Site Policy parameter and expect an error.
    [Tags]  Depricated  Regression  JIRA:FRNT-55  refactor
    ${status}  run keyword and return status  setSitePolicy  9999  ADD  ${policy}
    should not be true  ${status}  Set Site Policy Didn't Fail despite Using an Invalid Site Policy
    should contain  ${ws_error}  Invalid policy number

Typo Site Policy
    [Documentation]  Insert Typo Site Policy parameter and expect an error.
    [Tags]  JIRA:BOT-1633  qTest:30997992  Regression
    Run Keyword And Expect Error  *  setSitePolicy  ${site_policy}f  ADD  ${policy}

Empty Site Policy
    [Documentation]  Insert an Empty Site Policy parameter and expect an error.
    [Tags]  JIRA:BOT-1633  qTest:30997993  Regression
    Run Keyword And Expect Error  *  setSitePolicy  ${empty}  ADD  ${policy}

Invalid Operation
    [Documentation]  Insert Invalid Operation parameter and expect an error.
    [Tags]  JIRA:BOT-1633  qTest:30997994  Regression
    ${ws}  setSitePolicy  ${site_policy}  1nv@l1d  ${policy}
    ${db}  Get Policies That Belongs to a Site Policy  ${userName}  ${site_policy}

    Should Not Be Equal  ${ws}  ${db}

Typo Operation
    [Documentation]  Insert Typo Operation parameter and expect an error.
    [Tags]  JIRA:BOT-1633  qTest:30997995  Regression
    ${ws}  setSitePolicy  ${site_policy}  ADfDf  ${policy}
    ${db}  Get Policies That Belongs to a Site Policy  ${userName}  ${site_policy}
    Should Not Be Equal  ${ws}  ${db}

Empty Operation
    [Documentation]  Insert Empty Operation parameter and expect an error.
    [Tags]  JIRA:BOT-1633  qTest:30997996  Regression
    ${ws}  setSitePolicy  ${site_policy}  ${EMPTY}  ${policy}
    ${db}  Get Policies That Belongs to a Site Policy  ${userName}  ${site_policy}
    Should Not Be Equal  ${ws}  ${db}

Invalid Policy Add
    [Documentation]  Insert invalid Policy parameter and expect an error.
    [Tags]  qTest:37381871  Regression  JIRA:FRNT-55
    ${status}  ${ws_error}  Run Keyword And Ignore Error  setSitePolicy  ${site_policy}  ADD  9999
    Should Be Equal As Strings    FAIL    ${status.upper()}  Set Site Policy Didn't Fail despite Using an Invalid Policy
    should contain  ${ws_error}  Invalid policy number

Invalid Policy Remove
    [Documentation]  Insert invalid Policy parameter and expect an error.
    [Tags]  qTest:37382136  Regression  JIRA:FRNT-55
    ${status}  ${ws_error}  Run Keyword And Ignore Error  setSitePolicy  ${site_policy}  REMOVE  9999
    Should Be Equal As Strings    FAIL    ${status.upper()}  Set Site Policy Didn't Fail despite Using an Invalid Policy
    should contain  ${ws_error}  Invalid policy number

Typo Policy
    [Documentation]  Insert Typo Policy parameter and expect an error.
    [Tags]  JIRA:BOT-1633  qTest:30997989  Regression
    ${ws_error}  Run Keyword And Expect Error  *  setSitePolicy  ${site_policy}  ADD  ${policy}f
    Should Contain  ${ws_error}  For input string:

Empty Policy
    [Documentation]  Insert an Empty Policy parameter and expect an error.
    [Tags]  JIRA:BOT-1633  qTest:30997990  Regression
    ${ws_error}  Run Keyword And Expect Error  *  setSitePolicy  ${site_policy}  ADD  ${empty}
    Should Contain  ${ws_error}  For input string:

*** Keywords ***
Setup WS
    Get Into DB  TCH

    log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

Teardown WS
    Disconnect From Database
    Logout

Get Policies That Belongs to a Site Policy
    [Arguments]  ${carrier_id}  ${site_policy}
    ${query}  Catenate  SELECT policy_id as policy FROM site_policy_policies WHERE carrier_id='${carrier_id}' and site_policy_id='${site_policy}'
    ${database}  query and strip to dictionary  ${query}
    [Return]  ${database}