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
${account}  5382
${amount}  1

*** Test Cases ***

Valid Parameters For All Fields
    [Documentation]  Insert all parameters and expect a positive response.
    [Tags]  JIRA:BOT-1596  qTest:31080722  Regression  refactor
    ${transfer_id}  doSmartPayAchTransfer  ${account}  ${card}  ${amount}
    Check if Transfer is on Database  ${transfer_id}  ${account}  ${card}  ${amount}
    Should Not Be Empty  ${transfer_id}

Empty Reference Number
    [Documentation]  Insert all parameters and expect a positive response.
    [Tags]  JIRA:BOT-1596  qTest:31080723  Regression  refactor
    ${transfer_id}  doSmartPayAchTransfer  ${account}  ${card}  ${amount}  ${empty}
    Check if Transfer is on Database  ${transfer_id}  ${account}  ${card}  ${amount}
    log to console  ${transfer_id}
    Should Not Be Empty  ${transfer_id}

Invalid Account Number
    [Documentation]  Insert Invalid Account Number parameter and expect an error.
    [Tags]  JIRA:BOT-1596  qTest:31080724  Regression
    Run Keyword And Expect Error  *  doSmartPayAchTransfer   999999999  ${card}  ${amount}

Typo Account Number
    [Documentation]  Insert Typo Account Number parameter and expect an error.
    [Tags]  JIRA:BOT-1596  qTest:31080725  Regression
    Run Keyword And Expect Error  *  doSmartPayAchTransfer   ${account}f  ${card}  ${amount}

Empty Account Number
    [Documentation]  Insert an Empty Account Number parameter and expect an error.
    [Tags]  JIRA:BOT-1596  qTest:31080726  Regression
    Run Keyword And Expect Error  *  doSmartPayAchTransfer   ${empty}  ${card}  ${amount}

Invalid Card Number False Pass
    [Documentation]  Insert Invalid Card Number parameter and expect an error.
    [Tags]  JIRA:BOT-1596  qTest:31080727  Regression  BUGGED:Should not allow transfer.
    ${transfer_id}  doSmartPayAchTransfer   ${account}  1nv@l1d_c4rd  ${amount}
    Check if Transfer is on Database  ${transfer_id}  ${account}  1nv@l1d_c4rd  ${amount}  Invalid

Typo Card Number False Pass
    [Documentation]  Insert Typo Card Number parameter and expect an error.
    [Tags]  JIRA:BOT-1596  qTest:31080728  Regression  BUGGED:Should not allow transfer.
    ${transfer_id}  doSmartPayAchTransfer   ${account}  ${card}f  ${amount}
    Check if Transfer is on Database  ${transfer_id}  ${account}  ${card}f  ${amount}  Invalid

Empty Card Number
    [Documentation]  Insert an Empty Card Number parameter and expect an error.
    [Tags]  JIRA:BOT-1596  qTest:31080729  Regression
    Run Keyword And Expect Error  *  doSmartPayAchTransfer   ${account}  ${empty}  ${amount}

Invalid Amount
    [Documentation]  Insert Invalid Amount parameter and expect an error.
    [Tags]  JIRA:BOT-1596  qTest:31080730  Regression
    Run Keyword And Expect Error  *  doSmartPayAchTransfer   ${account}  ${card}  -${amount}

Typo Amount
    [Documentation]  Insert Typo Amount parameter and expect an error.
    [Tags]  JIRA:BOT-1596  qTest:31080731  Regression
    Run Keyword And Expect Error  *  doSmartPayAchTransfer   ${account}  ${card}  f${amount}

Empty Amount
    [Documentation]  Insert an Empty Amount parameter and expect an error.
    [Tags]  JIRA:BOT-1596  qTest:31080732  Regression
    Run Keyword And Expect Error  *  doSmartPayAchTransfer   ${account}  ${card}  ${empty}

*** Keywords ***
Setup WS
    Get Into DB  TCH
    ${password}  Get Carrier Password  ${carrier}
    log into card management web services  ${carrier}  ${password}

Teardown WS
    Disconnect From Database
    Logout

Check if Transfer is on Database
    [Arguments]  ${transfer_id}  ${account}  ${card}  ${amount}  ${valid}=valid
    ${query}  Catenate  SELECT * FROM ach_ppd_detail
    ...  WHERE ppd_detail_id ='${transfer_id}'
    ...  AND ppd_header_id='${account}'
    ...  AND created_by='${card}'
    ...  AND amount='${amount}'

    Run Keyword If  '${valid}'=='valid'
    ...  Row Count Is Equal to X  ${query}  1
    ...  ELSE  Row Count Is Equal to X  ${query}  0