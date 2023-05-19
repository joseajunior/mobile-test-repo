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
${card}  5567480000300028
${drid}

*** Test Cases ***
Valid Parameters For All Fields
    [Documentation]  Insert all parameters and expect a positive response.
    [Tags]  JIRA:BOT-1590  qTest:31051814  Regression  refactor
    ${status}  Run Keyword and Return Status  signupScale  ${card}  ${drid}
    Should Be True  ${status}

Invalid Card Number
    [Documentation]  Insert Invalid Card Number parameter and expect an error.
    [Tags]  JIRA:BOT-1590  qTest:31051815  Regression  refactor
    ${return}  signupScale  1nv@l1d_c4rd  ${drid}
    Should Be Equal as Strings  ${return[0]}  Incorrect Data

Typo Card Number
    [Documentation]  Insert Typo Card Number parameter and expect an error.
    [Tags]  JIRA:BOT-1590  qTest:31051816  Regression  refactor
    ${return}  signupScale  ${card}f  ${drid}
    Should Be Equal as Strings  ${return[0]}  Incorrect Data

Empty Card Number
    [Documentation]  Insert an Empty Card Number parameter and expect an error.
    [Tags]  JIRA:BOT-1590  qTest:31051817  Regression  refactor
    ${return}  signupScale  ${empty}  ${drid}
    Should Be Equal as Strings  ${return[0]}  Incorrect Data

Invalid Driver ID
    [Documentation]  Insert Invalid Driver ID parameter and expect an error.
    [Tags]  JIRA:BOT-1590  qTest:31051818  Regression
    ${return}  signupScale  ${card}  1nv@l1d_dr1v3r_1d
    Should Be Equal as Strings  ${return[0]}  Incorrect Data

Typo Driver ID
    [Documentation]  Insert Typo Driver ID parameter and expect an error.
    [Tags]  JIRA:BOT-1590  qTest:31051819  Regression
    ${return}  signupScale  ${card}  ${drid}f
    Should Be Equal as Strings  ${return[0]}  Incorrect Data

Empty Driver ID
    [Documentation]  Insert an Empty Driver ID parameter and expect an error.
    [Tags]  JIRA:BOT-1590  qTest:31051820  Regression
    ${return}  signupScale  ${card}  ${empty}
    Should Be Equal as Strings  ${return[0]}  Incorrect Data

*** Keywords ***
Setup WS
    Get Into DB  TCH
    log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

    ${query}  Catenate  SELECT SUBSTRB(info_validation,2) AS info_validation
    ...                 FROM card_inf
    ...                 WHERE card_num = '${card}'
    ...                 AND info_id = 'DRID';
    ${drid}  Query And Strip   ${query}
    Set Suite Variable  ${drid}

Teardown WS
    Disconnect From Database
    Logout
