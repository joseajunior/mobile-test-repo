*** Settings ***
Resource  ../../Variables/validUser.robot
Library  String
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  Collections
Library  otr_robot_lib.setup.PySetup
Resource  otr_robot_lib/robot/RobotKeywords.robot

Force Tags  Web Services
Suite Setup  Setup WS
Suite Teardown  Teardown WS

*** Variables ***
${groupId}  2816

*** Test Cases ***
Valid Input
    [Tags]  JIRA:BOT-1896  qTest:  Regression
    [Documentation]
    ${status}  Run Keyword And Return Status  getLocGrpRule  ${groupId}
    Should Be True  ${status}

Invalid Group Id
    [Tags]  JIRA:BOT-1896  qTest:  Regression
    [Documentation]
    ${groupId}  Set Variable  1nv@l1d
    ${status}  Run Keyword And Return Status  getLocGrpRule  ${groupId}
    Should Not Be True  ${status}

Empty Group Id
    [Tags]  JIRA:BOT-1896  qTest:  Regression
    [Documentation]
    ${groupId}  Set Variable  ${EMPTY}
    ${status}  Run Keyword And Return Status  getLocGrpRule  ${groupId}
    Should Not Be True  ${status}

TYPO Group Id
    [Tags]  JIRA:BOT-1896  qTest:  Regression
    [Documentation]
    ${groupId}  Set Variable  ${groupId}f
    ${status}  Run Keyword And Return Status  getLocGrpRule  ${groupId}
    Should Not Be True  ${status}

*** Keywords ***

Setup WS
    Get Into DB  TCH
    ${query}  Catenate
    ...  SELECT member_id, TRIM(passwd) as passwd FROM member WHERE member_id = ${validCard.carrier.id}
    ${output}  Query And Strip To Dictionary  ${query}
    log into card management web services  ${output['member_id']}  ${output['passwd']}

Teardown WS
    Disconnect From Database
    logout


