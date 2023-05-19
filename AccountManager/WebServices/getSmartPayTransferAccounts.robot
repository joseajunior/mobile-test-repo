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
${carrier}  141526
${card}  7083051014152600035

*** Test Cases ***

Valid Parameters For All Fields
    [Documentation]  Insert all parameters and expect a positive response.
    [Tags]  JIRA:BOT-1595  qTest:31048154  Regression
    ${return}  getSmartPayTransferAccounts   ${card}
    Should Not Be Empty  ${return}

Invalid Card Number
    [Documentation]  Insert Invalid Card Number parameter and expect an error.
    [Tags]  JIRA:BOT-1595  qTest:31048155  Regression
    Run Keyword And Expect Error  *  getSmartPayTransferAccounts   1nv@l1d_c4rd

Typo Card Number
    [Documentation]  Insert Typo Card Number parameter and expect an error.
    [Tags]  JIRA:BOT-1595  qTest:31048157  Regression
    Run Keyword And Expect Error  *  getSmartPayTransferAccounts   ${card}f

Empty Card Number
    [Documentation]  Insert an Empty Card Number parameter and expect all accounts available on carrier.
    [Tags]  JIRA:BOT-1595  qTest:31048158  Regression
    ${return}  getSmartPayTransferAccounts   ${empty}
    Should Not Be Empty  ${return}

*** Keywords ***
Setup WS
    Get Into DB  TCH
    ${password}  Get Carrier Password  ${carrier}
    log into card management web services  ${carrier}  ${password}

Teardown WS
    Disconnect From Database
    Logout
