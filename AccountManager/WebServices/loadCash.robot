*** Settings ***
Resource  ../../Variables/validUser.robot
Library  String
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  Collections
Resource  otr_robot_lib/robot/RobotKeywords.robot

Force Tags  Web Services

*** Test Cases ***

Loading a Cash
    [Tags]  JIRA:BOT-1581  qTest:30782144  Regression  refactor
    [Documentation]  Validate that you can load a Cash
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    Set Test Variable  ${cardNumber}  7083050910386614158
    Set Test Variable  ${amount}  10
    Set Test Variable  ${refNumber}  Hey
    Set Test Variable  ${payroll}  ${EMPTY}
    ${status}  Run Keyword And Return Status  loadCash  ${cardNumber}  ${amount}  ${refNumber}  ${payroll}
    Should Be True  ${status}
    [Teardown]  Logout

Check TYPO on the cardNumber
    [Tags]  JIRA:BOT-1581  qTest:30782154  Regression
    [Documentation]  Validate that you cannot load a Cash with a typo on cardNumber
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    Set Test Variable  ${cardNumber}  7083050910386614158
    Set Test Variable  ${amount}  10
    Set Test Variable  ${refNumber}  Hey
    Set Test Variable  ${payroll}  0
    ${status}  Run Keyword And Return Status  loadCash  ${cardNumber}AAA  ${amount}  ${refNumber}  ${payroll}
    Should Not Be True  ${status}
    [Teardown]  Logout

Check TYPO on the amount
    [Tags]  JIRA:BOT-1581  qTest:30782163  Regression
    [Documentation]  Validate that you cannot load a Cash with a typo on amount
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    Set Test Variable  ${cardNumber}  7083050910386614158
    Set Test Variable  ${amount}  10
    Set Test Variable  ${refNumber}  Hey
    Set Test Variable  ${payroll}  0
    ${status}  Run Keyword And Return Status  loadCash  ${cardNumber}  ${amount}AAA  ${refNumber}  ${payroll}
    Should Not Be True  ${status}
    [Teardown]  Logout

Check TYPO on the payroll
    [Tags]  JIRA:BOT-1581  qTest:30782187  Regression
    [Documentation]  Validate that you cannot load a Cash with a typo on payroll
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    Set Test Variable  ${cardNumber}  7083050910386614158
    Set Test Variable  ${amount}  10
    Set Test Variable  ${refNumber}  Hey
    Set Test Variable  ${payroll}  0
    ${status}  Run Keyword And Return Status  loadCash  ${cardNumber}  ${amount}  ${refNumber}  ${payroll}AAA
    Should Not Be True  ${status}
    [Teardown]  Logout

Validate EMPTY value on cardNumber
    [Tags]  JIRA:BOT-1581  qTest:30782190  Regression
    [Documentation]  Validate that you cannot load a Cash using an empty cardNumber.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    Set Test Variable  ${cardNumber}  ${EMPTY}
    Set Test Variable  ${amount}  10
    Set Test Variable  ${refNumber}  Hey
    Set Test Variable  ${payroll}  0
    ${status}  Run Keyword And Return Status  loadCash  ${cardNumber}  ${amount}  ${refNumber}  ${payroll}
    Should Not Be True  ${status}
    [Teardown]  Logout

Validate EMPTY value on amount
    [Tags]  JIRA:BOT-1581  qTest:30782203  Regression
    [Documentation]  Validate that you cannot load a Cash using an empty amount.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    Set Test Variable  ${cardNumber}  7083050910386614158
    Set Test Variable  ${amount}  ${EMPTY}
    Set Test Variable  ${refNumber}  Hey
    Set Test Variable  ${payroll}  0
    ${status}  Run Keyword And Return Status  loadCash  ${cardNumber}  ${amount}  ${refNumber}  ${payroll}
    Should Not Be True  ${status}
    [Teardown]  Logout



*** Keywords ***
