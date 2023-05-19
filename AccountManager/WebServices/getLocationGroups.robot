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
${carrier}  144306
${policy}  2
${cardNum}  7083051114430600029

*** Test Cases ***
Valid Policy
    [Tags]  JIRA:BOT-1896  qTest:  Regression
    [Documentation]
    ${status}  Run Keyword And Return Status  getLocationGroups  policyNum=${policy}
    Should Be True  ${status}

Invalid Policy
    [Tags]  JIRA:BOT-1896  qTest:37382866  Regression  JIRA:FRNT-55  refactor
    [Documentation]
    ${status}  Run Keyword And Return Status  getLocationGroups  policyNum=9999
    Should Not Be True  ${status}
    should contain  ${ws_error}  Invalid policy number

Empty Policy
    [Tags]  JIRA:BOT-1896  qTest:  Regression  refactor
    [Documentation]
    ${policy}  Set Variable  ${EMPTY}
    ${status}  Run Keyword And Return Status  getLocationGroups  policyNum=${policy}
    Should Be True  ${status}

TYPO Policy
    [Tags]  JIRA:BOT-1896  qTest:  Regression
    [Documentation]
    ${policy}  Set Variable  ${policy}f
    ${status}  Run Keyword And Return Status  getLocationGroups  policyNum=${policy}
    Should Not Be True  ${status}

Valid Card Num
    [Tags]  JIRA:BOT-1896  qTest:  Regression  refactor
    [Documentation]
    ${status}  Run Keyword And Return Status  getLocationGroups  cardNum=${cardNum}
    Should Be True  ${status}

Invalid Card Num
    [Tags]  JIRA:BOT-1896  qTest:  Regression
    [Documentation]
    ${cardNum}  Set Variable  1nv@l1d
    ${status}  Run Keyword And Return Status  getLocationGroups  cardNum=${cardNum}
    Should Not Be True  ${status}

Empty Card Num
    [Tags]  JIRA:BOT-1896  qTest:  Regression  refactor
    [Documentation]
    ${cardNum}  Set Variable  ${EMPTY}
    ${status}  Run Keyword And Return Status  getLocationGroups  cardNum=${cardNum}
    Should Be True  ${status}

TYPO Card Num
    [Tags]  JIRA:BOT-1896  qTest:  Regression
    [Documentation]
    ${cardNum}  Set Variable  ${cardNum}f
    ${status}  Run Keyword And Return Status  getLocationGroups  cardNum=${cardNum}
    Should Not Be True  ${status}

*** Keywords ***
Setup WS
    Ensure Member is Not Suspended  ${carrier}
    Start Setup Card  ${cardNum}
    Get Into DB  TCH
    ${password}  Get Carrier Password  ${carrier}
    Log Into Card Management Web Services  ${carrier}  ${password}

Teardown WS
    Disconnect From Database
    Logout