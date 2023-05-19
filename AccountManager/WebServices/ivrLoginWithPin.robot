*** Settings ***
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary

Force Tags  Web Services

*** Variables ***
${carrierId}  700233
${callinId}  4242
${callinPin}  4593

*** Test Cases ***

Valid Parameters For All Fields
    [Documentation]  Insert all parameters and expect a positive response.
    [Tags]  JIRA:BOT-1624  qTest:31883011  Regression  refactor
    [Setup]  Setup Test Case
    ${status}  Run Keyword and Return Status  ivrLoginWithPin  ${carrierId}  ${callinId}  ${callinPin}
    Should Be True  ${status}

Invalid Carrier ID
    [Documentation]  Insert Invalid Carrier ID parameter and expect an error.
    [Tags]  JIRA:BOT-1624  qTest:31883012  Regression
    [Setup]  Setup Test Case
    Run Keyword And Expect Error  *  ivrLoginWithPin  1nv@l1d  ${callinId}  ${callinPin}

Typo Carrier ID
    [Documentation]  Insert Typo Carrier ID parameter and expect an error.
    [Tags]  JIRA:BOT-1624  qTest:31883013  Regression
    [Setup]  Setup Test Case
    Run Keyword And Expect Error  *  ivrLoginWithPin  ${carrierId}f  ${callinId}  ${callinPin}

Empty Carrier ID
    [Documentation]  Insert an Empty Carrier ID parameter and expect an error.
    [Tags]  JIRA:BOT-1624  qTest:31883014  Regression
    [Setup]  Setup Test Case
    Run Keyword And Expect Error  *  ivrLoginWithPin  ${empty}  ${callinId}  ${callinPin}

Invalid Callin ID
    [Documentation]  Insert Invalid Callin ID parameter and expect an error.
    [Tags]  JIRA:BOT-1624  qTest:31883015  Regression
    [Setup]  Setup Test Case
    Run Keyword And Expect Error  *  ivrLoginWithPin  ${carrierId}  1nv@l1d  ${callinPin}

Typo Callin ID
    [Documentation]  Insert Typo Callin ID parameter and expect an error.
    [Tags]  JIRA:BOT-1624  qTest:31883016  Regression
    [Setup]  Setup Test Case
    Run Keyword And Expect Error  *  ivrLoginWithPin  ${carrierId}  ${callinId}f  ${callinPin}

Empty Callin ID
    [Documentation]  Insert an Empty Callin ID parameter and expect an error.
    [Tags]  JIRA:BOT-1624  qTest:31883017  Regression
    [Setup]  Setup Test Case
    Run Keyword And Expect Error  *  ivrLoginWithPin  ${carrierId}  ${empty}  ${callinPin}

Invalid Callin PIN
    [Documentation]  Insert Invalid Callin PIN parameter and expect an error.
    [Tags]  JIRA:BOT-1624  qTest:31883018  Regression
    [Setup]  Setup Test Case
    Run Keyword And Expect Error  *  ivrLoginWithPin  ${carrierId}  ${callinId}  1nv@l1d

Typo Callin PIN
    [Documentation]  Insert Typo Callin PIN parameter and expect an error.
    [Tags]  JIRA:BOT-1624  qTest:31883019  Regression
    [Setup]  Setup Test Case
    Run Keyword And Expect Error  *  ivrLoginWithPin  ${carrierId}  ${callinId}  ${callinPin}f

Empty Callin PIN
    [Documentation]  Insert an Empty Callin PIN parameter and expect an error.
    [Tags]  JIRA:BOT-1624  qTest:31883020  Regression
    [Setup]  Setup Test Case
    Run Keyword And Expect Error  *  ivrLoginWithPin  ${carrierId}  ${callinId}  ${empty}

*** Keywords ***
Setup Test Case
    Get Into DB  MySQL
    execute sql string   dml=UPDATE sec_user SET status_id='A' WHERE user_id='FLT_IvrLoginBOT'