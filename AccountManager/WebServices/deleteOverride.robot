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
Valid Card Number Field
    [Documentation]
    [Tags]  JIRA:BOT-1602  qTest:30919589  Regression
    ${ws_mobile_roles}  deleteOverride  ${validCard.card_num}
    should be equal  ${ws_mobile_roles}  ${None}

Empty Card Number Field
    [Documentation]
    [Tags]  JIRA:BOT-1602  qTest:30919591  Regression  refactor
    ${message}  Run Keyword And Expect Error  *  deleteOverride  ${EMPTY}
    should start with  ${ws_error}  ERROR running command

Invalid Card Number Field
    [Documentation]
    [Tags]  JIRA:BOT-1602  qTest:30919592  Regression  refactor
    ${message}  Run Keyword And Expect Error  *  deleteOverride  1nv@l1d_c@rd
    should start with  ${ws_error}  ERROR running command

Typo Card Number Field
    [Documentation]
    [Tags]  JIRA:BOT-1602  qTest:30919590  Regression  refactor
    ${message}  Run Keyword And Expect Error  *  deleteOverride  ${validCard.card_num}f
    should start with  ${ws_error}  ERROR running command


*** Keywords ***
Setup WS
    log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

Teardown WS
    logout