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

*** Test Cases ***

Valid Parameters For All Fields
    [Documentation]  Insert all parameters and expect a positive response.
    [Tags]  JIRA:BOT-1597  qTest:31031557  Regression  refactor
    ${moneyCode}  issueMoneyCode  ${contract}  10.00   BOT-1597
    ${status}  Run Keyword and Return Status  voidMoneyCode   ${moneyCode}
    Should Be True  ${status}
    Validate if Money Code is Voided  ${moneyCode}

Invalid Money Code Number
    [Documentation]  Insert Invalid Money Code parameter and expect an error.
    [Tags]  JIRA:BOT-1597  qTest:31031558  Regression
    ${status}  Run Keyword and Return Status  voidMoneyCode   1nv@l1d
    Should Not Be True  ${status}

Typo Money Code Number
    [Documentation]  Insert Typo Money Code parameter and expect an error.
    [Tags]  JIRA:BOT-1597  qTest:31031559  Regression  refactor
    ${moneyCode}  issueMoneyCode  ${contract}  10.00   BOT-1597
    ${status}  Run Keyword and Return Status  voidMoneyCode   ${moneyCode}f
    Should Not Be True  ${status}

Empty Money Code Number
    [Documentation]  Insert an Empty Money Code parameter and expect an error.
    [Tags]  JIRA:BOT-1597  qTest:31031560  Regression
    ${status}  Run Keyword and Return Status  voidMoneyCode   ${empty}
    Should Not Be True  ${status}

*** Keywords ***
Setup WS
    Get Into DB  TCH
    log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

Teardown WS
    Disconnect From Database
    Logout

Validate if Money Code is Voided
    [Arguments]  ${moneyCode}
    ${query}  Catenate  SELECT * FROM mon_codes WHERE express_code='${moneyCode}' AND voided='Y';
    Row Count is Equal to X  ${query}  1


