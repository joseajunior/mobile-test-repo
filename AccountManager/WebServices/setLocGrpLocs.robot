*** Settings ***
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary

Force Tags  Web Services  refactor
Suite Setup  Setup WS
Suite Teardown  Teardown WS

*** Variables ***

@{locations}  231001  231002  231003
${groupId}  2863

*** Test Cases ***
Valid Group Id and One Location Id
    [Documentation]  Insert all parameters with one Location Id and expect a positive response.
    [Tags]  JIRA:BOT-1879  qTest:31883125  Regression
    [Setup]  Setup Test Case
    setLocGrpLocs  ${groupId}  ${locations[0]}
    ${return}  getLocGrpLocs  ${groupId}
    Should Be Equal As Strings  ${locations[0]}  ${return}

Valid Group Id and More Than One Valid Location Id
    [Documentation]  Insert all parameters with more than one Location Id and expect a positive response.
    [Tags]  JIRA:BOT-1879  qTest:31883126  Regression
    [Setup]  Setup Test Case
    setLocGrpLocs  ${groupId}  ${locations[0]}  ${locations[1]}  ${locations[2]}
    ${return}  getLocGrpLocs  ${groupId}
    Lists Should Be Equal  ${locations}  ${return}

Invalid Group ID
    [Documentation]  Insert Invalid Group ID parameter and expect an error.
    [Tags]  JIRA:BOT-1879  qTest:31883127  Regression
    [Setup]  Setup Test Case
    Run Keyword And Expect Error  *  setLocGrpLocs  1nv@l1d  ${locations[0]}

Typo Group ID
    [Documentation]  Insert Typo Group ID parameter and expect an error.
    [Tags]  JIRA:BOT-1879  qTest:31883128  Regression
    [Setup]  Setup Test Case
    Run Keyword And Expect Error  *  setLocGrpLocs  ${groupId}f  ${locations[0]}

Empty Group ID
    [Documentation]  Insert an Empty Group ID parameter and expect an error.
    [Tags]  JIRA:BOT-1879  qTest:31883129  Regression
    [Setup]  Setup Test Case
    Run Keyword And Expect Error  *  setLocGrpLocs  ${empty}  ${locations[0]}

Invalid Location ID
    [Documentation]  Insert Invalid Location ID parameter and expect an error.
    [Tags]  JIRA:BOT-1879  qTest:31883130  Regression
    [Setup]  Setup Test Case
    Run Keyword And Expect Error  *  setLocGrpLocs  ${groupId}  1nv@l1d

Typo Location ID
    [Documentation]  Insert Typo Location ID parameter and expect an error.
    [Tags]  JIRA:BOT-1879  qTest:31883131  Regression
    [Setup]  Setup Test Case
    Run Keyword And Expect Error  *  setLocGrpLocs  ${groupId}  ${locations[0]}f

Empty Location ID
    [Documentation]  Insert an Empty Location ID parameter and expect an error.
    [Tags]  JIRA:BOT-1879  qTest:31883132  Regression
    [Setup]  Setup Test Case
    Run Keyword And Expect Error  *  setLocGrpLocs  ${groupId}  ${empty}

*** Keywords ***
Setup WS
    Get Into DB  TCH

    Log Into Card Management Web Services  ${validCard.carrier.id}  ${validCard.carrier.password}

Setup Test Case
    setLocGrpLocs  ${groupId}  231010
    ${return}  getLocGrpLocs  ${groupId}
    Should Be Equal As Strings  231010  ${return}

Teardown WS
    Disconnect From Database
    Logout
