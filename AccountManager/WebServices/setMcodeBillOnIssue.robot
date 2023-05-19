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
${contract}  ${validCard.contract.id}
${flag}

*** Test Cases ***

Valid Parameters For All Fields and ynFlag=Y
    [Documentation]  Insert all parameters and expect a positive response.
    [Tags]  JIRA:BOT-1877  qTest:31798625  Regression
    ${return}  setMCodeBillOnIssue  ${contract}  Y
    Should Be Equal as Strings  ${return}  success
    Validate Money Code Bill On Issue  ${contract}  Y

Valid Parameters For All Fields and ynFlag=N
    [Documentation]  Insert all parameters and expect a positive response.
    [Tags]  JIRA:BOT-1877  qTest:31798626  Regression
    ${return}  setMcodeBillOnIssue  ${contract}  N
    Should Be Equal as Strings  ${return}  success
    Validate Money Code Bill On Issue  ${contract}  N

Invalid Contract ID
    [Documentation]  Insert Invalid Contract ID parameter and expect an error.
    [Tags]  JIRA:BOT-1877  qTest:31798627  Regression
    Run Keyword And Expect Error  *  setMcodeBillOnIssue  1nv@l1d  N

Typo Contract ID
    [Documentation]  Insert Typo Contract ID parameter and expect an error.
    [Tags]  JIRA:BOT-1877  qTest:31798628  Regression
    Run Keyword And Expect Error  *  setMcodeBillOnIssue  ${contract}f  N

Empty Contract ID
    [Documentation]  Insert an Empty Contract ID parameter and expect an error.
    [Tags]  JIRA:BOT-1877  qTest:31798629  Regression
    ${return}  setMcodeBillOnIssue  ${empty}  N
    Should Not Be Equal as Strings  ${return}  success

Invalid Flag
    [Documentation]  Insert Invalid Flag parameter and expect an error.
    [Tags]  JIRA:BOT-1877  qTest:31798630  Regression
    ${return}  setMcodeBillOnIssue  ${contract}  1nv@l1d
    Should Not Be Equal as Strings  ${return}  success

Typo Flag
    [Documentation]  Insert Typo Flag parameter and expect an error.
    [Tags]  JIRA:BOT-1877  qTest:31798631  Regression
    ${return}  setMcodeBillOnIssue  ${contract}  Nf
    Should Not Be Equal as Strings  ${return}  success

Empty Flag
    [Documentation]  Insert an Empty Flag parameter and expect an error.
    [Tags]  JIRA:BOT-1877  qTest:31798632  Regression
    ${return}  setMcodeBillOnIssue  ${contract}  ${empty}
    Should Not Be Equal as Strings  ${return}  success

*** Keywords ***
Setup WS
    Get Into DB  TCH

    log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

    ${query}  Catenate  SELECT mcode_bill_on_issue FROM contract where contract_id='${contract}'
    ${flag}  Query and Strip  ${query}

    Set Suite Variable  ${flag}

Teardown WS
    execute sql string   dml=UPDATE contract SET mcode_bill_on_issue = '${flag}' WHERE contract_id = ${contract};
    Disconnect From Database
    Logout

Validate Money Code Bill On Issue
    [Arguments]  ${contract_id}  ${ynFlag}
    ${query}  Catenate  SELECT * FROM contract WHERE contract_id='${contract_id}' AND mcode_bill_on_issue='${ynFlag}';
    Row Count Is Equal To X  ${query}  1