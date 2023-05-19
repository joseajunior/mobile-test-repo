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
${groupId}  2965

*** Test Cases ***

Valid Parameters For All Fields
    [Documentation]  Insert all parameters and expect a positive response.
    [Tags]  JIRA:BOT-1882  qTest:31799510  Regression
    [Setup]  Setup Test Case
    removeLocGrp  ${groupId}
    Row Count Is 0  SELECT * FROM loc_grp WHERE carrier_id='${validCard.carrier.id}' AND grp_id='${groupId}' AND name='BOT-1882'

Invalid Group ID
    [Documentation]  Insert Invalid Group ID parameter and expect an error.
    [Tags]  JIRA:BOT-1882  qTest:31799511  Regression
    [Setup]  Setup Test Case
    Run Keyword And Expect Error  *  removeLocGrp  1nv@l1d

Typo Group ID
    [Documentation]  Insert Typo Group ID parameter and expect an error.
    [Tags]  JIRA:BOT-1882  qTest:31799512  Regression
    [Setup]  Setup Test Case
    Run Keyword And Expect Error  *  removeLocGrp  ${groupId}f

Empty Group ID
    [Documentation]  Insert an Empty Group ID parameter and expect an error.
    [Tags]  JIRA:BOT-1882  qTest:31799513  Regression
    [Setup]  Setup Test Case
    Run Keyword And Expect Error  *  removeLocGrp  ${empty}

*** Keywords ***
Setup WS
    Get Into DB  TCH
    log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

Setup Test Case
    ${return}  Query and Strip  SELECT 1 FROM loc_grp WHERE carrier_id='${validCard.carrier.id}' AND grp_id='${groupId}' AND name='BOT-1882'
    Run Keyword If  '${return}'!='1'
    ...  execute sql string   dml=INSERT INTO loc_grp (grp_id, name, carrier_id) VALUES (2965, 'BOT-1882', 103866);

Teardown WS
    Disconnect From Database
    Logout
