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
${unit}  2
${code}  ODRD

*** Test Cases ***
Valid Unit
    [Tags]  JIRA:BOT-1898  qTest:  Regression
    [Documentation]
    ${status}  Run Keyword And Return Status  getLastMileage  unit=${unit}
    Should Be True  ${status}

Invalid Unit
    [Tags]  JIRA:BOT-1896  qTest:  Regression
    [Documentation]
    ${unit}  Set Variable  1nv@l1d
    ${status}  Run Keyword And Return Status  getLastMileage  unit=${unit}
    Should Be True  ${status}

Empty Unit
    [Tags]  JIRA:BOT-1896  qTest:  Regression
    [Documentation]
    ${unit}  Set Variable  ${EMPTY}
    ${status}  Run Keyword And Return Status  getLastMileage  unit=${unit}
    Should Be True  ${status}

TYPO Unit
    [Tags]  JIRA:BOT-1896  qTest:  Regression
    [Documentation]
    ${unit}  Set Variable  ${unit}f
    ${status}  Run Keyword And Return Status  getLastMileage  unit=${unit}
    Should Be True  ${status}

Valid Code
    [Tags]  JIRA:BOT-1896  qTest:  Regression
    [Documentation]
    ${status}  Run Keyword And Return Status  getLastMileage  code=${code}
    Should Be True  ${status}

Invalid Code
    [Tags]  JIRA:BOT-1896  qTest:  Regression
    [Documentation]
    ${code}  Set Variable  1nv@l1d
    ${status}  Run Keyword And Return Status  getLastMileage  code=${code}
    Should Be True  ${status}

Empty Code
    [Tags]  JIRA:BOT-1896  qTest:  Regression
    [Documentation]
    ${code}  Set Variable  ${EMPTY}
    ${status}  Run Keyword And Return Status  getLastMileage  code=${code}
    Should Be True  ${status}

TYPO Code
    [Tags]  JIRA:BOT-1896  qTest:  Regression
    [Documentation]
    ${code}  Set Variable  ${code}f
    ${status}  Run Keyword And Return Status  getLastMileage  code=${code}
    Should Be True  ${status}

Valid Unit and Code
    [Tags]  JIRA:BOT-1896  qTest:  Regression
    [Documentation]
    ${status}  Run Keyword And Return Status  getLastMileage  ${unit}  ${code}
    Should Be True  ${status}

*** Keywords ***
Setup WS
    Get Into DB  TCH
    log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

Teardown WS
    Disconnect From Database
    logout